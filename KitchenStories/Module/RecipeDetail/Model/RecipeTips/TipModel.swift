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
    let authorName: String
    let tipBody: String
    
    enum CodingKeys: String, CodingKey {
        case tipId = "tip_id"
        case authorAvatarUrlString = "author_avatar_url"
        case authorName = "author_name"
        case tipBody = "tip_body"
    }
}
