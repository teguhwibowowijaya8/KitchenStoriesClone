//
//  HomeItemsTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit
import SkeletonView

protocol HomeItemTableCellDelegate {
    func handleFeedItemSelected(recipeId: Int, recipeName: String)
}

class HomeItemsTableViewCell: UITableViewCell {
    
    static let identifier = "HomeItemsTableViewCell"
    private let verticalSpacing: CGFloat = 5
    
    private var feed: FeedModel?
    private var screenSize: CGSize?
    private var cellSize: CGSize = .zero
    private var isLoading: Bool = false
    
    var delegate: HomeItemTableCellDelegate?
        
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
        
//        let featuredCell = UINib(nibName: FeaturedItemCollectionViewCell.identifier, bundle: nil)
//        itemsCollectionView.register(featuredCell, forCellWithReuseIdentifier: FeaturedItemCollectionViewCell.identifier)
        
        let recipeCardCell = UINib(nibName: RecipeCardCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(recipeCardCell, forCellWithReuseIdentifier: RecipeCardCollectionViewCell.identifier)
        
        let shopableCell = UINib(nibName: ShopableItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(shopableCell, forCellWithReuseIdentifier: ShopableItemCollectionViewCell.identifier)
        
//        let carouselCell = UINib(nibName: CarouselItemCollectionViewCell.identifier, bundle: nil)
//        itemsCollectionView.register(carouselCell, forCellWithReuseIdentifier: CarouselItemCollectionViewCell.identifier)
        
        return itemsCollectionView
    }()
    
    lazy var itemCollectionViewHeight: NSLayoutConstraint = {
        let itemCollectionViewHeight = itemsCollectionView.heightAnchor.constraint(equalToConstant: 20)
        itemCollectionViewHeight.priority = .init(rawValue: 999)
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
        
        getCellSizeForType()
        setCollectionViewHeightConstraint()
        setCollectionScrollDirection()
        layoutIfNeeded()
        itemsCollectionView.reloadData()
    }
    
    func setupCell(
        feed: FeedModel,
        screenSize: CGSize,
        isLoading: Bool
    ) {
        self.feed = feed
        self.screenSize = screenSize
        self.isLoading = isLoading
        getCellSizeForType()
        
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
            left: Constant.horizontalSpacing,
            bottom: verticalSpacing,
            right: Constant.horizontalSpacing
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if feed?.type == .recent {
            return .zero
        }
        return Constant.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if feed?.type == .recent {
            return Constant.horizontalSpacing
        }
        return .zero
    }
    
    private func getCellSizeForType() {
        guard let feed = feed,
              let screenSize = screenSize
        else { return }
        
        let availableWidth = screenSize.width - (Constant.horizontalSpacing * 2)
        
        switch feed.type {
        case .featured:
            cellSize = RecipeCardCollectionViewCell.featuredCellSize(availableWidth: availableWidth, screenHeight: screenSize.height)
            
        case .shoppableCarousel:
            cellSize = ShopableItemCollectionViewCell.cellSize(availableWidth: availableWidth)
            
        case .recent:
            cellSize = RecipeCardCollectionViewCell.recentCellSize(availableWidth: availableWidth)
            
        case .carousel:
            cellSize = RecipeCardCollectionViewCell.carouselCellSize(availableWidth: availableWidth)
            
        default:
            cellSize = .zero
        }
    }
}

extension HomeItemsTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        guard let feedType = feed?.type else { return "" }
        
        switch feedType {
//        case .featured:
//            return FeaturedItemCollectionViewCell.identifier
        case .shoppableCarousel:
            return ShopableItemCollectionViewCell.identifier
        default:
            return RecipeCardCollectionViewCell.identifier
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
        
        let feedItem: RecipeModel? = isLoading ? nil : feed.itemList[indexPath.row]
        
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
            
        default:
            guard let recipeCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardCollectionViewCell.identifier, for: indexPath) as? RecipeCardCollectionViewCell
            else { return UICollectionViewCell() }
            
            guard let feedItem = feedItem
            else {
                recipeCardCell.setupCell(recipe: nil, isLoading: true)
                return recipeCardCell
            }
            
            var recipeCardParams: RecipeCardCellParams?
            switch feed.type {
            case .featured:
                recipeCardParams = RecipeCardCellParams(
                    imageUrlString: feedItem.thumbnailUrlString,
                    itemName: feedItem.name,
                    itemFeedCredits: feedItem.creditsNames,
                    backgroundColor: .blue.withAlphaComponent(0.5),
                    recipeNameFont: .boldSystemFont(ofSize: 25),
                    maxLines: 0
                )
                
            case .recent, .carousel:
                recipeCardParams = RecipeCardCellParams(
                    imageUrlString: feedItem.thumbnailUrlString,
                    itemName: feedItem.name,
                    alignLabel: .center,
                    imageHeightEqualToContainerMultiplier: 0.7
                )
                
            default:
                return UICollectionViewCell()
            }
            
            recipeCardCell.setupCell(
                recipe: recipeCardParams,
                isLoading: isLoading
            )
            
            return recipeCardCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let feedItem = feed?.itemList[indexPath.row]
        else { return }
        delegate?.handleFeedItemSelected(recipeId: feedItem.id, recipeName: feedItem.name)
    }
}
