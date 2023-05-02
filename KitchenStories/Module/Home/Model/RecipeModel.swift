//
//  RecipeModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct RecipeModel: Codable {
    let id: Int
    let userRatings: RecipeRatingModel?
    let name: String
    let thumbnailUrlString: String
    let credits: Set<RecipeCreditModel>
    let brand: RecipeCreditModel?
    let price: RecipeIngredientsPriceModel?
    let recipes: [RecipeModel]?
    
    var creditsNames: String? {
        let creditsCount = credits.count
        
        if creditsCount == 1 { return credits.first?.name }
        else if creditsCount == 0 { return nil }
        
        var fullNames: String = ""
        for (index, credit) in credits.enumerated() {
            guard let creditName = credit.name else { continue }
            
            if fullNames == "" {
                fullNames += creditName
            } else if index == creditsCount - 1 {
                fullNames += ", and \(creditName)"
            } else {
                fullNames += ", \(creditName)"
            }
        }
        
        return fullNames
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userRatings = "user_ratings"
        case name
        case thumbnailUrlString = "thumbnail_url"
        case credits
        case brand
        case price
        case recipes
    }
}
