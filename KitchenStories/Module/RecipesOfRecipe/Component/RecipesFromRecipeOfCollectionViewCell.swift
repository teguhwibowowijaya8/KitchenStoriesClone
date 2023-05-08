//
//  RecipesFromRecipeOfCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import UIKit

struct RecipesFromRecipeOfCellParams {
    let name: String
    let imageUrlString: String
    var description: String? = nil
}

class RecipesFromRecipeOfCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipesFromRecipeOfCollectionViewCell"
    
    static let recipeNameSize: CGFloat = 35
    static let recipeDescriptionSize: CGFloat = 13
    static let verticalContainerSpacing: CGFloat = 10
    static let verticalTextsSpacing: CGFloat = 5
    
    private var getNetworkImageService = GetNetworkImageService()
    
    
    private lazy var recipeNameLabel: UILabel = {
       let recipeNameLabel = UILabel()
        recipeNameLabel.font = .boldSystemFont(ofSize: RecipesFromRecipeOfCollectionViewCell.recipeNameSize)
        recipeNameLabel.numberOfLines = 0
        
        recipeNameLabel.setContentHuggingPriority(.required, for: .vertical)
        recipeNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return recipeNameLabel
    }()
    
    private lazy var recipeDescriptionTextView: UITextView = {
        let recipeDescriptionTextView = UITextView()
        recipeDescriptionTextView.isSelectable = false
        recipeDescriptionTextView.isEditable = false
        recipeDescriptionTextView.isScrollEnabled = false
        recipeDescriptionTextView.font = .systemFont(ofSize: 13)
        recipeDescriptionTextView.removePadding()
        recipeDescriptionTextView.isHidden = true
        
        recipeDescriptionTextView.setContentHuggingPriority(.required, for: .vertical)
        recipeDescriptionTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return recipeDescriptionTextView
    }()
    
    private lazy var verticalTextsStackView: UIStackView = {
        let verticalTextsStackView = UIStackView()
        verticalTextsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalTextsStackView.axis = .vertical
        verticalTextsStackView.distribution = .fill
        verticalTextsStackView.alignment = .fill
        verticalTextsStackView.spacing = RecipesFromRecipeOfCollectionViewCell.verticalTextsSpacing
        
        return verticalTextsStackView
    }()
    
    private lazy var textsContainerView: UIView = {
       let textsContainerView = UIView()
        return textsContainerView
    }()
    
    private lazy var recipeImageView: UIImageView = {
        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        
        return recipeImageView
    }()
    
    private lazy var verticalContainerStackView: UIStackView = {
       let verticalContainerStackView = UIStackView()
        verticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalContainerStackView.axis = .vertical
        verticalContainerStackView.distribution = .fill
        verticalContainerStackView.alignment = .fill
        verticalContainerStackView.spacing = RecipesFromRecipeOfCollectionViewCell.verticalContainerSpacing
        
        return verticalContainerStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setComponentConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImageView.image = nil
        getNetworkImageService.cancel()
    }
    
    func setupCell(recipe: RecipesFromRecipeOfCellParams?, isLoading: Bool) {
        guard isLoading == false,
              let recipe = recipe
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        recipeImageView.loadImageFromUrl(
            recipe.imageUrlString,
            defaultImage: nil,
            getImageNetworkService: getNetworkImageService
        )
        recipeNameLabel.text = recipe.name
        if let recipeDescription = recipe.description {
            recipeDescriptionTextView.text = recipeDescription
            recipeDescriptionTextView.isHidden = false
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(verticalContainerStackView)
        
        verticalContainerStackView.addArrangedSubview(textsContainerView)
        verticalContainerStackView.addArrangedSubview(recipeImageView)
        
        textsContainerView.addSubview(verticalTextsStackView)
        verticalTextsStackView.addArrangedSubview(recipeNameLabel)
        verticalTextsStackView.addArrangedSubview(recipeDescriptionTextView)
    }
    
    private func setComponentConstraints() {
        NSLayoutConstraint.activate([
            verticalContainerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalContainerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            verticalContainerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            verticalContainerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            verticalTextsStackView.topAnchor.constraint(equalTo: textsContainerView.topAnchor),
            verticalTextsStackView.leftAnchor.constraint(equalTo: textsContainerView.leftAnchor, constant: Constant.horizontalSpacing),
            verticalTextsStackView.rightAnchor.constraint(equalTo: textsContainerView.rightAnchor, constant: -Constant.horizontalSpacing),
            verticalTextsStackView.bottomAnchor.constraint(equalTo: textsContainerView.bottomAnchor),
            
            recipeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor)
        ])
    }
    
    private func showLoadingView() {
        recipeDescriptionTextView.isHidden = true
        
        recipeNameLabel.text = Constant.placholderText1
        recipeNameLabel.textColor = .clear
        recipeNameLabel.backgroundColor = Constant.loadingColor
        
        recipeImageView.image = nil
        recipeImageView.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        recipeNameLabel.textColor = .label
        recipeNameLabel.backgroundColor = .clear
        
        recipeImageView.backgroundColor = .clear
    }
}

extension RecipesFromRecipeOfCollectionViewCell {
    static func getRecipeCardEstimatedHeight(
        with recipe: RecipesFromRecipeOfCellParams,
        screenWidth: CGFloat
    ) -> CGFloat {
        var finalHeight: CGFloat = screenWidth
        
        let textsWidth: CGFloat = screenWidth - (Constant.horizontalSpacing * 2)
        finalHeight += Utilities.getLabelHeight(
            textSize: RecipesFromRecipeOfCollectionViewCell.recipeNameSize,
            maxLines: 0,
            desiredText: recipe.name,
            availableWidth: textsWidth)
        
        
        if let recipeDescription = recipe.description {
            finalHeight += Utilities.getTextViewHeight(
                textSize: RecipesFromRecipeOfCollectionViewCell.recipeDescriptionSize,
                maxLines: 0,
                desiredText: recipeDescription,
                availableWidth: textsWidth
            )
        }
        
        let cellVerticalSpacing = RecipesFromRecipeOfCollectionViewCell.verticalContainerSpacing + RecipesFromRecipeOfCollectionViewCell.verticalTextsSpacing
        
        finalHeight += cellVerticalSpacing
        
        return finalHeight
    }
}
