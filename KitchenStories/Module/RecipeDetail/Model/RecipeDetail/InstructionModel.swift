//
//  InstructionModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 02/05/23.
//

import Foundation

enum ApplianceType: String, Codable {
    case foodThermometer = "food_thermometer"
    case oven = "oven"
    case stovetop = "stovetop"
}

struct InstructionModel: Codable {
    let id: Int
    let displayText: String
    let position: Int
    let startTime: Int
    let endTime: Int
    let temperature: Double?
    let appliance: ApplianceType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayText = "display_text"
        case position
        case startTime = "start_time"
        case endTime = "end_time"
        case temperature
        case appliance
    }
}
