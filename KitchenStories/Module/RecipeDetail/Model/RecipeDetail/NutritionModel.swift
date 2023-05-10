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
    
    var isNutritionAvailable: Bool {
        let availableNutrition = nutritionList.first { $0.value > 0 }
        
        return availableNutrition != nil ? true : false
    }
    
    var nutritionList: [String: Int] {
        return [
            "calories": calories,
            "carbohydrates": carbohydrates,
            "fat": fat,
            "protein": protein,
            "sugar": sugar,
            "fiber": fiber,
        ]
    }
    
    var nutritions: [Int: (title: String, value: String)] {
        var nutritions = [Int: (title: String, value: String)]()
        
        for (index, nutrition) in nutritionList.enumerated() {
            let value = nutrition.key == "calories" ? "\(nutrition.value)" : "\(nutrition.value)g"
            
            nutritions[index] = (
                title: nutrition.key,
                value: value
            )
        }
        return nutritions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.calories = try container.decodeIfPresent(Int.self, forKey: .calories) ?? 0
        self.carbohydrates = try container.decodeIfPresent(Int.self, forKey: .carbohydrates) ?? 0
        self.fat = try container.decodeIfPresent(Int.self, forKey: .fat) ?? 0
        self.protein = try container.decodeIfPresent(Int.self, forKey: .protein) ?? 0
        self.sugar = try container.decodeIfPresent(Int.self, forKey: .sugar) ?? 0
        self.fiber = try container.decodeIfPresent(Int.self, forKey: .fiber) ?? 0
    }
}
