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
    private let recipeCardCellIdentifier = RecipeCardCollectionViewCell.identifier
    private var relatedRecipeMaxCount: Int!
    
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
        maxShown: Int,
        screenSize: CGSize,
        isLoading: Bool
    ) {
        self.screenSize = screenSize
        self.isLoading = isLoading
        self.relatedRecipeMaxCount = maxShown
        if let relatedRecipes = relatedRecipes {
            self.relatedRecipes = relatedRecipes
        }
        
        setupCollectionView()
    }
    
    
    private func setupCollectionView() {
        let carouselRecipeCell = UINib(nibName: recipeCardCellIdentifier, bundle: nil)
        relatedRecipesCollectionView.register(carouselRecipeCell, forCellWithReuseIdentifier: recipeCardCellIdentifier)
        
        self.contentView.addSubview(relatedRecipesCollectionView)
        
        let carouselCellSize = RecipeCardCollectionViewCell.carouselCellSize(availableWidth: screenSize.width)
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
        return RecipeCardCollectionViewCell.carouselCellSize(availableWidth: availableWidth)
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
        guard let recipeCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCardCellIdentifier, for: indexPath) as? RecipeCardCollectionViewCell
        else { return UICollectionViewCell() }
        
        var recipeCardParams: RecipeCardCellParams?
        if let recipeOfIndex = relatedRecipes?.results[indexPath.row] {
            recipeCardParams = RecipeCardCellParams(
                imageUrlString: recipeOfIndex.thumbnailUrlString,
                recipeName: recipeOfIndex.name,
                alignLabel: .center
            )
        }
        
        recipeCardCell.setupCell(recipe: recipeCardParams, isLoading: isLoading)
        
        return recipeCardCell
    }
    
    
}
