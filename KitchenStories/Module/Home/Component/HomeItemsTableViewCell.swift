//
//  HomeItemsTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit
import SkeletonView

class HomeItemsTableViewCell: UITableViewCell {
    
    static let identifier = "HomeItemsTableViewCell"
    
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 5
    
    private var feed: FeedModel?
    private var screenSize: CGSize?
    private var cellSize: CGSize = .zero
    private var isLoading: Bool = false
        
    lazy var itemsCollectionView: DynamicHeightCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let itemsCollectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        itemsCollectionView.isSkeletonable = true
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
    
    lazy var itemCollectionViewHeight: NSLayoutConstraint = {
        let itemCollectionViewHeight = itemsCollectionView.heightAnchor.constraint(equalToConstant: 20)
        itemCollectionViewHeight.isActive = true
        return itemCollectionViewHeight
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
        
        setCollectionScrollDirection()
        layoutIfNeeded()
        itemsCollectionView.reloadData()
    }
    
    func setupCell(
        feed: FeedModel,
        screenSize: CGSize,
        isLoading: Bool = false
    ) {
        self.feed = feed
        self.screenSize = screenSize
        self.isLoading = isLoading
        getCellSizeForType(feed.type)
        
        addSubviews()
        setComponentsConstraints()
        setCollectionScrollDirection()
        layoutIfNeeded()
    }
    
    private func setCollectionScrollDirection() {
        guard let layout = itemsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }
        
        if feed?.type == .recent {
            layout.scrollDirection = .vertical
        } else {
            layout.scrollDirection = .horizontal
        }
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
        if feed?.type == .recent {
            itemCollectionViewHeight.isActive = false
            return
        }

        let collectionViewHeight = cellSize.height + (verticalSpacing * 2)
        itemCollectionViewHeight.constant = collectionViewHeight
        itemCollectionViewHeight.isActive = true
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
        if feed?.type == .recent {
            return .zero
        }
        return horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if feed?.type == .recent {
            return horizontalSpacing
        }
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
            
        case .recent:
            var minColEachRow: CGFloat = 2
            let cellMinWidth: CGFloat = 200
            let idealColEachRow = round(availableWidth / cellMinWidth)
            
            if idealColEachRow > minColEachRow {
                minColEachRow = idealColEachRow
            }
            
            let finalWidth = availableWidth - ((minColEachRow - 1) * horizontalSpacing)
            cellSize = CGSize(width: finalWidth / minColEachRow, height: 250)
            
        case .carousel:
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
            
        default:
            cellSize = .zero
        }
    }
}

extension HomeItemsTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        guard let feedType = feed?.type else { return "" }
        
        switch feedType {
        case .featured:
            return FeaturedItemCollectionViewCell.identifier
        case .shoppableCarousel:
            return ShopableItemCollectionViewCell.identifier
        default:
            return CarouselItemCollectionViewCell.identifier
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading == true { return feed?.minItems ?? 0 }
        if feed?.type == .recent {
            return feed?.items?.count ?? 0
        }
        return feed?.showItemsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let feed = feed
        else { return UICollectionViewCell() }
        
        let feedItem: FeedItemModel? = isLoading ? nil : feed.itemList[indexPath.row]
        
        switch feed.type {
        case .shoppableCarousel:
            guard let shopableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopableItemCollectionViewCell.identifier, for: indexPath) as? ShopableItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            shopableCell.setupCell(
                imageUrlString: feedItem?.thumbnailUrlString,
                itemName: feedItem?.name,
                recipesCount: feedItem?.recipes?.count ?? 0
            )
            
            return shopableCell
            
        case .featured:
            guard let featuredCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCollectionViewCell.identifier, for: indexPath) as? FeaturedItemCollectionViewCell
            else { return UICollectionViewCell() }

            featuredCell.setupCell(
                imageUrlString: feedItem?.thumbnailUrlString,
                itemName: feedItem?.name,
                itemFeedCredits: feedItem?.creditsNames
            )
            
            return featuredCell
            
            
        case .carousel, .recent:
            guard let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselItemCollectionViewCell.identifier, for: indexPath) as? CarouselItemCollectionViewCell
            else { return UICollectionViewCell() }
            
            carouselCell.setupCell(
                imageUrlString: feedItem?.thumbnailUrlString,
                itemName: feedItem?.name
            )
            
            return carouselCell
            
        default:
            return UICollectionViewCell()
        }
    }
}
