//
//  RegisterViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 10/04/23.
//

import Foundation
import FirebaseAuth

protocol RegisterViewModelDelegate {
    func handleOnRegisterCompleted()
}

class RegisterViewModel {
    
    let registerTitleLabelText = "to discover all our tastebud tickling recipes and features."
    let termsAndConditionText = "By signing up I accept the terms of use and the data privacy policy"
    let alreadyHaveAnAccountText = "Already have an account?"
    
    var errorMessage: String? = nil
    var delegate: RegisterViewModelDelegate?
    
    func registerUser(email: String, password: String) {
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
            if let result = result {
                print(result.user.uid)
            }
            self?.delegate?.handleOnRegisterCompleted()
        }
    }
}
