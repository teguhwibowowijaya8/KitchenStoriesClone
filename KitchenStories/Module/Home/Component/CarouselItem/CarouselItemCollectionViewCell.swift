//
//  CarouselItemCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 12/04/23.
//

import UIKit

class CarouselItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "CarouselItemCollectionViewCell"
    
    private let itemIsLikedImage = UIImage(systemName: "heart.fill")
    private let itemIsNotLikedImage = UIImage(systemName: "heart")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constant.cornerRadius
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.contentMode = .scaleAspectFill
            itemImageView.layer.cornerRadius = Constant.cornerRadius
        }
    }
    
    @IBOutlet weak var itemIsLikedButton: UIButton! {
        didSet {
            itemIsLikedButton.tintColor = .red.withAlphaComponent(0.5)
            itemIsLikedButton.setImage(itemIsNotLikedImage, for: .normal)
            itemIsLikedButton.layer.cornerRadius = itemIsLikedButton.frame.height / 2
            itemIsLikedButton.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.numberOfLines = 0
            itemNameLabel.textAlignment = .center
            itemNameLabel.font = .boldSystemFont(ofSize: 15)
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
        isLiked: Bool = false
    ) {
        guard let imageUrlString = imageUrlString,
              let itemName = itemName
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        itemImageView.loadImageFromUrl(
            imageUrlString,
            defaultImage: nil,
            getImageNetworkService: getNetworkImageService
        )
        
        let isLikedButtonImage = isLiked ? itemIsLikedImage : itemIsNotLikedImage
        itemIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        itemNameLabel.text = itemName
    }

    private func showLoadingView() {
        itemImageView.backgroundColor = Constant.loadingColor
        itemNameLabel.backgroundColor = Constant.loadingColor
        itemIsLikedButton.backgroundColor = .clear
        
        itemNameLabel.text = Constant.placholderText1
        
        itemNameLabel.textColor = .clear
        itemIsLikedButton.tintColor = .clear
        itemIsLikedButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        itemImageView.backgroundColor = .clear
        itemNameLabel.backgroundColor = .clear
        itemIsLikedButton.backgroundColor = .white
        
        itemNameLabel.textColor = .label
        itemIsLikedButton.tintColor = Constant.secondaryColor
        itemIsLikedButton.isUserInteractionEnabled = true
    }
}

extension CarouselItemCollectionViewCell {
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
