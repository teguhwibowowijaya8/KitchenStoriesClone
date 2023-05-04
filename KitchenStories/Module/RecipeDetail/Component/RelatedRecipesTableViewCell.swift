//
//  RelatedRecipesTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 30/04/23.
//

import UIKit

class RelatedRecipesTableViewCell: UITableViewCell {
    static let identifier = "RelatedRecipesTableViewCell"
    
    private let verticalSpacing: CGFloat = 10
    private let carouselRecipeCellIdentifier = CarouselItemCollectionViewCell.identifier
    private let relatedRecipeMaxCount = 5
    
    private var screenSize: CGSize!
    private var isLoading: Bool!
    private var relatedRecipes: RelatedRecipesModel?
    
    private lazy var relatedRecipesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let relatedRecipesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        relatedRecipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        relatedRecipesCollectionView.delegate = self
        relatedRecipesCollectionView.dataSource = self
        
        return relatedRecipesCollectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell(
        relatedRecipes: RelatedRecipesModel?,
        screenSize: CGSize,
        isLoading: Bool
    ) {
        self.screenSize = screenSize
        self.isLoading = isLoading
        if let relatedRecipes = relatedRecipes {
            self.relatedRecipes = relatedRecipes
        }
        
        setupCollectionView()
    }
    
    
    private func setupCollectionView() {
        let carouselRecipeCell = UINib(nibName: carouselRecipeCellIdentifier, bundle: nil)
        relatedRecipesCollectionView.register(carouselRecipeCell, forCellWithReuseIdentifier: carouselRecipeCellIdentifier)
        
        self.contentView.addSubview(relatedRecipesCollectionView)
        
        let carouselCellSize = CarouselItemCollectionViewCell.carouselCellSize(availableWidth: screenSize.width)
        let collectionCellHeight = carouselCellSize.height + (verticalSpacing * 2)
        NSLayoutConstraint.activate([
            relatedRecipesCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            relatedRecipesCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            relatedRecipesCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            relatedRecipesCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            relatedRecipesCollectionView.heightAnchor.constraint(equalToConstant: collectionCellHeight)
        ])
    }
}

extension RelatedRecipesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: verticalSpacing,
            left: Constant.horizontalSpacing,
            bottom: verticalSpacing,
            right: Constant.verticalSpacing
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = screenSize.width - (Constant.horizontalSpacing * 2)
        return CarouselItemCollectionViewCell.carouselCellSize(availableWidth: availableWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension RelatedRecipesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let relatedRecipes = relatedRecipes {
            let relatedRecipesCount = relatedRecipes.results.count
            return relatedRecipesCount > relatedRecipeMaxCount ? relatedRecipeMaxCount : relatedRecipesCount
        }
        return relatedRecipeMaxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let carouselRecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselRecipeCellIdentifier, for: indexPath) as? CarouselItemCollectionViewCell
        else { return UICollectionViewCell() }
        
        var relatedRecipeOfIndex: RecipeModel? = nil
        if let relatedRecipes = relatedRecipes?.results {
            relatedRecipeOfIndex = relatedRecipes[indexPath.row]
        }
        
        carouselRecipeCell.setupCell(
            imageUrlString: relatedRecipeOfIndex?.thumbnailUrlString,
            itemName: relatedRecipeOfIndex?.name
        )
        
        return carouselRecipeCell
    }
    
    
}
