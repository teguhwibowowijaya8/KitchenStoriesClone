//
//  ProfileViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseFirestoreSwift

protocol ProfileViewModelDelegate {
    func handleOnFetchUserCompleted()
    func handleOnSuccessSignOut()
}

class ProfileViewModel {
    var totalSections: Int = 4
    var isLoading: Bool = false
    var settingSections: [SettingSectionModel]
    var userProfile: UserProfileModel?
    var compositions: [ProfileViewSection]
    var delegate: ProfileViewModelDelegate?
    var errorMessage: String?
    
    init() {
        settingSections = [
            SettingSectionModel(section: .account, settings: [
                SettingModel(type: .logOut, symbolImageName: "arrow.left.square", tintColor: .red)
            ]),
            SettingSectionModel(section: .system, settings: [
                SettingModel(type: .languages, symbolImageName: "globe"),
                SettingModel(type: .measurementSystem, symbolImageName: "scalemass"),
                SettingModel(type: .notification, symbolImageName: "bell.circle.fill"),
                SettingModel(type: .display, symbolImageName: "lightbulb.slash.fill"),
                SettingModel(type: .dietaryRestriction, symbolImageName: "leaf.arrow.circlepath")
            ]),
            SettingSectionModel(section: .more, settings: [
                SettingModel(type: .aboutUs, symbolImageName: "info.circle.fill"),
                SettingModel(type: .faq, symbolImageName: "questionmark.circle.fill"),
                SettingModel(type: .legalInformation, symbolImageName: "doc.text.magnifyingglass")
            ])
        ]
        
        compositions = [ .profileAccount ]
        
        for _ in settingSections {
            compositions.append(.profileSettings)
        }
        
        //        userProfile = UserProfileModel(id: "12345", name: "Mas Wadidaw Kejar Aku Nih", email: "maswadidaw98@gmail.com", username: "maswadidaw98", gender: "Male")
    }
    
    func getUserProfile() {
        guard isLoading == false
        else { return }
        
        isLoading = true
        errorMessage = nil
        
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { query, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.delegate?.handleOnFetchUserCompleted()
                    
                } else if let profileDocument = query,
                          let profile = profileDocument.data() {
                    self.userProfile = UserProfileModel(
                        uid: uid,
                        dictionary: profile
                    )
                }
                self.isLoading = false
                self.delegate?.handleOnFetchUserCompleted()
            }
        }
        
        //        if let uid = Auth.auth().currentUser?.uid {
        //            let db = Firestore.firestore()
        //            db.collection("users").document(uid).getDocument(as: RegisterUserModel.self) { result in
        //                switch result {
        //                case .success(let user):
        //                    self.userProfile = UserProfileModel(id: uid, name: user.fullname, email: user.email, username: user.username, gender: user.gender)
        //
        //                case .failure(let error):
        //                    self.errorMessage = error.localizedDescription
        //                }
        //            }
        //        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            delegate?.handleOnSuccessSignOut()
        } catch let error as NSError {
            print(error)
        }
    }
}
