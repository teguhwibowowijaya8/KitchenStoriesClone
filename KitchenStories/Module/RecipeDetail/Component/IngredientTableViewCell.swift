//
//  IngredientTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 29/04/23.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    static let identifier = "IngredientTableViewCell"
    
    private lazy var ingredientNameLabel: UILabel = {
        let ingredientNameLabel = UILabel()
        ingredientNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        ingredientNameLabel.numberOfLines = 0
        ingredientNameLabel.font = .systemFont(ofSize: 13)
        
        return ingredientNameLabel
    }()
    
    private lazy var ingredientRatioLabel: UILabel = {
        let ingredientNameLabel = UILabel()
        
        ingredientNameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        ingredientNameLabel.numberOfLines = 0
        ingredientNameLabel.textAlignment = .right
        
        return ingredientNameLabel
    }()
    
    private lazy var containerStackView: UIStackView = {
       let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
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
        ingredientName: String? = nil,
        ingredientRatio: String? = nil,
        isLoading: Bool
    ) {
        addSubviews()
        setComponentsConstraints()
        
        if isLoading {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        if let ingredientName = ingredientName {
            ingredientNameLabel.text = ingredientName
            if let ingredientRatio = ingredientRatio {
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
