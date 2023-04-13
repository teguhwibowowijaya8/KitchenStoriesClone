//
//  HomeViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

protocol HomeViewModelDelegate {
    func handleFetchFeedsCompleted()
}

class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    var errorMessage: String?
    var isLoading: Bool = false
    
    var feeds: FeedResultsModel?
    var recentFeeds: FeedModel
    var dummyFeeds: FeedResultsModel
    
    private var fetchFrom: Int = 0
    private let sizeEachFetch: Int = 20
    
    private let getFeedsAPIService: GetFeedAPIService
    
    init() {
        getFeedsAPIService = GetFeedAPIService()
        recentFeeds = FeedModel(
            type: FeedType.recent,
            name: "Recent",
            category: "recent",
            minItems: 0,
            item: nil,
            items: [FeedItemModel]()
        )
        dummyFeeds = LoadingFeeds.feeds
    }
    
    func fetchFeeds() {
        guard isLoading == false else { return }
        
        errorMessage = nil
        isLoading = true
        
        getFeedsAPIService.feeds(
            sizeEachFetch: sizeEachFetch,
            from: fetchFrom
        ) {
            [weak self] feedResult, recentFeedsResult, errorMessage in
            if let errorMessage = errorMessage {
                self?.errorMessage = errorMessage
            } else{
                if let feedResult = feedResult {
                    if self?.feeds == nil {
                        self?.feeds = feedResult
                    } else {
                        self?.feeds?.results.append(contentsOf: feedResult.results)
                    }
                }
                
                if let recentFeedsResult = recentFeedsResult {
                    self?.recentFeeds.items?.append(contentsOf: recentFeedsResult)
                }
                
                self?.fetchFrom += (feedResult?.results.count ?? 0) + (recentFeedsResult?.count ?? 0)
            }
            self?.isLoading = false
            self?.delegate?.handleFetchFeedsCompleted()
        }
    }
}
