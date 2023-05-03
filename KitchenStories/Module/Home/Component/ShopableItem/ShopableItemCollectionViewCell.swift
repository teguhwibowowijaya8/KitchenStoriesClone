//
//  ShopableItemCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

class ShopableItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShopableItemCollectionViewCell"
    
    private let defaultItemImage = UIImage(systemName: "fork.knife.circle")
    
    private var getNetworkImageService = GetNetworkImageService()
    private let containerBackgroundColor: UIColor = .gray.withAlphaComponent(0.2)
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.isSkeletonable = true
            containerView.backgroundColor = containerBackgroundColor
            containerView.layer.cornerRadius = Constant.cornerRadius
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.isSkeletonable = true
            itemImageView.contentMode = .scaleAspectFill
            itemImageView.layer.cornerRadius = Constant.cornerRadius
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.isSkeletonable = true
            itemNameLabel.font = .boldSystemFont(ofSize: 16)
            itemNameLabel.numberOfLines = 4
        }
    }
    
    
    @IBOutlet weak var itemRecipesCountLabel: UILabel! {
        didSet {
            itemRecipesCountLabel.isSkeletonable = true
            itemRecipesCountLabel.font = .systemFont(ofSize: 12)
            itemRecipesCountLabel.textColor = .darkGray
            itemRecipesCountLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    @IBOutlet weak var shopIngredientsButton: UIButton! {
        didSet {
            shopIngredientsButton.isSkeletonable = true
            shopIngredientsButton.tintColor = .white
            shopIngredientsButton.backgroundColor = .red.withAlphaComponent(0.5)
            shopIngredientsButton.layer.cornerRadius = Constant.cornerRadius
            shopIngredientsButton.setAttributedTitle(
                NSAttributedString(
                    string: "Shop Ingredients",
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
        itemImageView.image = nil
        getNetworkImageService.cancel()
    }
    
    func setupCell(
        imageUrlString: String? = nil,
        itemName: String? = nil,
        recipesCount: Int? = nil
    ) {
        guard let imageUrlString = imageUrlString,
              let itemName = itemName,
              let recipesCount = recipesCount
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        itemImageView.loadImageFromUrl(
            imageUrlString,
            defaultImage: defaultItemImage,
            getImageNetworkService: getNetworkImageService
        )
        
        itemNameLabel.text = itemName
        itemRecipesCountLabel.text = "\(recipesCount) recipes"
    }
    
    private func showLoadingView() {
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = Constant.loadingColor.cgColor
        containerView.layer.borderWidth = 0.5
        itemImageView.backgroundColor = Constant.loadingColor
        itemNameLabel.backgroundColor = Constant.loadingColor
        itemRecipesCountLabel.backgroundColor = Constant.loadingColor
        shopIngredientsButton.backgroundColor = Constant.loadingColor
        
        itemNameLabel.text = Constant.placholderText2
        itemRecipesCountLabel.text = Constant.placholderText1
        itemImageView.image = nil
        
        itemNameLabel.textColor = .clear
        itemRecipesCountLabel.textColor = .clear
        shopIngredientsButton.tintColor = .clear
        shopIngredientsButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = 0
        itemImageView.backgroundColor = containerBackgroundColor
        itemNameLabel.backgroundColor = .clear
        itemRecipesCountLabel.backgroundColor = .clear
        shopIngredientsButton.backgroundColor = Constant.secondaryColor
        
        itemNameLabel.textColor = .label
        itemRecipesCountLabel.textColor = .label
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
