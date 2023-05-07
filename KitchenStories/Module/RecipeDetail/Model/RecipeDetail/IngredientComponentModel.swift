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
    var measurements: [MeasurementModel]
    
    func measurementString(servingCount: Int) -> String? {
        var measurementString: String = ""
        for measurement in measurements {
            let measurementOfIndex = measurement.measurementString(servingCount: servingCount)
            if measurementOfIndex == "" { continue }
            
            if measurementString == "" {
                measurementString = measurementOfIndex
            } else {
                measurementString += " (\(measurementOfIndex))"
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
