//
//  RecipesTitleCollectionReusableView.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import UIKit

class RecipesTitleCollectionReusableView: UICollectionReusableView {
    static let identifier = "RecipesTitleCollectionReusableView"
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constant.horizontalSpacing),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constant.horizontalSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
