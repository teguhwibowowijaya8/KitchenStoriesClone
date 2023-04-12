//
//  FeedItemModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct FeedItemModel: Codable {
    let id: Int
    let userRatings: FeedItemRatingModel?
    let name: String
    let thumbnailUrlString: String
    let credits: [FeedItemCreditModel]?
    let brand: FeedItemCreditModel?
    let price: FeedItemPriceModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userRatings = "user_ratings"
        case name
        case thumbnailUrlString = "thumbnail_url"
        case credits
        case brand
        case price
    }
}
