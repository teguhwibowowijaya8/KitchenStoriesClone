//
//  IngredientTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 29/04/23.
//

import UIKit

struct IngredientCellParams {
    let ingredientName: String
    let ingredientRatio: String?
}

class IngredientTableViewCell: UITableViewCell {
    static let identifier = "IngredientTableViewCell"
    
    private lazy var ingredientNameLabel: UILabel = {
        let ingredientNameLabel = UILabel()
        
        ingredientNameLabel.numberOfLines = 0
        ingredientNameLabel.font = .systemFont(ofSize: 15)
        ingredientNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return ingredientNameLabel
    }()
    
    private lazy var ingredientRatioLabel: UILabel = {
        let ingredientRatioLabel = UILabel()
        
        ingredientRatioLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        ingredientRatioLabel.numberOfLines = 0
        ingredientRatioLabel.textAlignment = .right
        
        return ingredientRatioLabel
    }()
    
    private lazy var containerStackView: UIStackView = {
       let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        containerStackView.alignment = .fill
        containerStackView.spacing = 8
        
        return containerStackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(
        ingredient: IngredientCellParams?,
        isLoading: Bool
    ) {
        addSubviews()
        setComponentsConstraints()
        
        if isLoading {
            showLoadingView()
            return
        }
        
        if let ingredient = ingredient {
            removeLoadingView()
            
            ingredientNameLabel.text = ingredient.ingredientName
            if let ingredientRatio = ingredient.ingredientRatio {
                ingredientRatioLabel.text = ingredientRatio
            } else {
                ingredientRatioLabel.isHidden = true
            }
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(ingredientNameLabel)
        containerStackView.addArrangedSubview(ingredientRatioLabel)

    }

    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            containerStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            containerStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            containerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func showLoadingView() {
        ingredientNameLabel.text = Constant.placholderText1
        ingredientNameLabel.textColor = .clear
        ingredientNameLabel.backgroundColor = Constant.loadingColor
        
        ingredientRatioLabel.text = Constant.shortPlaceholderText
        ingredientRatioLabel.textColor = .clear
        ingredientRatioLabel.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        ingredientNameLabel.text = ""
        ingredientNameLabel.textColor = .label
        ingredientNameLabel.backgroundColor = .clear
        
        ingredientRatioLabel.text = ""
        ingredientRatioLabel.textColor = .label
        ingredientRatioLabel.backgroundColor = .clear
    }
}
