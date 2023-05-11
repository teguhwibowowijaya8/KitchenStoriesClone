//
//  GetRecipeDetailAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

protocol GetRecipeDetailAPIProtocol {
    var getAPIService: GetAPIProtocol { get }
    
    func detail(
        recipeId: Int,
        onCompletion: @escaping (
            _ recipeDetail: RecipeDetailModel?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetRecipeDetailAPIService: GetRecipeDetailAPIProtocol {
    private let recipeDetailUrlString = "\(Constant.baseUrlString)/recipes/get-more-info"
    var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func detail(
        recipeId: Int,
        onCompletion: @escaping (
            _ recipeDetail: RecipeDetailModel?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var detailUrl = URLComponents(string: recipeDetailUrlString)
        detailUrl?.queryItems = [
            URLQueryItem(name: "id", value: "\(recipeId)")
        ]
        
        getAPIService.getAPI(from: detailUrl?.url, withModel: RecipeDetailModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, errorMessage)
            } else if let apiData = apiData {
                return onCompletion(apiData, nil)
            }
        }
    }
}
