//
//  ProfileViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import Foundation

struct ProfileViewModel {
    var totalSections: Int = 4
    var isLoading: Bool = false
    var settingSections: [SettingSectionModel]
    var userProfile: UserProfile?
    var compositions: [ProfileViewSection]
    
    init() {
        settingSections = [
            SettingSectionModel(section: .account, settings: [
                SettingModel(type: .logOut, symbolImageName: "person.fill", tintColor: .red)
            ]),
            SettingSectionModel(section: .system, settings: [
                SettingModel(type: .languages, symbolImageName: "person.fill"),
                SettingModel(type: .measurementSystem, symbolImageName: "person.fill"),
                SettingModel(type: .notification, symbolImageName: "person.fill"),
                SettingModel(type: .display, symbolImageName: "person.fill"),
                SettingModel(type: .dietaryRestriction, symbolImageName: "person.fill")
            ]),
            SettingSectionModel(section: .more, settings: [
                SettingModel(type: .aboutUs, symbolImageName: "person.fill"),
                SettingModel(type: .faq, symbolImageName: "person.fill"),
                SettingModel(type: .legalInformation, symbolImageName: "person.fill")
            ])
        ]
        
        compositions = [ .profileAccount ]
        
        for _ in settingSections {
            compositions.append(.profileSettings)
        }
        
        userProfile = UserProfile(id: "12345", name: "Mas Wadidaw Kejar Aku Nih", email: "maswadidaw98@gmail.com", username: "maswadidaw98", gender: "Male")
    }
    
    func getUserProfile() {
        
    }
}
