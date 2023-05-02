//
//  RecipeDetailViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

protocol RecipeDetailViewModelDelegate {
    func handleOnDetailsFetchCompleted()
}

class RecipeDetailViewModel {
    private let getAPIService: GetAPIProtocol
    private let getRecipeDetailService: GetRecipeDetailAPIProtocol
    private let getRecipeTipsService: GetRecipeTipsAPIProtocol
    private let getRelatedRecipesService: GetRelatedRecipesAPIProtocol
    
    private var recipeId: Int
    private let tipsFrom: Int = 0
    private let tipsSize: Int = 1
    
    var recipeDetail: RecipeDetailModel?
    var recipeTips: RecipeTipsModel?
    var relatedRecipes: RelatedRecipesModel?
    var isLoading: Bool = false
    var errorMessage: [String]
    var delegate: RecipeDetailViewModelDelegate?
    
    var dummyDetail: RecipeDetailModel
    var dummyTips: RecipeTipsModel
    var dummyRelatedRecipe: RelatedRecipesModel
    
    init(recipeId: Int, getAPIService: GetAPIProtocol = GetAPIService()) {
        self.recipeId = recipeId
        self.getAPIService = getAPIService
        
        getRecipeDetailService = GetRecipeDetailAPIService(getAPIService: self.getAPIService)
        getRecipeTipsService = GetRecipeTipsAPIService(getAPIService: self.getAPIService)
        getRelatedRecipesService = GetRelatedRecipesAPIService(getAPIService: self.getAPIService)
        
        setDummyData()
    }
    
    func getDetail() {
        guard isLoading == false
        else { return }
        
        isLoading = true
        errorMessage = []
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getRecipeDetailService.detail(recipeId: recipeId) { recipeDetail, errorMessage in
            if let errorMessage = errorMessage {
                self.errorMessage.append(errorMessage)
            } else if let recipeDetail = recipeDetail {
                self.recipeDetail = recipeDetail
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        getRecipeTipsService.recipeTips(recipeId: recipeId, from: tipsFrom, size: tipsSize) { recipeTips, errorMessage in
            if let errorMessage = errorMessage {
                self.errorMessage.append(errorMessage)
            } else if let recipeTips = recipeTips {
                self.recipeTips = recipeTips
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        getRelatedRecipesService.relatedRecipes(recipeId: recipeId) { relatedRecipes, errorMessage in
            if let errorMessage = errorMessage {
                self.errorMessage.append(errorMessage)
            } else if let relatedRecipes = relatedRecipes {
                self.relatedRecipes = relatedRecipes
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            self.delegate?.handleOnDetailsFetchCompleted()
            return
        }
    }
    
    private func setDummyData() {
        dummyDetail = RecipeDetailModel(id: 1, userRatings: nil, name: "", thumbnailUrlString: "", credits: [], brand: nil, price: nil, recipes: nil, featuredIn: [], numServings: 0, servingsNounSingular: "serving", servingsNounPlural: "servings", videoUrl: nil, description: nil, ingredients: [], nutrition: NutritionModel(calories: 0, carbohydrates: 0, fat: 0, protein: 0, sugar: 0, fiber: 0), instructions: [])
        
        dummyTips = RecipeTipsModel(count: 1, result: [])
        
        dummyRelatedRecipe = RelatedRecipesModel(count: 5, results: [])
    }
}
