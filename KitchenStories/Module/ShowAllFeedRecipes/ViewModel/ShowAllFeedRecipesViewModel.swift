//
//  ShowAllFeedRecipesViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import Foundation

protocol ShowAllFeedRecipesViewModelDelegate {
    func handleOnGetRecentFeedCompleted()
}

class ShowAllFeedRecipesViewModel {
    var isLoading: Bool = false
    let showAllRecipesType: ShowAllRecipesType
    var recipes: [RecipeModel]
    var startGetRecentFrom: Int?
    var delegate: ShowAllFeedRecipesViewModelDelegate?
    var errorMessage: String?
    var getFeedsAPIService: GetFeedAPIService
    var isVegetarian: Bool = false
    var sizeEachFetch: Int = 10
    
    init(
        showAllRecipesType: ShowAllRecipesType,
        recipes: [RecipeModel],
        startGetRecentFrom: Int?,
        getAPIService: GetAPIProtocol = GetAPIService()
    ) {
        self.showAllRecipesType = showAllRecipesType
        self.recipes = recipes
        self.startGetRecentFrom = startGetRecentFrom
        self.getFeedsAPIService = GetFeedAPIService(getAPIService: getAPIService)
    }
    
    func getRecentFeeds() {
        guard isLoading == false,
              let startGetRecentFrom = startGetRecentFrom,
              showAllRecipesType == .canFetchMore
        else { return }
        
        isLoading = true
        errorMessage = nil
        
        getFeedsAPIService.feeds(isVegetarian: isVegetarian, size: sizeEachFetch, from: startGetRecentFrom) { _, recentFeeds, errorMessage in
            if let errorMessage = errorMessage {
                self.errorMessage = errorMessage
            } else if let recentFeeds = recentFeeds {
                self.startGetRecentFrom = startGetRecentFrom + recentFeeds.count
                self.recipes.append(contentsOf: recentFeeds)
            }
            self.isLoading = false
            self.delegate?.handleOnGetRecentFeedCompleted()
        }
    }
}
