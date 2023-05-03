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
    
    var nutritions: [Int: (title: String, value: String)] {
        return [
            1: (title: "calories", value: "\(calories)"),
            2: (title: "carbohydrates", value: "\(carbohydrates)g"),
            3: (title: "fat", value: "\(fat)g"),
            4: (title: "protein", value: "\(protein)g"),
            5: (title: "sugar", value: "\(sugar)g"),
            6: (title: "fiber", value: "\(fiber)g")
        ]
    }
}
