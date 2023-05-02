//
//  RecipeDetail.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct RecipeDetailModel: Codable {
    let id: Int
    let userRatings: RecipeRatingModel?
    let name: String
    let thumbnailUrlString: String
    let credits: Set<RecipeCreditModel>
    let brand: RecipeCreditModel?
    let price: RecipeIngredientsPriceModel?
    let recipes: [RecipeModel]?
    
    let featuredIn: [FeaturedInModel]
    let numServings: Int
    let servingsNounSingular: String
    let servingsNounPlural: String
    let videoUrl: String?
    let description: String?
    let ingredients: [IngredientsModel]
    let nutrition: NutritionModel
    let instructions: [InstructionModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userRatings = "user_ratings"
        case name
        case thumbnailUrlString = "thumbnail_url"
        case credits
        case brand
        case price
        case recipes
        
        case featuredIn = "compilations"
        case numServings = "num_servings"
        case servingsNounSingular = "servings_noun_singular"
        case servingsNounPlural = "servings_noun_plural"
        case videoUrl = "video_url"
        case description
        case ingredients = "sections"
        case nutrition
        case instructions
    }
    
}
