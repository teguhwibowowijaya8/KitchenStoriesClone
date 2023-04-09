//
//  BottomBorderTextField.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

class BottomBorderTextField: UITextField {
    private var heightConstraint: NSLayoutConstraint?
    var textFieldHeight: CGFloat = 0 {
        didSet {
            heightConstraint?.isActive = false
            heightConstraint = self.heightAnchor.constraint(equalToConstant: textFieldHeight)
            heightConstraint?.isActive = true
            
            
            setBottomBorder()
        }
    }
    
    private var bottomLineLayer: CALayer?
    
    private(set) var bottomBorderHeight: Int = 1 {
        didSet {
            setBottomBorder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    func setPlaceholder(_ value: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: value,
            attributes: [ .foregroundColor: UIColor.white ]
        )
    }
    
    private func setupTextField() {
        textFieldHeight = 35
        setPlaceholder("")
        self.textColor = .white
        self.font = .systemFont(ofSize: 13)
    }
    
    private func setBottomBorder() {
        bottomLineLayer?.removeFromSuperlayer()
        
        bottomLineLayer = CALayer()
        bottomLineLayer?.backgroundColor = UIColor.white.cgColor
        bottomLineLayer?.frame = CGRect(
            x: 0,
            y: Int(textFieldHeight) - bottomBorderHeight,
            width: Int(self.frame.width),
            height: bottomBorderHeight
        )
        
        self.borderStyle = .none
        self.layer.addSublayer(bottomLineLayer!)
    }
}
