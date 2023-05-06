//
//  BackgroundImage.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

enum BackgroundImage {
    case background1
    case background2
    case background3
    case background4
    
    var name: String {
        switch self {
        case .background1:
            return "background1"
        case .background2:
            return "background2"
        case .background3:
            return "background3"
        case .background4:
            return "background4"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.name)
    }
    
    static func getBy(index: Int) -> BackgroundImage? {
        switch index {
        case 0:
            return BackgroundImage.background1
        case 1:
            return BackgroundImage.background2
        case 2:
            return BackgroundImage.background3
        case 3:
            return BackgroundImage.background4
        default:
            return nil
        }
    }
}
