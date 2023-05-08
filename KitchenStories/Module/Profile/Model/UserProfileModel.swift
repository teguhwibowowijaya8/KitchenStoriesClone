//
//  UserProfileModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import Foundation

struct UserProfileModel: Codable {
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
    
    init(uid: String, dictionary: [String: Any?]) {
        self.id = uid
        self.name = dictionary["fullname"] as? String ?? ""
        self.imageUrlString = dictionary["imageUrl"] as? String ?? nil
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        
    }
}
