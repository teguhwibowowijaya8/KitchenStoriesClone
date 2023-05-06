//
//  ProfileInfoTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

struct ProfileInfoCellParams {
    var fieldName: String
    var fieldDefaultValue: String?
    var fieldErrorMessage: String?
}

class ProfileInfoTableViewCell: UITableViewCell {
    static let identifier = "ProfileInfoTableViewCell"
    
    private let fieldContainerBackgroundColor: UIColor = .gray.withAlphaComponent(0.3)
    private let fieldSmallFontSize: CGFloat = 10
    
    @IBOutlet weak var fieldContainerView: UIView!{
        didSet {
            fieldContainerView.backgroundColor = fieldContainerBackgroundColor
            fieldContainerView.clipsToBounds = true
            fieldContainerView.layer.cornerRadius = Constant.cornerRadius
            fieldContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var fieldNameLabel: UILabel! {
        didSet {
            fieldNameLabel.font = .systemFont(ofSize: fieldSmallFontSize)
            fieldNameLabel.numberOfLines = 0
            fieldNameLabel.textColor = .gray
        }
    }
    
    @IBOutlet weak var fieldTextField: UITextField! {
        didSet {
            fieldTextField.font = .systemFont(ofSize: 15)
            fieldTextField.isEnabled = false
        }
    }
    
    @IBOutlet weak var fieldToggleButton: UIButton! {
        didSet {
            fieldToggleButton.tintColor = Constant.secondaryColor
            fieldToggleButton.isHidden = true
        }
    }
    
    
    @IBOutlet weak var fieldBottomLayerView: UIView!
    
    @IBOutlet weak var errorMessageContainerView: UIView! {
        didSet {
            errorMessageContainerView.isHidden = true
        }
    }
    
    @IBOutlet weak var fieldErrorLabel: UILabel! {
        didSet {
            fieldErrorLabel.textColor = .red
            fieldErrorLabel.numberOfLines = 0
            fieldErrorLabel.font = .systemFont(ofSize: fieldSmallFontSize)
        }
    }
    
    
    func setupCell(fieldInfo: ProfileInfoCellParams?, isLoading: Bool) {
        guard isLoading == false,
              let fieldInfo = fieldInfo
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        fieldNameLabel.text = fieldInfo.fieldName
        fieldTextField.placeholder = "\(fieldInfo.fieldName)..."
        
        if let defaultValue = fieldInfo.fieldDefaultValue, defaultValue != "" {
            fieldTextField.text = defaultValue
        }
        
        if let errorMessage = fieldInfo.fieldErrorMessage, errorMessage != "" {
            fieldErrorLabel.text = errorMessage
            errorMessageContainerView.isHidden = false
        }
    }
    
    private func showLoadingView() {
        fieldNameLabel.isHidden = true
        fieldTextField.isHidden = true
        fieldToggleButton.isHidden = true
        fieldBottomLayerView.isHidden = true
        errorMessageContainerView.isHidden = true
        
        fieldContainerView.backgroundColor = Constant.loadingColor
        
    }
    
    private func removeLoadingView() {
        fieldNameLabel.isHidden = false
        fieldTextField.isHidden = false
        fieldBottomLayerView.isHidden = false
        
        fieldContainerView.backgroundColor = fieldContainerBackgroundColor
    }
    
}
