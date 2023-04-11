//
//  GetFeedsAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

protocol GetFeedAPIProtocol {
    func feeds(
        isVegetarian: Bool,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetFeedAPIService: GetFeedAPIProtocol {
    private let urlString = "https://tasty.p.rapidapi.com/feeds/list"
    private var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func feeds(
        isVegetarian: Bool = false,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var url = URL(string: urlString)
        url?.append(queryItems: [
            URLQueryItem(name: "size", value: "10"),
            URLQueryItem(name: "from", value: "0"),
            URLQueryItem(name: "vegetarian", value: "\(isVegetarian)"),
            URLQueryItem(name: "timezone", value: "+0700")
        ])
        getAPIService.getAPI(from: url, withModel: FeedResultsModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, errorMessage)
            } else if let apiData = apiData {
                return onCompletion(apiData, errorMessage)
            }
        }
    }
}
