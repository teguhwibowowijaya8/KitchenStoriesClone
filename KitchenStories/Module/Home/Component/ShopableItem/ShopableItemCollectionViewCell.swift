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
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .gray.withAlphaComponent(0.2)
            containerView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.contentMode = .scaleAspectFill
            itemImageView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.font = .boldSystemFont(ofSize: 16)
            itemNameLabel.numberOfLines = 4
        }
    }
    
    
    @IBOutlet weak var itemRecipesCountLabel: UILabel! {
        didSet {
            itemRecipesCountLabel.font = .systemFont(ofSize: 12)
            itemRecipesCountLabel.textColor = .darkGray
            itemRecipesCountLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    @IBOutlet weak var shopIngredientsButton: UIButton! {
        didSet {
            shopIngredientsButton.tintColor = .white
            shopIngredientsButton.backgroundColor = .red.withAlphaComponent(0.5)
            shopIngredientsButton.layer.cornerRadius = 10
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
        imageUrlString: String,
        itemName: String,
        recipesCount: Int
    ) {
        itemImageView.loadImageFromUrl(
            imageUrlString,
            defaultImage: defaultItemImage,
            getImageNetworkService: getNetworkImageService
        )
        
        itemNameLabel.text = itemName
        itemRecipesCountLabel.text = "\(recipesCount) recipes"
    }

}
