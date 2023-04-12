//
//  FeedModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

enum FeedType: String, Codable {
    case carousel = "carousel"
    case featured = "featured"
    case item = "item"
    case shoppableCarousel = "shoppable_carousel"
}

struct FeedModel: Codable {
    let type: FeedType
    let name: String?
    let category: String?
    let minItems: Int?
    let item: FeedItemModel?
    let items: [FeedItemModel]?
    
    var itemList: [FeedItemModel] {
        if let items = items {
            return items
        } else if let item = item {
            return [item]
        }
        return [FeedItemModel]()
    }
    
    var minimumShowItems: Int {
        return minItems ?? 6
    }
    
    var showItemsCount: Int {
        if itemList.count > minimumShowItems { return minimumShowItems }
        return itemList.count
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case category
        case minItems = "min_items"
        case item
        case items
    }
}
