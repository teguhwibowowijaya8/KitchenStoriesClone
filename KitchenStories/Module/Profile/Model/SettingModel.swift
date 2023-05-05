//
//  SettingModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

enum SettingType: String {
    // Account Setting Section
    case logOut = "Log Out"
    
    // System Setting Section
    case languages = "Languages"
    case measurementSystem = "Measurement System"
    case notification = "Notification"
    case display = "Display"
    case dietaryRestriction = "Dietary Restriction"
    
    // More Setting Section
    case aboutUs = "About Us"
    case faq = "Kitchen Stories FAQs"
    case legalInformation = "Legal Information"
}

struct SettingModel {
    let type: SettingType
    let symbolImageName: String
    var tintColor: UIColor = .label
}
