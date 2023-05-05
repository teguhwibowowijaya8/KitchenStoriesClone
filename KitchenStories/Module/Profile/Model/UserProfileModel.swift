//
//  UserProfileModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import Foundation

struct UserProfile: Codable {
    var id: String
    var name: String
    var imageUrlString: String?
    var email: String
    var username: String
    var gender: String
    
    var abbreviation: String {
        var firstCharOfWords = ""
        name.components(separatedBy: " ").forEach {
            if let firstChar = $0.first { firstCharOfWords += String(firstChar) }
        }
        
        return firstCharOfWords
    }
}
