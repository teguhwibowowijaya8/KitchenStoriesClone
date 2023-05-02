//
//  RelatedRecipesModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct RelatedRecipesModel: Codable {
    let count: Int
    let results: [RecipeModel]
}
