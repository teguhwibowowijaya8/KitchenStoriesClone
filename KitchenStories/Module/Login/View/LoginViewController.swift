//
//  LoginViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 09/04/23.
//

import UIKit

enum LoginNextPage: Int {
    case signUp
    case forgotPassword
}

class LoginViewController: UIViewController {
    
    private let loginTitleLabelText = "to discover all our tastebud tickling recipes and features."
    private let termsAndConditionText = "By signing up I accept the terms of use and the data privacy policy"
    private let doesntHaveAnAccountText = "Doesn't have an account?"
    private let forgotPasswordLabelText = "Already have an account, but forgot your password?"
    
    private var loginViewModel: LoginViewModel?
    
    @IBOutlet weak var backgroundImageView: BackgroundImageView! {
        didSet {
            backgroundImageView.image = BackgroundImage.background3.image
        }
    }
    
    @IBOutlet weak var loginFormContainerView: UIView! {
        didSet {
            loginFormContainerView.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var loginTitleLabel: UILabel! {
        didSet {
            loginTitleLabel.text = "Sign In"
            loginTitleLabel.font = .boldSystemFont(ofSize: 30)
            loginTitleLabel.numberOfLines = 0
            loginTitleLabel.textColor = .white
        }
    }

    @IBOutlet weak var loginSubitleLabel: UILabel! {
        didSet {
            loginSubitleLabel.text = loginTitleLabelText
            loginSubitleLabel.font = .boldSystemFont(ofSize: 16)
            loginSubitleLabel.numberOfLines = 0
            loginSubitleLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var loginEmailTextField: BottomBorderTextField! {
        didSet {
            loginEmailTextField.setPlaceholder("Email")
            loginEmailTextField.textContentType = .emailAddress
        }
    }
    
    @IBOutlet weak var loginPasswordTextField: BottomBorderTextField! {
        didSet {
            loginPasswordTextField.setPlaceholder("Password")
            loginPasswordTextField.textContentType = .password
            loginPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            errorMessageLabel.text = loginViewModel?.errorMessage
            errorMessageLabel.textColor = .red
            errorMessageLabel.numberOfLines = 0
            errorMessageLabel.textAlignment = .center
            errorMessageLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            
            errorMessageLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var loginButton: RoundedCornersButton! {
        didSet {
            loginButton.buttonTitle = "Sign In"
            
            loginButton.addTarget(self, action: #selector(onLoginButtonSelected), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var loginSecondSubtitleTextView: UITextView! {
        didSet {
            loginSecondSubtitleTextView.backgroundColor = .clear
            loginSecondSubtitleTextView.attributedText = secondSubtitleAttributedString()
            loginSecondSubtitleTextView.textAlignment = .center
            loginSecondSubtitleTextView.textContainerInset = .zero
            loginSecondSubtitleTextView.contentInset = .zero
        }
    }
    
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setAttributedTitle(
                NSAttributedString(
                    string: "SIGN UP HERE",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                        .foregroundColor: UIColor.orange,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                ),
                for: .normal
            )
            
            registerButton.tag = LoginNextPage.signUp.rawValue
            registerButton.addTarget(self, action: #selector(onSelectedToNextPage), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var forgotPasswordLabel: UILabel! {
        didSet {
            forgotPasswordLabel.text = forgotPasswordLabelText
            forgotPasswordLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            forgotPasswordLabel.textColor = .white
            forgotPasswordLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.setAttributedTitle(
                NSAttributedString(
                    string: "FORGOT YOUR PASSWORD?",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                        .foregroundColor: UIColor.orange,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                ),
                for: .normal
            )
            
            forgotPasswordButton.tag = LoginNextPage.forgotPassword.rawValue
            forgotPasswordButton.addTarget(self, action: #selector(onSelectedToNextPage), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    @objc func onSelectedToNextPage(_ sender: UIButton) {
        switch LoginNextPage(rawValue: sender.tag) {
        case .signUp:
            let registerVc = RegisterViewController()
            navigationController?.pushViewController(registerVc, animated: true)
        default:
            return
        }
    }
    
    @objc func onLoginButtonSelected(_ sender: UIButton) {
        guard let email = loginEmailTextField.text,
              let password = loginPasswordTextField.text
        else { return }

        disableForm()
        loginViewModel?.userSignIn(email: email, password: password)
    }
    
    private func disableForm() {
        loginEmailTextField.isUserInteractionEnabled = false
        loginPasswordTextField.isUserInteractionEnabled = false
        loginButton.isUserInteractionEnabled = false
        registerButton.isUserInteractionEnabled = false
        forgotPasswordButton.isUserInteractionEnabled = false
    }

    private func setupViewModel() {
        loginViewModel = LoginViewModel()
        loginViewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func secondSubtitleAttributedString() -> NSAttributedString {
        let secondSubtitleAttributedString = NSMutableAttributedString(string: termsAndConditionText, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ])
        
        let alreadyHaveAnAccountString = NSAttributedString(string: "\n\n\(doesntHaveAnAccountText)", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        
        secondSubtitleAttributedString.append(alreadyHaveAnAccountString)
        return secondSubtitleAttributedString
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func handleUserSignInUserCompleted() {
        if let errorMessage = loginViewModel?.errorMessage {
            DispatchQueue.main.async {
                self.errorMessageLabel.text = errorMessage
                self.errorMessageLabel.isHidden = false
                self.enableForm()
            }
        } else {
            self.errorMessageLabel.isHidden = true
            let tabBarVc = TabBarController()
//            let rootVC = UINavigationController(rootViewController: tabBarVc)
//            self.navigationController?.pushViewController(rootVC, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .transitionCrossDissolve) {
                let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
                window?.rootViewController = tabBarVc
                window?.makeKeyAndVisible()
            }
        }
    }
    
    func enableForm() {
        loginEmailTextField.isUserInteractionEnabled = true
        loginPasswordTextField.isUserInteractionEnabled = true
        loginButton.isUserInteractionEnabled = true
        registerButton.isUserInteractionEnabled = true
        forgotPasswordButton.isUserInteractionEnabled = true
    }
}
