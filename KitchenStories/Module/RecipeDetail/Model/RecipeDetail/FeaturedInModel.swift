//
//  FeaturedInModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct FeaturedInModel: Codable {
    let id: Int
    let name: String
    let description: String?
    let videoUrl: String?
    let thumbnailUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case videoUrl = "video_url"
        case thumbnailUrlString = "thumbnail_url"
    }
}
