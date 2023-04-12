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
            containerView.layer.cornerRadius = 10
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
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
        imageUrlString: String,
        itemName: String,
        isLiked: Bool = false
    ) {
        itemImageView.loadImageFromUrl(
            imageUrlString,
            defaultImage: nil,
            getImageNetworkService: getNetworkImageService
        )
        
        let isLikedButtonImage = isLiked ? itemIsLikedImage : itemIsNotLikedImage
        itemIsLikedButton.setImage(isLikedButtonImage, for: .normal)
        
        itemNameLabel.text = itemName
    }

}
