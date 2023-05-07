//
//  ProfileDetailViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import Foundation

enum ProfileTextFieldType: Int {
    case name
    case email
    case username
    case gender
}

struct ProfileDetailViewModel {
    var userDetails: [Int: (title: String, value: String?)] = [:]
    var isLoading: Bool = false
    var compositions: [ProfileDetailSection]
    var errorMessage: String?
    var fieldErrorMessage: [ProfileTextFieldType: String?] = [:]
    var textFieldCompositions: [ProfileTextFieldType]
    
    
    init(userProfile: UserProfileModel) {
        userDetails = [
            1: (title: "Name", value: userProfile.name),
            2: (title: "Email", value: userProfile.email),
            3: (title: "Username", value: userProfile.username),
            4: (title: "Gender", value: userProfile.gender)
        ]
        
        textFieldCompositions = [
            .name,
            .email,
            .username,
            .gender
        ]
        
        compositions = [ .profilePhoto ]
        textFieldCompositions.forEach { _ in
            compositions.append(.profileInfo)
        }
        compositions.append(.saveDetail)
    }
}
