//
//  IngredientComponentModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct IngredientComponentModel: Codable {
    let id: Int
    let ingredient: IngredientModel
    let extraComment: String?
    let position: Int
    let measurements: [MeasurementModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ingredient
        case extraComment = "extra_comment"
        case position
        case measurements
    }
}
