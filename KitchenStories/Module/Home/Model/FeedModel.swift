//
//  FeedModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

enum FeedType: String, Codable {
    case carousel
    case featured
    case item
    case shoppableCarousel = "shoppable_carousel"
}

struct FeedModel: Codable {
    let type: FeedType
    let name: String?
    let category: String?
    let minItems: Int?
    let item: FeedItemModel?
    let items: [FeedItemModel]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case category
        case minItems = "min_items"
        case item
        case items
    }
}
