//
//  RecipesOfRecipeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import UIKit

enum RecipesOfRecipeSection {
    /// The recipe that has many recipes inside it
    case recipesFromRecipeOf
    /// List of recipes that the recipe has
    case recipesOfRecipe
}

class RecipesOfRecipeViewController: UIViewController {
    
    /// the first index of this property is the recipe that has many recipes.
    var recipes: [RecipeModel]
    
    private var recipesOfRecipeViewModel: RecipesOfRecipeViewModel!
    
    private lazy var recipesOfRecipeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let recipesOfRecipeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        recipesOfRecipeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return recipesOfRecipeCollectionView
    }()
    
    init(recipes: [RecipeModel]) {
        self.recipes = recipes
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViewModel()
        setupCollectionView()
        addSubviews()
        setComponentConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupViewModel() {
        recipesOfRecipeViewModel = RecipesOfRecipeViewModel()
    }
    
    private func setupCollectionView() {
        recipesOfRecipeCollectionView.delegate = self
        recipesOfRecipeCollectionView.dataSource = self
        
        recipesOfRecipeCollectionView.register(RecipesFromRecipeOfCollectionViewCell.self, forCellWithReuseIdentifier: RecipesFromRecipeOfCollectionViewCell.identifier)
        
        let recipeCardCell = UINib(nibName: RecipeCardCollectionViewCell.identifier, bundle: nil)
        recipesOfRecipeCollectionView.register(recipeCardCell, forCellWithReuseIdentifier: RecipeCardCollectionViewCell.identifier)
        
        recipesOfRecipeCollectionView.register(RecipesTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipesTitleCollectionReusableView.identifier)
    }
    
    private func addSubviews() {
        view.addSubview(recipesOfRecipeCollectionView)
    }
    
    private func setComponentConstraints() {
        NSLayoutConstraint.activate([
            recipesOfRecipeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipesOfRecipeCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            recipesOfRecipeCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            recipesOfRecipeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RecipesOfRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch recipesOfRecipeViewModel.compositions[section] {
        case .recipesFromRecipeOf:
            return UIEdgeInsets(
                top: 15,
                left: Constant.horizontalSpacing,
                bottom: 10,
                right: Constant.horizontalSpacing
            )
            
        case .recipesOfRecipe:
            return UIEdgeInsets(
                top: 10,
                left: Constant.horizontalSpacing,
                bottom: 15,
                right: Constant.horizontalSpacing
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width
        switch recipesOfRecipeViewModel.compositions[indexPath.section] {
        case .recipesFromRecipeOf:
            let recipeParams: RecipesFromRecipeOfCellParams
            if recipesOfRecipeViewModel.isLoading == false,
               let recipe = recipes.first {
                recipeParams = RecipesFromRecipeOfCellParams(
                    name: recipe.name,
                    imageUrlString: recipe.thumbnailUrlString,
                    description: recipe.cleanDescription)
            } else {
                recipeParams = recipesOfRecipeViewModel.dummyRecipeParams
            }
            
            let height = RecipesFromRecipeOfCollectionViewCell.getRecipeCardEstimatedHeight(with: recipeParams, screenWidth: screenWidth)
            
            return CGSize(width: screenWidth, height: height)
            
        case .recipesOfRecipe:
            let availableWidth = screenWidth - (Constant.horizontalSpacing * 2)
            return RecipeCardCollectionViewCell.recentCellSize(availableWidth: availableWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.horizontalSpacing
    }
}

extension RecipesOfRecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recipesOfRecipeViewModel.compositions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch recipesOfRecipeViewModel.compositions[section] {
        case .recipesFromRecipeOf:
            return 1
        case .recipesOfRecipe:
            return recipes.count - 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch recipesOfRecipeViewModel.compositions[indexPath.section] {
        case .recipesFromRecipeOf:
            return recipesFromRecipeOfCell(collectionView, cellForItemAt: indexPath)
            
        case .recipesOfRecipe:
            return recipesOfRecipeCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if recipesOfRecipeViewModel.isLoading == false,
           recipesOfRecipeViewModel.compositions[indexPath.section] == .recipesOfRecipe,
           indexPath.row <= recipes.count {
            
            let recipe = recipes[indexPath.row + 1]
            let recipeDetailVc = Utilities.recipeDetailController(recipe: recipe)
            
            self.navigationController?.pushViewController(recipeDetailVc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if recipesOfRecipeViewModel.compositions[indexPath.section] == .recipesOfRecipe,
               let recipesHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipesTitleCollectionReusableView.identifier, for: indexPath) as? RecipesTitleCollectionReusableView {
                
                recipesHeader.setTitle("Recipes inside:")
                return recipesHeader
                
            } else {
                return UICollectionReusableView()
            }
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section != 1 { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

extension RecipesOfRecipeViewController {
    func recipesFromRecipeOfCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipesFromRecipeOfCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesFromRecipeOfCollectionViewCell.identifier, for: indexPath) as? RecipesFromRecipeOfCollectionViewCell
        else { return UICollectionViewCell() }
        
        var recipesFromRecipeOfParams: RecipesFromRecipeOfCellParams?
        if recipesOfRecipeViewModel.isLoading == false,
           let recipe = recipes.first {
            recipesFromRecipeOfParams = RecipesFromRecipeOfCellParams(
                name: recipe.name,
                imageUrlString: recipe.thumbnailUrlString,
                description: recipe.cleanDescription
            )
        }
        
        recipesFromRecipeOfCell.setupCell(
            recipe: recipesFromRecipeOfParams,
            isLoading: recipesOfRecipeViewModel.isLoading
        )
        
        return recipesFromRecipeOfCell
    }
    
    func recipesOfRecipeCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardCollectionViewCell.identifier, for: indexPath) as? RecipeCardCollectionViewCell
        else { return UICollectionViewCell() }
        
        var recipeCardParams: RecipeCardCellParams?
        if recipesOfRecipeViewModel.isLoading == false,
           indexPath.row <= recipes.count {
            let recipe = recipes[indexPath.row + 1]
            recipeCardParams = RecipeCardCellParams(
                imageUrlString: recipe.thumbnailUrlString,
                recipeName: recipe.name,
                alignLabel: .center
            )
        }
        
        recipeCardCell.setupCell(recipe: recipeCardParams, isLoading: recipesOfRecipeViewModel.isLoading)
        
        return recipeCardCell
    }
}
