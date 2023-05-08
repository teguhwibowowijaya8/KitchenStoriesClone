//
//  LoginViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 10/04/23.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate {
    func handleUserSignInUserCompleted()
}

class LoginViewModel {
    
    let loginTitleLabelText = "to discover all our tastebud tickling recipes and features."
    let termsAndConditionText = "By signing up I accept the terms of use and the data privacy policy"
    let doesntHaveAnAccountText = "Doesn't have an account?"
    let forgotPasswordLabelText = "Already have an account, but forgot your password?"
    
    var errorMessage: String?
    var delegate: LoginViewModelDelegate?
    
    func userSignIn(email: String, password: String) {
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
            
            self?.delegate?.handleUserSignInUserCompleted()
        }
    }
}
