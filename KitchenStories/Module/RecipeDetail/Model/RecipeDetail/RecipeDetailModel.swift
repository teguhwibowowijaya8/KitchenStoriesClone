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
    var numServings: Int?
    let servingsNounSingular: String?
    let servingsNounPlural: String?
    let videoUrl: String?
    let description: String?
    let ingredientSections: [IngredientSectionModel]?
    let nutrition: NutritionModel?
    let instructions: [InstructionModel]?
    
    var isCommunityMemberRecipe: Bool {
        for credit in credits {
            if credit.type == .community {
                return true
            }
        }
        
        return false
    }
    
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
    
    var featureInCompilations: String? {
        let featuredInCount = featuredIn.count
        
        if featuredInCount == 1 { return featuredIn.first?.name }
        else if featuredInCount == 0 { return nil }
        
        var fullNames: String = ""
        for (index, compilation) in featuredIn.enumerated() {
            guard compilation.name != "" else { continue }
            
            if fullNames == "" {
                fullNames += compilation.name
            } else if index == featuredInCount - 1 {
                fullNames += ", and \(compilation.name)"
            } else {
                fullNames += ", \(compilation.name)"
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
        
        case featuredIn = "compilations"
        case numServings = "num_servings"
        case servingsNounSingular = "servings_noun_singular"
        case servingsNounPlural = "servings_noun_plural"
        case videoUrl = "video_url"
        case description
        case ingredientSections = "sections"
        case nutrition
        case instructions
    }
    
}
