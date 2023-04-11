//
//  FeedItemRatingModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct FeedItemRatingModel: Codable {
    let countPositive: Int
    let countNegative: Int
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case countPositive = "count_positive"
        case countNegative = "count_negative"
        case score
    }
}
