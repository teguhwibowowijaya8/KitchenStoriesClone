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
    var recipeCreditFont: UIFont = .systemFont(ofSize: 12)
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
    
    
    @IBOutlet var imageContainerView: UIView!
    
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
    
    @IBOutlet weak var textViewsContainer: UIStackView!
    
    @IBOutlet weak var itemNameLabel: UITextView! {
        didSet {
            itemNameLabel.removePadding()
        }
    }
    
    @IBOutlet weak var itemFeedCreditsLabel: UITextView! {
        didSet {
            itemFeedCreditsLabel.removePadding()
            itemFeedCreditsLabel.isHidden = true
        }
    }
    
    
    @IBOutlet weak var textViewsContainerHeight: NSLayoutConstraint!
    
//    @IBOutlet var recipeImageHeightConstraint: NSLayoutConstraint!
//
//    @IBOutlet weak var recipeImageHeightEqualContainerConstraint: NSLayoutConstraint!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
//        recipeImageHeightConstraint?.isActive = false
//        recipeImageHeightConstraint = nil
        textViewsContainerHeight.constant = 20
        itemFeedCreditsLabel.isHidden = true
        getNetworkImageService.cancel()
        
//        recipeImageHeightConstraint = imageContainerView.heightAnchor.constraint(equalToConstant: containerView.bounds.height * 0.7)
//        recipeImageHeightConstraint?.isActive = false
        
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
        
        itemNameLabel.text = recipe.itemName
        itemNameLabel.textAlignment = recipe.alignLabel
        itemNameLabel.textContainer.maximumNumberOfLines = recipe.maxLines
        itemNameLabel.font = recipe.recipeNameFont
        
        let isLikedButtonImage = isLikedImage(recipe.isLiked)
        itemIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        if let itemFeedCredits = recipe.itemFeedCredits {
            itemFeedCreditsLabel.text = "Presented by \(itemFeedCredits)"
            itemFeedCreditsLabel.font = recipe.recipeCreditFont
            itemFeedCreditsLabel.isHidden = false
            itemFeedCreditsLabel.textAlignment = recipe.alignLabel
            itemFeedCreditsLabel.textContainer.maximumNumberOfLines = recipe.maxLines
        }
        
        if recipe.maxLines != 0 {
            var textContainerHeight: CGFloat
            
            textContainerHeight = getTextHeight(of: recipe.recipeNameFont.pointSize, maxLines: recipe.maxLines, desiredText: recipe.itemName)
            
            if let itemFeedCredits = recipe.itemFeedCredits {
                textContainerHeight += getTextHeight(of: recipe.recipeCreditFont.pointSize, maxLines: recipe.maxLines, desiredText: itemFeedCredits)
                textContainerHeight += textViewsContainer.spacing
            }
            
            textViewsContainerHeight.constant = textContainerHeight
        }
        
//        setImageHeightConstraint(constant: recipe.imageHeight, multiplier: recipe.imageHeightEqualToContainerMultiplier)
    }
    
//    private func setImageHeightConstraint(constant: CGFloat?, multiplier: CGFloat?) {
//
//        if let imageHeightConstant = constant {
//            self.recipeImageHeightConstraint?.constant = imageHeightConstant
//            self.recipeImageHeightConstraint.priority = .required
//
//            self.recipeImageHeightEqualContainerConstraint.priority = .init(999)
//
//        } else if let imageMultiplierToContainer = multiplier {
//            self.recipeImageHeightConstraint?.constant = self.containerView.bounds.height * imageMultiplierToContainer
//            self.recipeImageHeightConstraint.priority = .required
//
//            self.recipeImageHeightEqualContainerConstraint.priority = .init(999)
//
//        } else {
//
//            self.recipeImageHeightEqualContainerConstraint.priority = .init(999)
//            self.recipeImageHeightConstraint.priority = .init(999)
////            self.recipeImageHeightConstraint?.constant = defaultImageHeight
//        }
//    }
    
    private func getTextHeight(of textSize: CGFloat, maxLines: Int, desiredText: String) -> CGFloat {
        let singleLineTextView = UITextView(frame: CGRect(x: 0, y: 0, width: itemNameLabel.frame.width, height: .greatestFiniteMagnitude))
        
        singleLineTextView.isEditable = false
        singleLineTextView.isSelectable = false
        singleLineTextView.isScrollEnabled = false
        singleLineTextView.removePadding()
        
        singleLineTextView.font = itemNameLabel.font
        singleLineTextView.text = "A"
        singleLineTextView.sizeToFit()
        let measuredHeight = singleLineTextView.frame.height

        return measuredHeight * CGFloat(maxLines)
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
        let minimumCellPerRow = 2.5
        
        let idealColumnPerRow = availableWidth / suggestedItemWidth
        
        var cellPerRow = ceil(idealColumnPerRow)
        if cellPerRow < minimumCellPerRow {
            cellPerRow = minimumCellPerRow
        } else {
            cellPerRow = cellPerRow - 0.5
        }
        
        let finalWidth = (availableWidth - ((cellPerRow - 1) * Constant.horizontalSpacing)) / cellPerRow
        
        return CGSize(width: finalWidth, height: itemHeight)
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
