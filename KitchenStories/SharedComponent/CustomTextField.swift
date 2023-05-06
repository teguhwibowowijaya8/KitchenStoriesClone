//
//  CustomTextField.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

class CustomTextField: UIView {
    private lazy var fieldNameLabel: UILabel = {
       let fieldNameLabel = UILabel()
        fieldNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fieldNameLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        fieldNameLabel.numberOfLines = 0
        
        return fieldNameLabel
    }()
    
    private lazy var textField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        
        return textField
    }()

}
