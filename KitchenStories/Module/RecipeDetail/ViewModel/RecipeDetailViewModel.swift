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
    var recipeDetailErrorMessage: String?
    var recipeTipsErrorMessage: String?
    var relatedRecipesErrorMessage: String?
    var delegate: RecipeDetailViewModelDelegate?
    
    let maxRelatedRecipesShown: Int = 5
    
    var showNutritionInfo: Bool = false
    
    var detailsSection: [RecipeDetailSection] = []
    var defaultSection: [RecipeDetailSection] = []
    
    var servingCount: Int = 1
    
    var ingredientHeaderSectionIndexes: [Int:Int] = [:]
    var ingredientBodySectionIndexes: [Int:Int] = [:]
    //    var dummyDetail: RecipeDetailModel
    //    var dummyTips: RecipeTipsModel
    //    var dummyRelatedRecipe: RelatedRecipesModel
    
    init(recipeId: Int, getAPIService: GetAPIProtocol = GetAPIService()) {
        self.recipeId = recipeId
        self.getAPIService = getAPIService
        
        getRecipeDetailService = GetRecipeDetailAPIService(getAPIService: self.getAPIService)
        getRecipeTipsService = GetRecipeTipsAPIService(getAPIService: self.getAPIService)
        getRelatedRecipesService = GetRelatedRecipesAPIService(getAPIService: self.getAPIService)
        
        defaultSection = [
            .header,
            .ingredientServing,
            .ingredientsHeader,
            .ingredientsBody,
            .nutritionsInfoHeader,
            .nutritionsBody,
            .addToGrocery,
            .topTip,
            .relatedRecipesHeader,
            .relatedRecipesBody,
            .preparationsHeader,
            .preparationsBody,
        ]
        detailsSection = defaultSection
    }
    
    func changeShowNutritionInfo() {
        self.showNutritionInfo.toggle()
    }
    
    func changeServingNums(to value: Int) {
        recipeDetail?.numServings = value
    }
    
    func getSectionIndex(of section: RecipeDetailSection) -> Int? {
        for (index, currentSection) in detailsSection.enumerated() {
            if currentSection == section {
                return index
            }
        }
        
        return nil
    }
    
    func getDetail() {
        guard isLoading == false
        else { return }
        
        isLoading = true
        recipeDetailErrorMessage = nil
        recipeTipsErrorMessage = nil
        relatedRecipesErrorMessage = nil
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getRecipeDetailService.detail(recipeId: recipeId) { recipeDetail, errorMessage in
            if let errorMessage = errorMessage {
                self.recipeDetailErrorMessage = errorMessage
            } else if let recipeDetail = recipeDetail {
                self.recipeDetail = recipeDetail
                self.servingCount = recipeDetail.numServings ?? 1
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getRecipeTipsService.recipeTips(recipeId: recipeId, from: tipsFrom, size: tipsSize) { recipeTips, errorMessage in
            if let errorMessage = errorMessage {
                self.recipeTipsErrorMessage = errorMessage
            } else if let recipeTips = recipeTips {
                self.recipeTips = recipeTips
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getRelatedRecipesService.relatedRecipes(recipeId: recipeId) { relatedRecipes, errorMessage in
            if let errorMessage = errorMessage {
                self.relatedRecipesErrorMessage = errorMessage
            } else if let relatedRecipes = relatedRecipes {
                self.relatedRecipes = relatedRecipes
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            self.setDetailsSection()
            print("sections: \n\(self.detailsSection)")
            print("top tip fetch error: \(self.recipeTipsErrorMessage)")
            print("related recipes fetch error: \(self.relatedRecipesErrorMessage)")
            self.isLoading = false
            self.delegate?.handleOnDetailsFetchCompleted()
            return
        }
    }
    
    func setDetailsSection() {
        guard let recipeDetail = recipeDetail
        else { return }
        detailsSection = []
        
        for section in defaultSection {
            switch section {
            case .ingredientsBody:
                continue
                
            case .ingredientsHeader:
                guard let ingredientSections = recipeDetail.ingredientSections
                else { continue }
                
                let ingredientSectionCount = ingredientSections.count
                
                if ingredientSectionCount > 0 {
                    for (sectionIndex, ingredientSection) in ingredientSections.enumerated() {
                        if ingredientSection.name != nil && ingredientSection.name != "" {
                            detailsSection.append(.ingredientsHeader)
                            self.ingredientHeaderSectionIndexes[detailsSection.count - 1] = sectionIndex
                        }
                        detailsSection.append(.ingredientsBody)
                        self.ingredientBodySectionIndexes[detailsSection.count - 1] = sectionIndex
                    }
                }
                
            case .topTip:
                guard recipeTips != nil
                else { continue }
                detailsSection.append(.topTip)
                
            case .preparationsBody:
                continue
                
            case .preparationsHeader:
                guard let instructions = recipeDetail.instructions
                else { continue }
                
                if instructions.count > 0 {
                    detailsSection.append(.preparationsHeader)
                    detailsSection.append(.preparationsBody)
                }
                
            default:
                detailsSection.append(section)
            }
        }
    }
    
    //    private func setDummyData() {
    //        dummyDetail = RecipeDetailModel(id: 1, userRatings: nil, name: "", thumbnailUrlString: "", credits: [], brand: nil, price: nil, recipes: nil, featuredIn: [], numServings: 0, servingsNounSingular: "serving", servingsNounPlural: "servings", videoUrl: nil, description: nil, ingredients: [], nutrition: NutritionModel(calories: 0, carbohydrates: 0, fat: 0, protein: 0, sugar: 0, fiber: 0), instructions: [])
    //
    //        dummyTips = RecipeTipsModel(count: 1, result: [])
    //
    //        dummyRelatedRecipe = RelatedRecipesModel(count: 5, results: [])
    //    }
}
