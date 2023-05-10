//
//  HomeItemsTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

protocol HomeItemTableCellDelegate {
    func handleFeedItemSelected(recipe: RecipeModel)
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
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        itemsCollectionView.collectionViewLayout = flowLayout
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.showsHorizontalScrollIndicator = false
        
        let recipeCardCell = UINib(nibName: RecipeCardCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(recipeCardCell, forCellWithReuseIdentifier: RecipeCardCollectionViewCell.identifier)
        
        let shopableCell = UINib(nibName: ShopableItemCollectionViewCell.identifier, bundle: nil)
        itemsCollectionView.register(shopableCell, forCellWithReuseIdentifier: ShopableItemCollectionViewCell.identifier)
        
        
        return itemsCollectionView
    }()
    
    var itemCollectionViewHeight: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setComponentsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        itemCollectionViewHeight?.isActive = false
        itemCollectionViewHeight = nil
        
        feed = nil
        cellSize = .zero
        isLoading = true

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
        
        setCollectionScrollDirection()
        setCollectionViewHeightConstraint()
        layoutIfNeeded()
        itemsCollectionView.reloadData()
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
        
        NSLayoutConstraint.activate([
            itemsCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            itemsCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            itemsCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            itemsCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    private func setCollectionViewHeightConstraint() {
        if feed?.type == .recent {
            itemCollectionViewHeight?.isActive = false
            return
        }

        let collectionViewHeight = cellSize.height + (verticalSpacing * 2)
        itemCollectionViewHeight = itemsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
        itemCollectionViewHeight?.isActive = true
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

extension HomeItemsTableViewCell: UICollectionViewDataSource {
    
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
        
        switch feed.type {
        case .featured, .carousel, .recent:
            return recipeCardCell(
                collectionView,
                cellForItemAt: indexPath,
                feedType: feed.type
            )
            
        case .shoppableCarousel:
            return shopableCell(collectionView, cellForItemAt: indexPath)
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isLoading == false,
              let feed = feed
        else { return }
        
        let feedItem = feed.itemList[indexPath.row]
        delegate?.handleFeedItemSelected(recipe: feedItem)
    }
}

extension HomeItemsTableViewCell {
    private func shopableCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let shopableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopableItemCollectionViewCell.identifier, for: indexPath) as? ShopableItemCollectionViewCell
        else { return UICollectionViewCell() }
        
        var shoppableCellParams: ShopableItemCellParams?
        guard isLoading == false,
              let feedItem = feed?.itemList[indexPath.row]
        else {
            shopableCell.setupCell(recipe: shoppableCellParams, isLoading: isLoading)
            return shopableCell
        }
        
        shoppableCellParams = ShopableItemCellParams(
            imageUrlString: feedItem.thumbnailUrlString,
            recipeName: feedItem.name,
            recipesCount: feedItem.recipes?.count ?? 0
        )
        
        shopableCell.setupCell(
            recipe: shoppableCellParams,
            isLoading: isLoading
        )
        
        return shopableCell
    }
    
    private func recipeCardCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath,
        feedType: FeedType
    ) -> UICollectionViewCell {
        guard let recipeCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardCollectionViewCell.identifier, for: indexPath) as? RecipeCardCollectionViewCell
        else { return UICollectionViewCell() }
        
        var recipeCardParams: RecipeCardCellParams?
        guard isLoading == false,
              let feedItem = feed?.itemList[indexPath.row]
        else {
            recipeCardCell.setupCell(recipe: recipeCardParams, isLoading: isLoading)
            return recipeCardCell
        }
        
        switch feedType {
        case .featured:
            recipeCardParams = RecipeCardCellParams(
                imageUrlString: feedItem.thumbnailUrlString,
                recipeName: feedItem.name,
                recipeFeedCredits: feedItem.creditsNames,
                backgroundColor: .blue.withAlphaComponent(0.5),
                recipeNameFont: .boldSystemFont(ofSize: 25),
                maxLines: 0
            )
            
        case .recent, .carousel:
            recipeCardParams = RecipeCardCellParams(
                imageUrlString: feedItem.thumbnailUrlString,
                recipeName: feedItem.name,
                alignLabel: .center
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
