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
    
    @IBOutlet weak var backgroundImageView: BackgroundImageView! {
        didSet {
            backgroundImageView.image = Constant.kitchenBackgroundImage1
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
        }
    }
    
    @IBOutlet weak var registerPasswordTextField: BottomBorderTextField! {
        didSet {
            registerPasswordTextField.setPlaceholder("Password")
        }
    }
    
    @IBOutlet weak var registerButton: RoundedCornersButton! {
        didSet {
            registerButton.buttonTitle = "Join Kitchen Stories"
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
                        .foregroundColor: UIColor.white,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                ),
                for: .normal
            )
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
