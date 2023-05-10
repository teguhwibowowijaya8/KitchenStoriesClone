//
//  TipModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct TipModel: Codable {
    let tipId: Int
    let authorAvatarUrlString: String?
    let authorName: String?
    let authorUsername: String?
    let tipBody: String
    
    var author: String {
        if let authorName = authorName, authorName != "" {
            return authorName
        } else if let authorUsername = authorUsername, authorUsername != "" {
            return authorUsername
        }
        return "Anonymous"
    }
    
    enum CodingKeys: String, CodingKey {
        case tipId = "tip_id"
        case authorAvatarUrlString = "author_avatar_url"
        case authorUsername = "author_username"
        case authorName = "author_name"
        case tipBody = "tip_body"
    }
}
