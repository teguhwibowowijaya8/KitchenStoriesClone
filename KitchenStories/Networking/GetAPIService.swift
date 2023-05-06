//
//  GetAPIService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import Foundation

protocol GetAPIProtocol {
    func getAPI<T: Decodable>(
        from url: URL?,
        withModel model: T.Type,
        onCompletion: @escaping (_ apiData: T?, _ errorMessage: String?) -> Void
    )
    
    func cancel()
}

class GetAPIService: GetAPIProtocol {
    private var fetchService: FetchDataProtocol
    private let parseService: ParseDataProtocol
    private var dataTask: URLSessionTask?
    
    init(
        fetchService: FetchDataProtocol = FetchDataService(),
        parseService: ParseDataProtocol = ParseDataService()
    ) {
        self.fetchService = fetchService
        self.parseService = parseService
    }
    
    func getAPI<T>(
        from url: URL?,
        withModel model: T.Type,
        onCompletion: @escaping (T?, String?) -> Void
    ) where T : Decodable {
        
        guard let url = url
        else { return onCompletion(nil, Constant.invalidUrlMessage)}
            
        dataTask = fetchService.fetch(url: url) { [weak self] result in
            switch result {
            case .success(let fetchedData):
                self?.parseService.parse(fetchedData, to: model) { parsedData, errorMessage in
                    if let parsedData = parsedData {
                        return onCompletion(parsedData, nil)
                    } else if let errorMessage = errorMessage {
                        return onCompletion(nil, errorMessage)
                    }
                }
                
            case .failure(let fetchedError):
                return onCompletion(nil, fetchedError.getErrorMessage())
            }
        }
        
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
}
