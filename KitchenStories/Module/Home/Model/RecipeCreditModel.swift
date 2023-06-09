//
//  RecipeCreditModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

enum CreditType: String, Codable {
    case brand = "brand"
    case typeInternal = "internal"
    case community = "community"
}

struct RecipeCreditModel: Codable, Hashable {
    let type: CreditType?
    let imageUrlString: String?
    let name: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case imageUrlString = "image_url"
        case name
        case id
    }
}
