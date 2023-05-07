//
//  RegisterViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 10/04/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol RegisterViewModelDelegate {
    func handleOnRegisterCompleted()
}

class RegisterViewModel {
    
    let registerTitleLabelText = "to discover all our tastebud tickling recipes and features."
    let termsAndConditionText = "By signing up I accept the terms of use and the data privacy policy"
    let alreadyHaveAnAccountText = "Already have an account?"
    
    var errorMessage: String? = nil
    var delegate: RegisterViewModelDelegate?
    
    func registerUser(registerUser: RegisterUserModel, password: String) {
        errorMessage = nil

        Auth.auth().createUser(withEmail: registerUser.email, password: password) {
            [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            } else if let result = result {
                print(result.user.uid)
                let uid = result.user.uid
                let db = Firestore.firestore()
                do {
                    let encodedProfile = try JSONEncoder().encode(registerUser)
                    let dictionaryProfile = try JSONSerialization.jsonObject(with: encodedProfile, options: []) as? [String: Any]
                    
                    if let dictionaryProfile = dictionaryProfile {
                        db.collection("users").document(uid).setData(dictionaryProfile) { firestoreError in
                            if let firestoreError = firestoreError {
                                self?.errorMessage = "Error add data to Database: \(firestoreError.localizedDescription)"
                                return
                            }
                            
                            self?.delegate?.handleOnRegisterCompleted()
                            return
                        }
                    }
                } catch let error {
                    self?.errorMessage = "Error encode Data: \(error.localizedDescription)"
                    return
                }
            }
        }
    }
}
