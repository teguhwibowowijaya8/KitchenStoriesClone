//
//  ShopableItemCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

struct ShopableItemCellParams {
    let imageUrlString: String
    let recipeName: String
    let recipesCount: Int
}

class ShopableItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShopableItemCollectionViewCell"
    
    private var getNetworkImageService = GetNetworkImageService()
    private let containerBackgroundColor: UIColor = .gray.withAlphaComponent(0.2)
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = containerBackgroundColor
            containerView.layer.cornerRadius = Constant.cornerRadius
        }
    }
    
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.contentMode = .scaleAspectFill
            recipeImageView.layer.cornerRadius = Constant.cornerRadius
        }
    }
    
    @IBOutlet weak var recipeNameLabel: UILabel! {
        didSet {
            recipeNameLabel.font = .boldSystemFont(ofSize: 16)
            recipeNameLabel.numberOfLines = 4
        }
    }
    
    
    @IBOutlet weak var recipeRecipesCountLabel: UILabel! {
        didSet {
            recipeRecipesCountLabel.font = .systemFont(ofSize: 12)
            recipeRecipesCountLabel.textColor = .darkGray
            recipeRecipesCountLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    @IBOutlet weak var shopIngredientsButton: UIButton! {
        didSet {
            shopIngredientsButton.tintColor = .white
            shopIngredientsButton.backgroundColor = .red.withAlphaComponent(0.5)
            shopIngredientsButton.layer.cornerRadius = Constant.cornerRadius
            shopIngredientsButton.setAttributedTitle(
                NSAttributedString(
                    string: "Show Recipes",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
                    ]
                ),
                for: .normal
            )
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
        getNetworkImageService.cancel()
    }
    
    func setupCell(
        recipe: ShopableItemCellParams?,
        isLoading: Bool
    ) {
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
        
        recipeNameLabel.text = recipe.recipeName
        recipeRecipesCountLabel.text = "\(recipe.recipesCount) recipes"
    }
    
    private func showLoadingView() {
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = Constant.loadingColor.cgColor
        containerView.layer.borderWidth = 0.5
        recipeImageView.backgroundColor = Constant.loadingColor
        recipeNameLabel.backgroundColor = Constant.loadingColor
        recipeRecipesCountLabel.backgroundColor = Constant.loadingColor
        shopIngredientsButton.backgroundColor = Constant.loadingColor
        
        recipeNameLabel.text = Constant.placholderText2
        recipeRecipesCountLabel.text = Constant.placholderText1
        recipeImageView.image = nil
        
        recipeNameLabel.textColor = .clear
        recipeRecipesCountLabel.textColor = .clear
        shopIngredientsButton.tintColor = .clear
        shopIngredientsButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = 0
        recipeImageView.backgroundColor = containerBackgroundColor
        recipeNameLabel.backgroundColor = .clear
        recipeRecipesCountLabel.backgroundColor = .clear
        shopIngredientsButton.backgroundColor = Constant.secondaryColor
        
        recipeNameLabel.textColor = .label
        recipeRecipesCountLabel.textColor = .label
        shopIngredientsButton.tintColor = .white
        shopIngredientsButton.isUserInteractionEnabled = true
    }

}

extension ShopableItemCollectionViewCell {
    static func cellSize(availableWidth: CGFloat) -> CGSize {
        let itemHeight: CGFloat = 145
        let itemWidth = availableWidth * 0.7
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
