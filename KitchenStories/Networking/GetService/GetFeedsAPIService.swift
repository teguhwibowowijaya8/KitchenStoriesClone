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
        sizeEachFetch: Int,
        from: Int,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ recentFeeds: [FeedItemModel]?,
            _ errorMessage: String?
        ) -> Void
    )
}

struct GetFeedAPIService: GetFeedAPIProtocol {
    private let feedsUrlString = "\(Constant.baseUrlString)feeds/list"
    private var getAPIService: GetAPIProtocol
    
    init(getAPIService: GetAPIProtocol = GetAPIService()) {
        self.getAPIService = getAPIService
    }
    
    func feeds(
        isVegetarian: Bool = false,
        sizeEachFetch: Int = 20,
        from: Int = 0,
        onCompletion: @escaping (
            _ feedResult: FeedResultsModel?,
            _ recentFeeds: [FeedItemModel]?,
            _ errorMessage: String?
        ) -> Void
    ) {
        var url = URL(string: feedsUrlString)
        url?.append(queryItems: [
            URLQueryItem(name: "size", value: "\(sizeEachFetch)"),
            URLQueryItem(name: "from", value: "\(from)"),
            URLQueryItem(name: "vegetarian", value: "\(isVegetarian)"),
            URLQueryItem(name: "timezone", value: "+0700")
        ])
        getAPIService.getAPI(from: url, withModel: FeedResultsModel.self) { apiData, errorMessage in
            if let errorMessage = errorMessage {
                return onCompletion(nil, nil,errorMessage)
            } else if let apiData = apiData {
                var recentFeeds = [FeedItemModel]()
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
