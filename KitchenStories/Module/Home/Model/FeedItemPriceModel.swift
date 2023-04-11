//
//  FeedItemPriceModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import Foundation

struct FeedItemPriceModel: Codable {
    let total: Double?
    let updatedAt: Date?
    let portion: Double?
    let consumptionTotal: Double?
    let consumptionPortion: Double?
    
    enum CodingKeys: String, CodingKey {
        case total
        case updatedAt = "updated_at"
        case portion
        case consumptionTotal = "consumption_total"
        case consumptionPortion = "consumption_portion"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Double.self, forKey: .total)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.portion = try container.decode(Double.self, forKey: .portion)
        self.consumptionTotal = try container.decode(Double.self, forKey: .consumptionTotal)
        self.consumptionPortion = try container.decode(Double.self, forKey: .consumptionPortion)
    }
}
