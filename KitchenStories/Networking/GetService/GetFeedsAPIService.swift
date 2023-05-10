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
        var feedUrl = URL(string: feedsUrlString)
        feedUrl?.append(queryItems: [
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "vegetarian", value: "\(isVegetarian)"),
            URLQueryItem(name: "timezone", value: "+0700")
        ])
        getAPIService.getAPI(from: feedUrl, withModel: FeedResultsModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, nil,errorMessage)
            } else if let apiData = apiData {
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
