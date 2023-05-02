//
//  FeedItemPriceModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct RecipeIngredientsPriceModel: Codable {
    let total: Double
//    let updatedAt: Date?
    let portion: Double
    let consumptionTotal: Double
    let consumptionPortion: Double
    
    enum CodingKeys: String, CodingKey {
        case total
//        case updatedAt = "updated_at"
        case portion
        case consumptionTotal = "consumption_total"
        case consumptionPortion = "consumption_portion"
    }
}
