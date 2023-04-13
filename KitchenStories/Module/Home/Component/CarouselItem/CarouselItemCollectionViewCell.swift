//
//  CarouselItemCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 12/04/23.
//

import UIKit
import SkeletonView

class CarouselItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "CarouselItemCollectionViewCell"
    
    private let itemIsLikedImage = UIImage(systemName: "heart.fill")
    private let itemIsNotLikedImage = UIImage(systemName: "heart")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.isSkeletonable = true
            containerView.layer.cornerRadius = 10
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.isSkeletonable = true
            itemImageView.contentMode = .scaleAspectFill
            itemImageView.layer.cornerRadius = 10
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
            itemNameLabel.isSkeletonable = true
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
