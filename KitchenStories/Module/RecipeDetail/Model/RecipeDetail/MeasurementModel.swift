//
//  MeasurementModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct MeasurementModel: Codable {
    let id: Int
    var quantity: String
    let unit: MeasurementUnitModel
    var quantityDouble: Double?
    
    
    func measurementString(servingCount: Int) -> String {
        guard let quantityDouble = quantityDouble
        else { return "" }
        
        let finalQuantity = quantityDouble * Double(servingCount)
        let quantityString = finalQuantity.fractionString()
        return "\(quantityString) \(unit.name)"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case quantity
        case unit
    }
}
