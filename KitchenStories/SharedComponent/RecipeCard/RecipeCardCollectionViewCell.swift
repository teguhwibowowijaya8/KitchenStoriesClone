//
//  RecipeCardCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 04/05/23.
//

import UIKit

struct RecipeCardCellParams {
    let imageUrlString: String
    let recipeName: String
    var isLiked: Bool = false
    var recipeFeedCredits: String? = nil
    var backgroundColor: UIColor = .clear
    var alignLabel: NSTextAlignment = .left
    var recipeNameFont: UIFont = .boldSystemFont(ofSize: 15)
    var recipeCreditFont: UIFont = .systemFont(ofSize: 12)
    var maxLines: Int = 3
}

class RecipeCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipeCardCollectionViewCell"
    
    private let recipeIsLikedImage = UIImage(systemName: "heart.fill")
    private let recipeIsNotLikedImage = UIImage(systemName: "heart")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constant.cornerRadius
            containerView.clipsToBounds = true
            containerView.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet var imageContainerView: UIView!
    
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var recipeIsLikedButton: UIButton! {
        didSet {
            recipeIsLikedButton.tintColor = .red.withAlphaComponent(0.5)
            recipeIsLikedButton.setImage(isLikedImage(), for: .normal)
            recipeIsLikedButton.layer.cornerRadius = recipeIsLikedButton.frame.height / 2
            recipeIsLikedButton.backgroundColor = .white
            recipeIsLikedButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var textViewsContainer: UIStackView!
    
    @IBOutlet weak var recipeNameTextView: UITextView! {
        didSet {
            recipeNameTextView.removePadding()
        }
    }
    
    @IBOutlet weak var recipeFeedCreditsTextView: UITextView! {
        didSet {
            recipeFeedCreditsTextView.removePadding()
            recipeFeedCreditsTextView.isHidden = true
        }
    }
    
    @IBOutlet weak var textViewsContainerHeight: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textViewsContainerHeight.constant = 20
        recipeFeedCreditsTextView.isHidden = true
        recipeImageView.image = nil
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
        
        recipeImageView.loadImageFromUrl(
            recipe.imageUrlString,
            defaultImage: nil,
            getImageNetworkService: getNetworkImageService
        )
        
        recipeNameTextView.text = recipe.recipeName
        recipeNameTextView.textAlignment = recipe.alignLabel
        recipeNameTextView.textContainer.maximumNumberOfLines = recipe.maxLines
        recipeNameTextView.font = recipe.recipeNameFont
        
        let isLikedButtonImage = isLikedImage(recipe.isLiked)
        recipeIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        if let recipeFeedCredits = recipe.recipeFeedCredits {
            recipeFeedCreditsTextView.text = "Presented by \(recipeFeedCredits)"
            recipeFeedCreditsTextView.font = recipe.recipeCreditFont
            recipeFeedCreditsTextView.isHidden = false
            recipeFeedCreditsTextView.textAlignment = recipe.alignLabel
            recipeFeedCreditsTextView.textContainer.maximumNumberOfLines = recipe.maxLines
        }
        
        if recipe.maxLines != 0 {
            var textContainerHeight: CGFloat
            
            textContainerHeight = Utilities.getTextViewHeight(
                textSize: recipe.recipeNameFont.pointSize,
                maxLines: recipe.maxLines,
                availableWidth: recipeNameTextView.frame.width
            )
            
            if recipe.recipeFeedCredits != nil {
                textContainerHeight += Utilities.getTextViewHeight(
                    textSize: recipe.recipeCreditFont.pointSize,
                    maxLines: recipe.maxLines,
                    availableWidth: recipeFeedCreditsTextView.frame.width
                )
                textContainerHeight += textViewsContainer.spacing
            }
            
            textViewsContainerHeight.constant = textContainerHeight
        }
    }

    private func showLoadingView() {
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = Constant.loadingColor.cgColor
        
        recipeImageView.backgroundColor = Constant.loadingColor
        recipeNameTextView.backgroundColor = Constant.loadingColor
        recipeFeedCreditsTextView.backgroundColor = Constant.loadingColor
        
        recipeNameTextView.text = Constant.placholderText1
        recipeFeedCreditsTextView.text = Constant.placholderText2
        
        recipeIsLikedButton.isHidden = true
        recipeNameTextView.textColor = .clear
        recipeFeedCreditsTextView.textColor = .clear
        recipeIsLikedButton.tintColor = .clear
        recipeIsLikedButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        recipeImageView.backgroundColor = .clear
        recipeNameTextView.backgroundColor = .clear
        recipeFeedCreditsTextView.backgroundColor = .clear
        
        recipeNameTextView.textColor = .label
        recipeFeedCreditsTextView.textColor = .label
        
        recipeIsLikedButton.isHidden = false
        recipeIsLikedButton.tintColor = Constant.secondaryColor
        recipeIsLikedButton.isUserInteractionEnabled = true
    }
    
    private func isLikedImage(_ isLiked: Bool = false) -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .medium)
        let image = isLiked ? recipeIsLikedImage : recipeIsNotLikedImage
        
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
