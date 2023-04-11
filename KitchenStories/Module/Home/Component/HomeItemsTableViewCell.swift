//
//  HomeItemsTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

class HomeItemsTableViewCell: UITableViewCell {
    
    static let identifier = "HomeItemsTableViewCell"
    
    private let spacing: CGFloat = 10
    
    private var feed: FeedModel?
    private var screenHeight: CGFloat?
    private var feedItems: [FeedItemModel]?
    
    private lazy var itemsCollectionView: UICollectionView = {
       let itemsCollectionView = UICollectionView()
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        itemsCollectionView.collectionViewLayout = flowLayout
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        let featuredCell = UINib(nibName: FeaturedItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(featuredCell, forCellWithReuseIdentifier: FeaturedItemCollectionViewCell.identifier)
        
        let shopableCell = UINib(nibName: ShopableItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(shopableCell, forCellWithReuseIdentifier: ShopableItemCollectionViewCell.identifier)
        
        return itemsCollectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(feed: FeedModel, screenHeight: CGFloat) {
        self.feed = feed
        self.screenHeight = screenHeight
        
        if let items = feed.items {
            feedItems = items
        } else if let item = feed.item {
            feedItems = [item]
        }
    }

}

extension HomeItemsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feed = feed,
            let screenHeight = screenHeight
        else { return .zero }
        let availableWidth = collectionView.frame.width - (spacing * 2)
        
        switch feed.type {
        case .featured:
            var itemHeight: CGFloat = 500
            
            let height = screenHeight * 0.6
            if height <= itemHeight {
                itemHeight = height
            }
            
            return CGSize(width: availableWidth, height: itemHeight)
            
        case .shoppableCarousel:
            let itemHeight: CGFloat = 200
            let itemWidth = availableWidth * 0.7
            return CGSize(width: itemWidth, height: itemHeight)
            
        case .carousel, .item:
            let itemHeight: CGFloat = 200
            let suggestedItemWidth: CGFloat = 150
            let minimumCellPerRow = 2
            
            let newAvailableWidth = availableWidth - (suggestedItemWidth * 0.5)
            
            var cellPerRow = Int(round(newAvailableWidth / suggestedItemWidth))
            if cellPerRow < minimumCellPerRow {
                cellPerRow = minimumCellPerRow
            }
            
            let widthCell = availableWidth / CGFloat(cellPerRow)
            
            var finalCellWidth = suggestedItemWidth
            if widthCell > suggestedItemWidth {
                let overflow = widthCell - suggestedItemWidth
                finalCellWidth = suggestedItemWidth + (overflow / CGFloat(cellPerRow))
            } else if widthCell < suggestedItemWidth {
                let overflow = suggestedItemWidth - widthCell
                finalCellWidth = suggestedItemWidth - (overflow / CGFloat(cellPerRow))
            }
            
            return CGSize(width: finalCellWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

extension HomeItemsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = feed?.items {
            let minItems = feed?.minItems ?? 6
            let itemsCount = items.count
            if itemsCount < minItems { return items.count }
            else { return minItems }
        }
        
        return feed?.item == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let feed = feed,
              let feedItems = feedItems
        else { return UICollectionViewCell() }
        
        let feedItem = feedItems[indexPath.row]
        
        switch feed.type {
        case .shoppableCarousel:
            guard let shopableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopableItemCollectionViewCell.identifier, for: indexPath) as? ShopableItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            shopableCell.setupCell(
                imageUrlString: feedItem.thumbnailUrlString,
                itemName: feedItem.name,
                recipesCount: 5
            )
            
            return shopableCell
            
        default:
            guard let featuredCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCollectionViewCell.identifier, for: indexPath) as? FeaturedItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            featuredCell.setupCell(
                imageUrlString: feedItem.thumbnailUrlString,
                itemName: feedItem.name,
                isFeaturedItem: feed.type == .featured
            )
            
            return featuredCell
            
        }
    }
}
