//
//  HomeItemsTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

class HomeItemsTableViewCell: UITableViewCell {
    
    static let identifier = "HomeItemsTableViewCell"
    
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 5
    
    private var feed: FeedModel?
    private var screenSize: CGSize?
    private var cellSize: CGSize = .zero
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var itemsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        itemsCollectionView.collectionViewLayout = flowLayout
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.showsHorizontalScrollIndicator = false
        
        let featuredCell = UINib(nibName: FeaturedItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(featuredCell, forCellWithReuseIdentifier: FeaturedItemCollectionViewCell.identifier)
        
        let shopableCell = UINib(nibName: ShopableItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(shopableCell, forCellWithReuseIdentifier: ShopableItemCollectionViewCell.identifier)
        
        let carouselCell = UINib(nibName: CarouselItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(carouselCell, forCellWithReuseIdentifier: CarouselItemCollectionViewCell.identifier)
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let type = feed?.type {
            getCellSizeForType(type)
            setCollectionViewHeightConstraint()
        }
        itemsCollectionView.reloadData()
    }
    
    func setupCell(feed: FeedModel, screenSize: CGSize) {
        self.feed = feed
        self.screenSize = screenSize
        getCellSizeForType(feed.type)
        
        addSubviews()
        setComponentsConstraints()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(itemsCollectionView)
    }
    
    private func setComponentsConstraints() {
        setCollectionViewHeightConstraint()
        
        NSLayoutConstraint.activate([
            itemsCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            itemsCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            itemsCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            itemsCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    private func setCollectionViewHeightConstraint() {
        let collectionViewHeight = cellSize.height + (verticalSpacing * 2)
        collectionViewHeightConstraint?.isActive = false
        collectionViewHeightConstraint = itemsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
        collectionViewHeightConstraint?.isActive = true
    }
}

extension HomeItemsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: verticalSpacing,
            left: horizontalSpacing,
            bottom: verticalSpacing,
            right: horizontalSpacing
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    private func getCellSizeForType(_ type: FeedType) {
        guard let feed = feed,
              let screenSize = screenSize
        else { return }
        
        let availableWidth = screenSize.width - (horizontalSpacing * 2)
        
        switch feed.type {
        case .featured:
            var itemHeight: CGFloat = 500
            
            let height = screenSize.height * 0.6
            if height <= itemHeight {
                itemHeight = height
            }
            
            cellSize = CGSize(width: availableWidth, height: itemHeight)
            
        case .shoppableCarousel:
            let itemHeight: CGFloat = 145
            let itemWidth = availableWidth * 0.7
            cellSize = CGSize(width: itemWidth, height: itemHeight)
            
        case .carousel, .item:
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
                
                finalCellWidth = suggestedItemWidth - (overflow * CGFloat(cellPerRow)) - horizontalSpacing * CGFloat(cellPerRow)
                
            } else if widthCell < suggestedItemWidth {
                let overflow = suggestedItemWidth - widthCell

                finalCellWidth = suggestedItemWidth + (overflow * CGFloat(cellPerRow)) - horizontalSpacing * (CGFloat(cellPerRow) - 0.5)
            }
            
            cellSize = CGSize(width: finalCellWidth, height: itemHeight)
        }
    }
}

extension HomeItemsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed?.showItemsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let feed = feed
        else { return UICollectionViewCell() }
        
        let feedItem = feed.itemList[indexPath.row]
        
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
            
        case .featured:
            guard let featuredCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCollectionViewCell.identifier, for: indexPath) as? FeaturedItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            featuredCell.setupCell(
                imageUrlString: feedItem.thumbnailUrlString,
                itemName: feedItem.name
            )
            
            return featuredCell
            
            
        case .carousel, .item:
            guard let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselItemCollectionViewCell.identifier, for: indexPath) as? CarouselItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            carouselCell.setupCell(
                imageUrlString: feedItem.thumbnailUrlString,
                itemName: feedItem.name
            )
            
            return carouselCell
            
        }
    }
}
