//
//  GetFeedsAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

protocol GetFeedAPIProtocol {
    var getAPIService: GetAPIProtocol { get }
    
    func feeds(
        isVegetarian: Bool,
        size: Int,
        from: Int,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ recentFeeds: [RecipeModel]?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetFeedAPIService: GetFeedAPIProtocol {
    private let feedsUrlString = "\(Constant.baseUrlString)/feeds/list"
    var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func feeds(
        isVegetarian: Bool,
        size: Int,
        from: Int,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ recentFeeds: [RecipeModel]?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var feedUrl = URLComponents(string: feedsUrlString)
        
        feedUrl?.queryItems = [
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "vegetarian", value: "\(isVegetarian)"),
            URLQueryItem(name: "timezone", value: "+0700")
        ]
        
        getAPIService.getAPI(from: feedUrl?.url, withModel: FeedResultsModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, nil,errorMessage)
            } else if var apiData = apiData {
                if let firstFeed = apiData.results.first, firstFeed.name == nil || firstFeed.name == "" {
                    apiData.results[0].name = "Featured"
                }
                
                var recentFeeds = [RecipeModel]()
                var feeds: FeedResultsModel?
                for feed in apiData.results {
                    if feed.type == .item {
                        recentFeeds.append(contentsOf: feed.itemList)
                    } else {
                        if feeds == nil {
                            feeds = FeedResultsModel(results: [feed])
                        } else {
                            feeds?.results.append(feed)
                        }
                    }
                }
                return onCompletion(feeds, recentFeeds, errorMessage)
            }
        }
    }
}
