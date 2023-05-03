//
//  MeasurementModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

struct MeasurementModel: Codable {
    let id: Int
    let quantity: String
    let unit: MeasurementUnitModel
    
    func measurementString(servingCount: Int) -> String {
        let servingCountDouble = Double(servingCount)
        
        print("\(servingCount)x\(quantity) \(unit.displayPlural)")
        var finalQuantity: Double?
        if let quantityDouble = Double(quantity) {
            finalQuantity = quantityDouble * servingCountDouble
        }
        
        if let finalQuantity = finalQuantity,
           let unitDisplayNoun = unit.unitString(servingCount: finalQuantity) {
            return "\(finalQuantity) \(unitDisplayNoun)"
        }
        return "\(servingCount)x\(quantity)\(unit.abbreviation)"
    }
}
