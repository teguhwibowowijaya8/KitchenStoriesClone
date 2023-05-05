//
//  FeaturedItemCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

class FeaturedItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedItemCollectionViewCell"
    
    private let itemIsLikedImage = UIImage(systemName: "heart.fill")
    private let itemIsNotLikedImage = UIImage(systemName: "heart")
    
    private var getNetworkImageService = GetNetworkImageService()
    private let containerBackgroundColor: UIColor = .blue.withAlphaComponent(0.5)
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constant.cornerRadius
            containerView.clipsToBounds = true
            containerView.backgroundColor = containerBackgroundColor
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
            itemNameLabel.font = .boldSystemFont(ofSize: 25)
        }
    }
    
    @IBOutlet weak var itemFeedCreditsLabel: UILabel! {
        didSet {
            itemFeedCreditsLabel.font = .systemFont(ofSize: 12)
            itemFeedCreditsLabel.numberOfLines = 0
            itemFeedCreditsLabel.isHidden = true
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
        isLiked: Bool = false,
        itemFeedCredits: String?
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
        
        itemNameLabel.text = itemName
        
        let isLikedButtonImage = isLikedImage(isLiked)
        itemIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        if let itemFeedCredits = itemFeedCredits {
            itemFeedCreditsLabel.text = "Created by \(itemFeedCredits)"
            itemFeedCreditsLabel.isHidden = false
        }
    }

    private func showLoadingView() {
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = Constant.loadingColor.cgColor
        
        itemImageView.backgroundColor = Constant.loadingColor
        itemNameLabel.backgroundColor = Constant.loadingColor
        itemFeedCreditsLabel.backgroundColor = Constant.loadingColor
        itemIsLikedButton.backgroundColor = .clear
        
        itemNameLabel.text = Constant.placholderText1
        itemFeedCreditsLabel.text = Constant.placholderText2
        
        itemNameLabel.textColor = .clear
        itemFeedCreditsLabel.textColor = .clear
        itemIsLikedButton.tintColor = .clear
        itemIsLikedButton.isUserInteractionEnabled = false
    }
    
    private func removeLoadingView() {
        containerView.backgroundColor = containerBackgroundColor
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        itemImageView.backgroundColor = .clear
        itemNameLabel.backgroundColor = .clear
        itemFeedCreditsLabel.backgroundColor = .clear
        itemIsLikedButton.backgroundColor = .white
        
        itemNameLabel.textColor = .label
        itemFeedCreditsLabel.textColor = .label
        
        itemIsLikedButton.tintColor = Constant.secondaryColor
        itemIsLikedButton.isUserInteractionEnabled = true
    }
    
    private func isLikedImage(_ isLiked: Bool = false) -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .medium)
        let image = isLiked ? itemIsLikedImage : itemIsNotLikedImage
        
        return image?.withConfiguration(imageConfig)
    }
}

extension FeaturedItemCollectionViewCell {
    static func cellSize(availableWidth: CGFloat, screenHeight: CGFloat) -> CGSize {
        var itemHeight: CGFloat = 500
        
        let height = screenHeight * 0.6
        if height <= itemHeight {
            itemHeight = height
        }
        
        return CGSize(width: availableWidth, height: itemHeight)
    }
}
