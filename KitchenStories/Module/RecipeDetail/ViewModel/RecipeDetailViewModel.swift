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
    
    var ingredientsPerServing: [IngredientSectionModel]?
    
    var servingCount: Int = 1
    
    var ingredientHeaderSectionIndexes: [Int:Int] = [:]
    var ingredientBodySectionIndexes: [Int:Int] = [:]
    
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
        servingCount = value
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
        getRecipeDetailService.detail(recipeId: recipeId) { [weak self] recipeDetail, errorMessage in
            if let errorMessage = errorMessage {
                self?.recipeDetailErrorMessage = errorMessage
            } else if let recipeDetail = recipeDetail {
                self?.recipeDetail = recipeDetail
                self?.servingCount = recipeDetail.numServings ?? 1
                self?.setIngredientsPerServing()
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getRecipeTipsService.recipeTips(recipeId: recipeId, from: tipsFrom, size: tipsSize) { [weak self] recipeTips, errorMessage in
            if let errorMessage = errorMessage {
                self?.recipeTipsErrorMessage = errorMessage
            } else if let recipeTips = recipeTips {
                self?.recipeTips = recipeTips
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getRelatedRecipesService.relatedRecipes(recipeId: recipeId) { [weak self] relatedRecipes, errorMessage in
            if let errorMessage = errorMessage {
                self?.relatedRecipesErrorMessage = errorMessage
            } else if let relatedRecipes = relatedRecipes,
                        relatedRecipes.count > 0 &&
                        relatedRecipes.results.count > 0 {
                self?.relatedRecipes = relatedRecipes
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            self?.setDetailsSection()
            self?.isLoading = false
            self?.delegate?.handleOnDetailsFetchCompleted()
            return
        }
    }
    
    func setIngredientsPerServing() {
        guard let recipeDetail = recipeDetail,
              let ingredientsSections = recipeDetail.ingredientSections,
              let numServings = recipeDetail.numServings
        else { return }
        
        self.ingredientsPerServing = ingredientsSections
        
        for (sectionIdx, ingredientsSection) in ingredientsSections.enumerated() {
            for (componentIdx, component) in ingredientsSection.components.enumerated() {
                for (measurementIdx, measurement) in component.measurements.enumerated() {
                    guard measurement.quantity != "",
                          measurement.quantity != "0",
                          let quantityDouble = measurement.quantity.numericValue()
                    else { continue }
                    
                    ingredientsPerServing?[sectionIdx].components[componentIdx].measurements[measurementIdx].quantityDouble = quantityDouble / Double(numServings)
                }
            }
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
                
            case .nutritionsInfoHeader:
                guard recipeDetail.nutrition != nil && recipeDetail.nutrition?.isNutritionAvailable == true
                else { continue }
                detailsSection.append(.nutritionsInfoHeader)
                detailsSection.append(.nutritionsBody)
                
            case .nutritionsBody:
                continue
                
            case .topTip:
                guard recipeTips != nil
                else { continue }
                detailsSection.append(.topTip)
                
            case .relatedRecipesHeader:
                guard relatedRecipes != nil
                else { continue }
                detailsSection.append(.relatedRecipesHeader)
                detailsSection.append(.relatedRecipesBody)
                
            case .relatedRecipesBody:
                continue
                
            case .preparationsHeader:
                guard let instructions = recipeDetail.instructions
                else { continue }
                
                if instructions.count > 0 {
                    detailsSection.append(.preparationsHeader)
                    detailsSection.append(.preparationsBody)
                }
                
            case .preparationsBody:
                continue
                
            default:
                detailsSection.append(section)
            }
        }
    }
}
