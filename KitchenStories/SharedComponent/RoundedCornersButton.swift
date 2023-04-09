//
//  RoundedCornersButton.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 09/04/23.
//

import UIKit

class RoundedCornersButton: UIButton {
    
    var buttonTitle: String = "Button" {
        didSet {
            self.setAttributedTitle(buttonAttributedTitle(), for: .normal)
        }
    }
    
    private func buttonAttributedTitle() -> NSAttributedString {
        return NSAttributedString(
            string: buttonTitle,
            attributes: [
                .foregroundColor : UIColor.white,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]
        )
    }
    
    private var heightConstraint: NSLayoutConstraint?
    var buttonHeight: CGFloat = 0 {
        didSet {
            heightConstraint?.isActive = false
            heightConstraint = self.heightAnchor.constraint(equalToConstant: buttonHeight)
            heightConstraint?.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        buttonHeight = 35
        self.backgroundColor = .systemGreen.withAlphaComponent(0.9)
        self.layer.cornerRadius = self.bounds.size.height * 0.5
        self.setAttributedTitle(buttonAttributedTitle(), for: .normal)
    }
}
