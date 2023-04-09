//
//  ParseDataService.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import Foundation

protocol ParseDataProtocol {
    func parse<T: Decodable>(
        _ data: Data,
        to model: T.Type,
        onCompletion: (_ parsedData: T?, _ errorMessage: String?) -> Void
    )
}

struct ParseDataService: ParseDataProtocol {
    func parse<T>(
        _ data: Data,
        to model: T.Type,
        onCompletion: (_ parsedData: T?, _ errorMessage: String?) -> Void
    ) where T : Decodable {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(model, from: data)
            return onCompletion(decodedData, nil)
        } catch let error {
            return onCompletion(nil, error.localizedDescription)
        }
    }
}
