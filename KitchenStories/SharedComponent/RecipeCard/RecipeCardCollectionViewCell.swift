//
//  RecipeCardCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 04/05/23.
//

import UIKit

struct RecipeCardCellParams {
    let imageUrlString: String
    let itemName: String
    var isLiked: Bool = false
    var itemFeedCredits: String? = nil
    var backgroundColor: UIColor = .clear
    var alignLabel: NSTextAlignment = .left
    var recipeNameFont: UIFont = .boldSystemFont(ofSize: 15)
    var recipeCreditFont: UIFont?
    var maxLines: Int = 3
    var imageHeight: CGFloat?
    var imageHeightEqualToContainerMultiplier: CGFloat?
}

class RecipeCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipeCardCollectionViewCell"
    
    private let itemIsLikedImage = UIImage(systemName: "heart.fill")
    private let itemIsNotLikedImage = UIImage(systemName: "heart")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constant.cornerRadius
            containerView.clipsToBounds = true
            containerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var itemIsLikedButton: UIButton! {
        didSet {
            itemIsLikedButton.tintColor = .red.withAlphaComponent(0.5)
            itemIsLikedButton.setImage(isLikedImage(), for: .normal)
            itemIsLikedButton.layer.cornerRadius = itemIsLikedButton.frame.height / 2
            itemIsLikedButton.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var itemFeedCreditsLabel: UILabel! {
        didSet {
            itemFeedCreditsLabel.font = .systemFont(ofSize: 12)
            itemFeedCreditsLabel.numberOfLines = 0
            itemFeedCreditsLabel.isHidden = true
        }
    }
    
    private lazy var recipeImageHeightConstraint: NSLayoutConstraint = {
        let recipeImageHeightConstraint = itemImageView.heightAnchor.constraint(equalToConstant: containerView.bounds.height * 0.5)
        
        return recipeImageHeightConstraint
    }()
    
    //    @IBOutlet weak var recipeImageHeightEqualContainerConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        recipeImageHeightConstraint.isActive = false
        getNetworkImageService.cancel()
    }
    
    func setupCell(
        recipe: RecipeCardCellParams?,
        isLoading: Bool
    ) {
        guard isLoading == false,
            let recipe = recipe
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        containerView.backgroundColor = recipe.backgroundColor
        
        itemImageView.loadImageFromUrl(
            recipe.imageUrlString,
            defaultImage: nil,
            getImageNetworkService: getNetworkImageService
        )
        
        print("itemName: \(recipe.itemName)")
        itemNameLabel.text = recipe.itemName
        itemNameLabel.textAlignment = recipe.alignLabel
        itemNameLabel.numberOfLines = recipe.maxLines
        itemNameLabel.font = recipe.recipeNameFont
        
        let isLikedButtonImage = isLikedImage(recipe.isLiked)
        itemIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        if let itemFeedCredits = recipe.itemFeedCredits {
            itemFeedCreditsLabel.text = "Presented by \(itemFeedCredits)"
            itemFeedCreditsLabel.isHidden = false
            itemFeedCreditsLabel.textAlignment = recipe.alignLabel
            itemFeedCreditsLabel.numberOfLines = recipe.maxLines
            
            if let recipeCreditFont = recipe.recipeCreditFont {
                itemFeedCreditsLabel.font = recipeCreditFont
            }
        }
        
        if let imageHeightConstant = recipe.imageHeight {
            self.recipeImageHeightConstraint.constant = imageHeightConstant
//            self.recipeImageHeightConstraint.priority = .required
            self.recipeImageHeightConstraint.isActive = true
           
        } else if let imageEqualToContainerHeight = recipe.imageHeightEqualToContainerMultiplier {
            self.recipeImageHeightConstraint.constant = self.containerView.bounds.height * imageEqualToContainerHeight
//            self.recipeImageHeightConstraint.priority = .required
            self.recipeImageHeightConstraint.isActive = true
            
        } else {
            self.recipeImageHeightConstraint.isActive = false
        }
        
        print("cell height: \(contentView.bounds.height)")
        print("image view height: \(itemImageView.bounds.height)")
    }

    private func showLoadingView() {
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = Constant.loadingColor.cgColor
        
        itemImageView.backgroundColor = Constant.loadingColor
        itemNameLabel.backgroundColor = Constant.loadingColor
        itemFeedCreditsLabel.backgroundColor = Constant.loadingColor
        
        itemNameLabel.text = Constant.placholderText1
        itemFeedCreditsLabel.text = Constant.placholderText2
        
        itemIsLikedButton.isHidden = true
        itemNameLabel.textColor = .clear
        itemFeedCreditsLabel.textColor = .clear
        itemIsLikedButton.tintColor = .clear
        itemIsLikedButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        itemImageView.backgroundColor = .clear
        itemNameLabel.backgroundColor = .clear
        itemFeedCreditsLabel.backgroundColor = .clear
        
        itemNameLabel.textColor = .label
        itemFeedCreditsLabel.textColor = .label
        
        itemIsLikedButton.isHidden = false
        itemIsLikedButton.tintColor = Constant.secondaryColor
        itemIsLikedButton.isUserInteractionEnabled = true
    }
    
    private func isLikedImage(_ isLiked: Bool = false) -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .medium)
        let image = isLiked ? itemIsLikedImage : itemIsNotLikedImage
        
        return image?.withConfiguration(imageConfig)
    }
}

extension RecipeCardCollectionViewCell {
    static func featuredCellSize(availableWidth: CGFloat, screenHeight: CGFloat) -> CGSize {
        var itemHeight: CGFloat = 500
        
        let height = screenHeight * 0.6
        if height <= itemHeight {
            itemHeight = height
        }
        
        return CGSize(width: availableWidth, height: itemHeight)
    }
    
    static func carouselCellSize(availableWidth: CGFloat) -> CGSize {
        let itemHeight: CGFloat = 250
        let suggestedItemWidth: CGFloat = 180
        let minimumCellPerRow = 2
        
        let newAvailableWidth = availableWidth - (suggestedItemWidth * 0.5)
        
        var cellPerRow = Int(ceil(newAvailableWidth / suggestedItemWidth))
        if cellPerRow < minimumCellPerRow {
            cellPerRow = minimumCellPerRow
        }
        
        let widthCell = availableWidth / CGFloat(cellPerRow)
        
        var finalCellWidth = suggestedItemWidth
        if widthCell > suggestedItemWidth {
            let overflow = widthCell - suggestedItemWidth
            
            finalCellWidth = suggestedItemWidth - (overflow * CGFloat(cellPerRow)) - Constant.horizontalSpacing * CGFloat(cellPerRow)
            
        } else if widthCell < suggestedItemWidth {
            let overflow = suggestedItemWidth - widthCell

            finalCellWidth = suggestedItemWidth + (overflow * CGFloat(cellPerRow)) - Constant.horizontalSpacing * (CGFloat(cellPerRow) - 0.5)
        }
        
        return CGSize(width: finalCellWidth, height: itemHeight)
    }
    
    static func recentCellSize(availableWidth: CGFloat) -> CGSize {
        var minColEachRow: CGFloat = 2
        let cellMinWidth: CGFloat = 200
        let idealColEachRow = round(availableWidth / cellMinWidth)
        
        if idealColEachRow > minColEachRow {
            minColEachRow = idealColEachRow
        }
        
        let finalWidth = availableWidth - ((minColEachRow - 1) * Constant.horizontalSpacing)
        
        return CGSize(width: finalWidth / minColEachRow, height: 250)
    }
}
