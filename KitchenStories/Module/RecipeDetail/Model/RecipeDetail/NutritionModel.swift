//
//  NutritionModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct NutritionModel: Codable {
    let calories: Int
    let carbohydrates: Int
    let fat: Int
    let protein: Int
    let sugar: Int
    let fiber: Int
    
    var nutritions: [Int:[String: Int]] {
        return [
            1: ["calories": calories],
            2: ["carbohydrates": carbohydrates],
            3: ["fat": fat],
            4: ["protein": protein],
            5: ["sugar": sugar],
            6: ["fiber": fiber]
        ]
    }
}
