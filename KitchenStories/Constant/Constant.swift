//
//  Constant.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

enum Constant {
    static let mainOrangeColor = UIColor.orange
    static let secondaryColor = UIColor.orange
    
    static let invalidUrlMessage = "URL is invalid. Please update your application to the latest version or contact our Customer Service."
    
    static let loadingColor: UIColor = UIColor.gray.withAlphaComponent(0.4)
    
    static let placholderText1 = "This is placholder Text 1"
    static let placholderText2 = "This is placholder Text 2, this one is a bit longer than placeholder Text 1"
}

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
