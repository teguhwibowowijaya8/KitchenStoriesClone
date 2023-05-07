//
//  String+numericValue.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import Foundation

extension String {
    func numericValue() -> Double? {
        let numericDict = ["½": 0.5, "⅓": 0.33, "⅔": 0.67, "¼": 0.25, "¾": 0.75, "⅕": 0.2, "⅖": 0.4, "⅗": 0.6, "⅘": 0.8, "⅙": 0.17, "⅚": 0.83, "⅛": 0.13, "⅜": 0.38, "⅝": 0.63, "⅞": 0.88]
        
        var nonNumeric: Double = 0
        var numeric: String = ""
        for char in self {
            let stringChar = String(char)
            if let nonNum = numericDict[stringChar] {
                nonNumeric = nonNum
                break
            } else {
                numeric += stringChar
            }
        }
        
        var finalNum: Double = nonNumeric
        if numeric != "",
            let numericDouble = Double(numeric) {
            finalNum += numericDouble
        }
        
        return Double(finalNum)
    }
}
