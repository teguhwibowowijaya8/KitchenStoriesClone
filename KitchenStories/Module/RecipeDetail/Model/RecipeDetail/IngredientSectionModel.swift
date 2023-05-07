//
//  IngredientSectionModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct IngredientSectionModel: Codable {
    var components: [IngredientComponentModel]
    let name: String?
    let position: Int
    
    enum CodingKeys: CodingKey {
        case components
        case name
        case position
    }
}
