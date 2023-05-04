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
    
    var measurementString: String {
        print("measurementQtyOrigin: \(quantity)")
        if let quantityDouble = Double(quantity) {
            print("measurementQtyDouble: \(quantityDouble)")
        }
        
        return "\(quantity) \(unit.name)"
    }
}
