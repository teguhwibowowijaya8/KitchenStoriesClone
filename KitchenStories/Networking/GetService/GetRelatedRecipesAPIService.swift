//
//  GetRelatedRecipesAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

protocol GetRelatedRecipesAPIProtocol {
    var getAPIService: GetAPIProtocol { get }
    
    func relatedRecipes(
        recipeId: Int,
        onCompletion: @escaping (
            _ relatedRecipes: RelatedRecipesModel?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetRelatedRecipesAPIService: GetRelatedRecipesAPIProtocol {
    private let relatedRecipesUrlString = "\(Constant.baseUrlString)/recipes/list-similarities"
    var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func relatedRecipes(
        recipeId: Int,
        onCompletion: @escaping (
            _ relatedRecipes: RelatedRecipesModel?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var relatedRecipesUrl = URL(string: relatedRecipesUrlString)
        relatedRecipesUrl?.append(queryItems: [
            URLQueryItem(name: "recipe_id", value: "\(recipeId)")
        ])
        
        getAPIService.getAPI(from: relatedRecipesUrl, withModel: RelatedRecipesModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, errorMessage)
            } else if let apiData = apiData {
                return onCompletion(apiData, nil)
            }
        }
    }
}
