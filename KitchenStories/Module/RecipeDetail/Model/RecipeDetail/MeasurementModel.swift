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
}
