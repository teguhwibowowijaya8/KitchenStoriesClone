//
//  SettingSectionModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import Foundation

enum SettingSectionType: String {
    case account = "Account"
    case system = "System"
    case more = "More"
}

struct SettingSectionModel {
    let section: SettingSectionType
    let settings: [SettingModel]
}
