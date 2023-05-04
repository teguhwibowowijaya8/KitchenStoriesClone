//
//  RecipePreparationTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 01/05/23.
//

import UIKit

struct RecipePreparationCellParams {
    let preparationNumber: Int
    let preparationDescription: String
}

class RecipePreparationTableViewCell: UITableViewCell {
    static let identifier = "RecipePreparationTableViewCell"
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        
        return containerView
    }()
    
    private lazy var preparationNumberLabel: UILabel = {
        let preparationNumberLabel = UILabel()
        
        preparationNumberLabel.font = .boldSystemFont(ofSize: 15)
        preparationNumberLabel.numberOfLines = 0
        preparationNumberLabel.adjustsFontSizeToFitWidth = true
        preparationNumberLabel.textAlignment = .center
        preparationNumberLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        return preparationNumberLabel
    }()
    
    private lazy var preparationDescriptionTextView: UITextView = {
       let preparationDescriptionTextView = UITextView()
        
        preparationDescriptionTextView.isEditable = false
        preparationDescriptionTextView.isSelectable = false
        preparationDescriptionTextView.isScrollEnabled = false
        
        preparationDescriptionTextView.font = .systemFont(ofSize: 15)
        preparationDescriptionTextView.contentInset = .zero
        preparationDescriptionTextView.textContainerInset = .zero
        
        preparationDescriptionTextView.setContentHuggingPriority(.required, for: .vertical)
        preparationDescriptionTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return preparationDescriptionTextView
    }()
    
    private lazy var preparationStackView: UIStackView = {
        let preparationStackView = UIStackView()
        preparationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        preparationStackView.axis = .horizontal
        preparationStackView.distribution = .fillProportionally
        preparationStackView.alignment = .top
        preparationStackView.spacing = 8
        
        return preparationStackView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(
        recipePreparation: RecipePreparationCellParams?,
        isLoading: Bool
    ) {
        self.backgroundColor = .gray.withAlphaComponent(0.3)
        addSubviews()
        setComponentConstraints()
        
        if isLoading {
            showLoadingView()
            return
        }
        
        guard let recipePreparation = recipePreparation
        else { return }
        
        removeLoadingView()
        
        preparationNumberLabel.text = "\(recipePreparation.preparationNumber)"
        preparationDescriptionTextView.text = recipePreparation.preparationDescription
    }
    
    private func addSubviews() {
        self.contentView.addSubview(containerView)
        containerView.addSubview(preparationStackView)
        preparationStackView.addArrangedSubview(preparationNumberLabel)
        preparationStackView.addArrangedSubview(preparationDescriptionTextView)
    }

    private func setComponentConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            preparationStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            preparationStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            preparationStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            preparationStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    private func showLoadingView() {
        preparationNumberLabel.text = Constant.shortPlaceholderText
        preparationNumberLabel.textColor = .clear
        preparationNumberLabel.backgroundColor = Constant.loadingColor
        
        preparationDescriptionTextView.text = Constant.placholderText2
        preparationDescriptionTextView.textColor = .clear
        preparationDescriptionTextView.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        preparationNumberLabel.text = ""
        preparationNumberLabel.textColor = .label
        preparationNumberLabel.backgroundColor = .clear
        
        preparationDescriptionTextView.text = ""
        preparationDescriptionTextView.textColor = .label
        preparationDescriptionTextView.backgroundColor = .clear
    }
}
