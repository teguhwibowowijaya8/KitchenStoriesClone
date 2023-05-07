//
//  FetchDataService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import Foundation

enum FetchDataError: Error {
    case fetchError(_ message: String)
    case noData
    
    func getErrorMessage() -> String {
        switch self {
        case .fetchError(let message):
            return message
        case .noData:
            return "No more Data to be Fetched."
        }
    }
}

protocol FetchDataProtocol {
    mutating func fetch(
        url: URL,
        onCompletion: @escaping (Result<Data, FetchDataError>) -> Void
    ) -> URLSessionTask
}

struct FetchDataService: FetchDataProtocol {
    private let apiKey = "d1be100eb3msh861d504d59b7fb9p1abaddjsn38aba13309ba"
    private let apiHost = "tasty.p.rapidapi.com"
    
    func fetch(
        url: URL,
        onCompletion: @escaping (Result<Data, FetchDataError>) -> Void
    ) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(apiHost, forHTTPHeaderField: "X-RapidAPI-Host")
        
        return URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("hereee error url: \(url.absoluteString)")
                print("hereeeee pure error: \(error)")
                return onCompletion(.failure(
                    .fetchError(error.localizedDescription)
                ))
            } else if let response = response as? HTTPURLResponse,
                      response.statusCode > 299 {
                return onCompletion(.failure(
                    .fetchError(response.description)
                ))
            }
            
            if let data = data {
                return onCompletion(.success(data))
            }
            
            return onCompletion(.failure(.noData))
        }
    }
}
