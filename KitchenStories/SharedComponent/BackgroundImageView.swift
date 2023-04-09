//
//  BackgroundImageView.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 09/04/23.
//

import UIKit

class BackgroundImageView: UIImageView {
    private var opacityColor: UIColor = .black
    private var opacityValue: CGFloat = 0.5
    
    private lazy var opacityView: UIView = {
        let opacityView = UIView()
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.backgroundColor = opacityColor.withAlphaComponent(opacityValue)
        
        return opacityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelfAttributes()
        setBackgroundWithOpacityView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSelfAttributes()
        setBackgroundWithOpacityView()
    }
    
    private func setupSelfAttributes() {
        self.contentMode = .scaleAspectFill
    }
    
    func setBackgroundImageOpacity(
        color: UIColor? = nil,
        opacity: CGFloat? = nil
    ) {
        if let color = color { opacityColor = color }
        
        if let opacity = opacity { opacityValue = opacity }
        
        opacityView.backgroundColor = opacityColor.withAlphaComponent(opacityValue)
    }
    
    private func setBackgroundWithOpacityView() {
        self.addSubview(opacityView)
        
        NSLayoutConstraint.activate([
            opacityView.topAnchor.constraint(equalTo: self.topAnchor),
            opacityView.leftAnchor.constraint(equalTo: self.leftAnchor),
            opacityView.rightAnchor.constraint(equalTo: self.rightAnchor),
            opacityView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
