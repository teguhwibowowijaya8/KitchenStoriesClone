//
//  GetNetworkImageService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

protocol GetNetworkImageProtocol {
    func getImage(
        _ urlString: String,
        onCompletion: @escaping (_ urlImage: UIImage?, _ errorMessage: String?) -> Void
    )
    
    func cancel()
}

class GetNetworkImageService: GetNetworkImageProtocol {
    private var task: URLSessionTask?
    private var fetchService: FetchDataProtocol
    
    init(
        fetchService: FetchDataProtocol = FetchDataService()
    ) {
        self.fetchService = fetchService
    }
    
    func getImage(
        _ urlString: String,
        onCompletion: @escaping (_ urlImage: UIImage?, _ errorMessage: String?) -> Void
    ) {
        guard let url = URL(string: urlString)
        else { return onCompletion(nil, Constant.invalidUrlMessage)}
        
        task = fetchService.fetch(url: url, onCompletion: { result in
            switch result {
            case .success(let fetchedData):
                return onCompletion(UIImage(data: fetchedData), nil)
            case .failure(let fetchedError):
                return onCompletion(nil, fetchedError.getErrorMessage())
            }
            
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
