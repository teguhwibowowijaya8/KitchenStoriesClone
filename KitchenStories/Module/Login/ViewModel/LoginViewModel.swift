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
    var errorMessage: String?
    var delegate: LoginViewModelDelegate?
    
    func userSignIn(email: String, password: String) {
        errorMessage = nil
        print("here2")
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                self?.errorMessage = error.localizedDescription
            } else {
                print(result?.user.uid)
            }
            
            self?.delegate?.handleUserSignInUserCompleted()
        }
    }
}
