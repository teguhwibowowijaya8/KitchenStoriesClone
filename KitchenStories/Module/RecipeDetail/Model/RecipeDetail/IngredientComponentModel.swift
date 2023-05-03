//
//  IngredientComponentModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct IngredientComponentModel: Codable {
    let id: Int
    let ingredient: IngredientModel
    let extraComment: String?
    let position: Int
    let measurements: [MeasurementModel]
    
    func measurementString(servingCount: Int) -> String? {
        var measurementString: String = ""
        for (index, measurement) in measurements.enumerated() {
            if index == 0 {
                measurementString = measurement.measurementString(servingCount: servingCount)
            } else {
                measurementString += "(\(measurement.measurementString(servingCount: servingCount)))"
            }
        }
        
        return measurementString == "" ? nil : measurementString
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ingredient
        case extraComment = "extra_comment"
        case position
        case measurements
    }
}
