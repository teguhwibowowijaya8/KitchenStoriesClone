//
//  RecipeTipsModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct RecipeTipsModel: Codable {
    let count: Int
    let result: [TipModel]
}
