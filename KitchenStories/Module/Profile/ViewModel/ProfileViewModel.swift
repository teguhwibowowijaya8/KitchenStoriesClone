//
//  ProfileViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ProfileViewModelDelegate {
    func handleOnSuccessSignOut()
}

struct ProfileViewModel {
    var totalSections: Int = 4
    var isLoading: Bool = false
    var settingSections: [SettingSectionModel]
    var userProfile: UserProfileModel?
    var compositions: [ProfileViewSection]
    var delegate: ProfileViewModelDelegate?
    
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
        
        userProfile = UserProfileModel(id: "12345", name: "Mas Wadidaw Kejar Aku Nih", email: "maswadidaw98@gmail.com", username: "maswadidaw98", gender: "Male")
    }
    
    func getUserProfile() {
//        if let uid = Auth.auth().currentUser?.uid {
//            let db = Firestore.firestore()
//            db.collection("users").document(uid).getDocument { query, error in
//                if let error = error {
//                    print(error)
//                    return
//                } else if let profileDocument = query,
//                          let profile = profileDocument.data(),
//                          let encodedData = try? JSONEncoder().encode(profile) {
//                    let result = Result {
//                        let user = try JSONDecoder().decode(RegisterUserModel.self, from: encodedData)
//                    }
//                    
//                    switch result {
//                    case .success(let user):
//                        return user
//                    case .failure(let error):
//                        print("Error decoding user: \(error)")
//                        return nil
//                    }
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
