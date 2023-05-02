//
//  MeasurementUnitModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

enum MeasurementSystem: String, Codable {
    case imperial
    case metric
    case none
}

struct MeasurementUnitModel: Codable {
    let name: String
    let abbreviation: String
    let displaySingular: String
    let displayPlural: String
    let system: MeasurementSystem
    
    enum CodingKeys: String, CodingKey {
        case name
        case abbreviation
        case displaySingular = "display_singular"
        case displayPlural = "display_plural"
        case system
    }
}
