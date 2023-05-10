//
//  Double+FractionString.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import Foundation

extension Double {
    func fractionString() -> String {
        let fractionDict: [Double: String] = [0.5: "½", 0.33: "⅓", 0.67: "⅔", 0.25: "¼", 0.75: "¾", 0.2: "⅕", 0.4: "⅖", 0.6: "⅗", 0.8: "⅘", 0.17: "⅙", 0.83: "⅚", 0.13: "⅛", 0.38: "⅜", 0.63: "⅝", 0.88: "⅞"]
        
        let fraction = self.truncatingRemainder(dividingBy: 1)
        if fraction == 0.00 {
            return String(format: "%.0f", self)
        }
        
        if let closestFraction = fractionDict.min(by: { abs($0.key - fraction) < abs($1.key - fraction) })?.value {
            
            let numeric = Int(self) == 0 ? "" : "\(Int(floor(self)))"
            return "\(numeric)\(closestFraction)"
        }
        
        return String(format: "%.0f", self)
    }
}
