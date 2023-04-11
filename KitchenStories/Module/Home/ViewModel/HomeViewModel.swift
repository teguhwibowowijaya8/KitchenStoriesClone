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
    
    private let getFeedsAPIService = GetFeedAPIService()
    
    func fetchFeeds() {
        guard isLoading == false else { return }
        
        errorMessage = nil
        isLoading = true
        
        getFeedsAPIService.feeds { [weak self] feedResult, errorMessage in
            if let errorMessage = errorMessage {
                self?.errorMessage = errorMessage
            } else if let feedResult = feedResult {
                self?.feeds = feedResult
            }
            self?.isLoading = false
            self?.delegate?.handleFetchFeedsCompleted()
        }
    }
}
