//
//  RecipeRatingModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct RecipeRatingModel: Codable {
    let countPositive: Int
    let countNegative: Int
    let score: Double?
    var percentage: Int? {
        if let score = score {
            return Int(round(score * 100))
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case countPositive = "count_positive"
        case countNegative = "count_negative"
        case score
    }
}
