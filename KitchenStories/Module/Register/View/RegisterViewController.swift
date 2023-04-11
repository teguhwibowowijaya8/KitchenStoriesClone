//
//  RegisterViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let registerTitleLabelText = "to discover all our tastebud tickling recipes and features."
    private let termsAndConditionText = "By signing up I accept the terms of use and the data privacy policy"
    private let alreadyHaveAnAccountText = "Already have an account?"
    
    private var registerViewModel: RegisterViewModel?
    
    @IBOutlet weak var backgroundImageView: BackgroundImageView! {
        didSet {
            backgroundImageView.image = BackgroundImage.background1.image
        }
    }
    
    @IBOutlet weak var registerFormContainerView: UIView! {
        didSet {
            registerFormContainerView.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var registerTitleLabel: UILabel! {
        didSet {
            registerTitleLabel.text = "Sign Up"
            registerTitleLabel.font = .boldSystemFont(ofSize: 30)
            registerTitleLabel.numberOfLines = 0
            registerTitleLabel.textColor = .white
        }
    }

    @IBOutlet weak var registerSubitleLabel: UILabel! {
        didSet {
            registerSubitleLabel.text = registerTitleLabelText
            registerSubitleLabel.font = .boldSystemFont(ofSize: 16)
            registerSubitleLabel.numberOfLines = 0
            registerSubitleLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var registerEmailTextField: BottomBorderTextField! {
        didSet {
            registerEmailTextField.setPlaceholder("Email")
        }
    }
    
    @IBOutlet weak var registerUsernameTextField: BottomBorderTextField! {
        didSet {
            registerUsernameTextField.setPlaceholder("Username")
            registerUsernameTextField.isHidden = true
            registerUsernameTextField.textContentType = .emailAddress
            registerUsernameTextField.tintColor = .white
        }
    }
    
    @IBOutlet weak var registerPasswordTextField: BottomBorderTextField! {
        didSet {
            registerPasswordTextField.setPlaceholder("Password")
            registerPasswordTextField.textContentType = .password
            registerPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            errorMessageLabel.text = registerViewModel?.errorMessage
            errorMessageLabel.textColor = .red
            errorMessageLabel.numberOfLines = 0
            errorMessageLabel.textAlignment = .center
            errorMessageLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            
            errorMessageLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var registerButton: RoundedCornersButton! {
        didSet {
            registerButton.buttonTitle = "Join Kitchen Stories"
            registerButton.addTarget(self, action: #selector(onRegisterButtonSelected), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var registerSecondSubtitleTextView: UITextView! {
        didSet {
            registerSecondSubtitleTextView.backgroundColor = .clear
            registerSecondSubtitleTextView.attributedText = secondSubtitleAttributedString()
            registerSecondSubtitleTextView.textAlignment = .center
            registerSecondSubtitleTextView.textContainerInset = .zero
            registerSecondSubtitleTextView.contentInset = .zero
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setAttributedTitle(
                NSAttributedString(
                    string: "LOG IN HERE",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                        .foregroundColor: UIColor.orange,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                ),
                for: .normal
            )
            loginButton.addTarget(self, action: #selector(onSelectedToLogin), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    private func setupViewModel() {
        registerViewModel = RegisterViewModel()
        registerViewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func onSelectedToLogin(_ sender: UIButton) {
        let loginVc = LoginViewController()
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
    @objc func onRegisterButtonSelected(_ sender: UIButton) {
        guard let email = registerEmailTextField.text,
              let password = registerPasswordTextField.text
        else { return }
        
        disableForm()
        registerViewModel?.registerUser(email: email, password: password)
    }
    
    private func disableForm() {
        registerEmailTextField.isUserInteractionEnabled = false
        registerPasswordTextField.isUserInteractionEnabled = false
        registerButton.isUserInteractionEnabled = false
        loginButton.isUserInteractionEnabled = false
    }
    
    private func secondSubtitleAttributedString() -> NSAttributedString {
        let secondSubtitleAttributedString = NSMutableAttributedString(string: termsAndConditionText, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ])
        
        let alreadyHaveAnAccountString = NSAttributedString(string: "\n\n\(alreadyHaveAnAccountText)", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        
        secondSubtitleAttributedString.append(alreadyHaveAnAccountString)
        return secondSubtitleAttributedString
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func handleOnRegisterCompleted() {
        if let errorMessage = registerViewModel?.errorMessage {
            DispatchQueue.main.async {
                self.errorMessageLabel.text = errorMessage
                self.errorMessageLabel.isHidden = false
                self.enableForm()
                return
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
    
    private func enableForm() {
        registerEmailTextField.isUserInteractionEnabled = true
        registerPasswordTextField.isUserInteractionEnabled = true
        registerButton.isUserInteractionEnabled = true
        loginButton.isUserInteractionEnabled = true
    }
}
