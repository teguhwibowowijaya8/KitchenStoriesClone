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
        
        userProfile = UserProfile(id: "12345", name: "Mas Wadidaw Kejar Aku Nih", email: "maswadidaw98@gmail.com", username: "maswadidaw98", gender: "Male")
    }
    
    func getUserProfile() {
        
    }
}
