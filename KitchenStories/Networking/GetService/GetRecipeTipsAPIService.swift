//
//  GetRecipeTipsAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

protocol GetRecipeTipsAPIProtocol {
    var getAPIService: GetAPIProtocol { get }
    
    func recipeTips(
        recipeId: Int,
        from: Int,
        size: Int,
        onCompletion: @escaping (
            _ recipeTips: RecipeTipsModel?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetRecipeTipsAPIService: GetRecipeTipsAPIProtocol {
    private let recipeTipsUrlString = "\(Constant.baseUrlString)/tips/list"
    var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func recipeTips(
        recipeId: Int,
        from: Int,
        size: Int,
        onCompletion: @escaping (
            _ recipeTips: RecipeTipsModel?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var recipeTipsUrl = URLComponents(string: recipeTipsUrlString)
        recipeTipsUrl?.queryItems = [
            URLQueryItem(name: "id", value: "\(recipeId)"),
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        getAPIService.getAPI(from: recipeTipsUrl?.url, withModel: RecipeTipsModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, errorMessage)
            } else if let apiData = apiData {
                return onCompletion(apiData, errorMessage)
            }
        }
    }
}
