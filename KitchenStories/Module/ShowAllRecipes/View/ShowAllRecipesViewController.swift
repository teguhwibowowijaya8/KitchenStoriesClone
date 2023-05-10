//
//  ShowAllRecipesViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

enum ShowAllRecipesType {
    case canFetchMore
    case withoutFetchMore
}

class ShowAllRecipesViewController: UIViewController {
    
    let showAllRecipesType: ShowAllRecipesType
    let recipes: [RecipeModel]
    let startRecentFeedFrom: Int?
    
    private let recipeCardCellIdentifier = RecipeCardCollectionViewCell.identifier
    
    private var showAllFeedRecipesViewModel: ShowAllRecipesViewModel!
    
    private lazy var showAllRecipesCollectionView: UICollectionView = {
        let showAllRecipesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        showAllRecipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return showAllRecipesCollectionView
    }()
    
    init(showAllRecipesType: ShowAllRecipesType, recipes: [RecipeModel], startRecentFeedFrom: Int? = nil) {
        self.showAllRecipesType = showAllRecipesType
        self.recipes = recipes
        self.startRecentFeedFrom = startRecentFeedFrom
        
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
        setComponentsConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViewModel() {
        showAllFeedRecipesViewModel = ShowAllRecipesViewModel(
            showAllRecipesType: showAllRecipesType,
            recipes: recipes,
            startGetRecentFrom: startRecentFeedFrom
        )
        showAllFeedRecipesViewModel.delegate = self
    }
    
    private func setupCollectionView() {
        if let flowLayout = showAllRecipesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
        
        let recipeCardCell = UINib(nibName: recipeCardCellIdentifier, bundle: nil)
        showAllRecipesCollectionView.register(recipeCardCell, forCellWithReuseIdentifier: recipeCardCellIdentifier)
        
        showAllRecipesCollectionView.delegate = self
        showAllRecipesCollectionView.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(showAllRecipesCollectionView)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            showAllRecipesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showAllRecipesCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            showAllRecipesCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            showAllRecipesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

extension ShowAllRecipesViewController: ShowAllFeedRecipesViewModelDelegate {
    func handleOnGetRecentFeedCompleted() {
        if let errorMessage = showAllFeedRecipesViewModel.errorMessage {
            print(errorMessage)
            let fromCount = showAllFeedRecipesViewModel.oldRecipesCount
            let toCount = (fromCount-1) + showAllFeedRecipesViewModel.sizeEachFetch
            let loadingIndexPaths = (fromCount..<toCount).map { return IndexPath(item: $0, section: 0) }
            
            DispatchQueue.main.async { [weak self] in
                self?.showAllRecipesCollectionView.performBatchUpdates({
                    self?.showAllRecipesCollectionView.deleteItems(at: loadingIndexPaths)
                })
            }
        } else {
            let newIndexPaths = (showAllFeedRecipesViewModel.oldRecipesCount..<showAllFeedRecipesViewModel.recipes.count).map {
                return IndexPath(item: $0, section: 0)
            }
            DispatchQueue.main.async { [weak self] in
                self?.showAllRecipesCollectionView.performBatchUpdates({
                    self?.showAllRecipesCollectionView.insertItems(at: newIndexPaths)
                })
            }
        }
    }
}

extension ShowAllRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = Constant.horizontalSpacing
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let availableWidth = screenWidth - (Constant.horizontalSpacing * 2)
        return RecipeCardCollectionViewCell.recentCellSize(availableWidth: availableWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.horizontalSpacing
    }
}

extension ShowAllRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let recipesCount = showAllFeedRecipesViewModel.recipes.count
        return showAllFeedRecipesViewModel.isLoading ?
            recipesCount + showAllFeedRecipesViewModel.sizeEachFetch :
            recipesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCardCellIdentifier, for: indexPath) as? RecipeCardCollectionViewCell
        else { return UICollectionViewCell() }
        
        let recipes = showAllFeedRecipesViewModel.recipes
        var recipeParams: RecipeCardCellParams? = nil
        var isLoading = showAllFeedRecipesViewModel.isLoading
        if indexPath.row < recipes.count {
            let recipeOfIndex = recipes[indexPath.row]
            recipeParams = RecipeCardCellParams(
                imageUrlString: recipeOfIndex.thumbnailUrlString,
                recipeName: recipeOfIndex.name,
                alignLabel: .center
            )
            isLoading = false
        }
        
        recipeCardCell.setupCell(recipe: recipeParams, isLoading: isLoading)
        
        return recipeCardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if showAllRecipesType == .canFetchMore &&
            showAllFeedRecipesViewModel.isLoading == false &&
            indexPath.row == showAllFeedRecipesViewModel.recipes.count - 1 {
            showAllFeedRecipesViewModel.getRecentFeeds()
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard showAllFeedRecipesViewModel.isLoading == false,
              indexPath.row < showAllFeedRecipesViewModel.recipes.count
        else { return }
        
        let selectedRecipe = showAllFeedRecipesViewModel.recipes[indexPath.row]
        let recipeDetailVc = Utilities.recipeDetailController(recipe: selectedRecipe)
        
        navigationController?.pushViewController(recipeDetailVc, animated: true)
    }
    
}
