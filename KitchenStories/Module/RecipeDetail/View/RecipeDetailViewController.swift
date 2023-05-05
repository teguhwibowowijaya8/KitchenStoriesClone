//
//  FeedDetailViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 13/04/23.
//

import UIKit

enum RecipeDetailSection: Int {
    case header
    case ingredientServing
    case ingredientsHeader
    case ingredientsBody
    case nutritionsInfoHeader
    case nutritionsBody
    case addToGrocery
    case topTip
    case relatedRecipesHeader
    case relatedRecipesBody
    case preparationsHeader
    case preparationsBody
}

class RecipeDetailViewController: UIViewController {
    
    var recipeId: Int!
    
    private var recipeDetailViewModel: RecipeDetailViewModel!
    private var preparationCellBackgroundColor: UIColor = .gray.withAlphaComponent(0.3)

    
    private lazy var recipeDetailTableView: UITableView = {
        let recipeDetailTableView = UITableView()
        recipeDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return recipeDetailTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupViewModel() {
        recipeDetailViewModel = RecipeDetailViewModel(recipeId: recipeId)
        recipeDetailViewModel.delegate = self
        recipeDetailViewModel.getDetail()
    }
    
    private func setupTableView() {
        
        self.view.addSubview(recipeDetailTableView)
        
        NSLayoutConstraint.activate([
            recipeDetailTableView.topAnchor.constraint(equalTo: view.topAnchor),
            recipeDetailTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipeDetailTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            recipeDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        recipeDetailTableView.delegate = self
        recipeDetailTableView.dataSource = self
        recipeDetailTableView.separatorStyle = .none
        
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        let detailHeaderNib = UINib(nibName: DetailHeaderTableViewCell.identifier, bundle: nil)
        recipeDetailTableView.register(detailHeaderNib, forCellReuseIdentifier: DetailHeaderTableViewCell.identifier)
        
        recipeDetailTableView.register(HeaderTitleTableViewCell.self, forCellReuseIdentifier: HeaderTitleTableViewCell.identifier)
        
        recipeDetailTableView.register(ServingsCountTableViewCell.self, forCellReuseIdentifier: ServingsCountTableViewCell.identifier)
        recipeDetailTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.identifier)
        recipeDetailTableView.register(NutritionInfoHeaderTableViewCell.self, forCellReuseIdentifier: NutritionInfoHeaderTableViewCell.identifier)
        recipeDetailTableView.register(AddToGroceryBagTableViewCell.self, forCellReuseIdentifier: AddToGroceryBagTableViewCell.identifier)
        
        let recipeTipNib = UINib(nibName: RecipeTipTableViewCell.identifier, bundle: nil)
        recipeDetailTableView.register(recipeTipNib, forCellReuseIdentifier: RecipeTipTableViewCell.identifier)
        
        recipeDetailTableView.register(RelatedRecipesTableViewCell.self, forCellReuseIdentifier: RelatedRecipesTableViewCell.identifier)
        recipeDetailTableView.register(RecipePreparationTableViewCell.self, forCellReuseIdentifier: RecipePreparationTableViewCell.identifier)
        
    }
}

extension RecipeDetailViewController: RecipeDetailViewModelDelegate {
    func handleOnDetailsFetchCompleted() {
        if let recipeDetailError = recipeDetailViewModel.recipeDetailErrorMessage {
            print(recipeDetailError)
        } else {
            DispatchQueue.main.async {
                self.recipeDetailTableView.reloadData()
            }
        }
    }
    
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipeDetailViewModel.detailsSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch recipeDetailViewModel.detailsSection[section] {
        case .ingredientsBody:
            if let recipeDetail = recipeDetailViewModel.recipeDetail,
               let ingredientSections = recipeDetail.ingredientSections,
                let ingredientBodySection = recipeDetailViewModel.ingredientBodySectionIndexes[section] {
                return ingredientSections[ingredientBodySection].components.count
            } else if recipeDetailViewModel.isLoading {
                return recipeDetailViewModel.maxRelatedRecipesShown
            }
            return 0
            
        case .nutritionsBody:
            if recipeDetailViewModel.isLoading || recipeDetailViewModel.showNutritionInfo == false {
                return 0
            }
            return recipeDetailViewModel.recipeDetail?.nutrition?.nutritions.count ?? 0
            
        case .preparationsBody:
            return recipeDetailViewModel.isLoading ? 5 : recipeDetailViewModel.recipeDetail?.instructions?.count ?? 0
            
        default:
            if recipeDetailViewModel.isLoading || recipeDetailViewModel.recipeDetail != nil {
                return 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch recipeDetailViewModel.detailsSection[indexPath.section] {
            
        case .header:
            return headerCell(of: tableView, cellForRowAt: indexPath)
            
        case .ingredientServing:
            return ingredientsServingCell(of: tableView, cellForRowAt: indexPath)
            
        case .ingredientsHeader, .relatedRecipesHeader, .preparationsHeader:
            return headerTitleCell(of: tableView, cellForRowAt: indexPath, section: recipeDetailViewModel.detailsSection[indexPath.section])
            
        case .ingredientsBody:
            return ingredientsBodyCell(of: tableView, cellForRowAt: indexPath)
            
        case .nutritionsInfoHeader:
            return nutritionInfoHeaderCell(of: tableView, cellForRowAt: indexPath)
            
        case .nutritionsBody:
            return nutritionBodyCell(of: tableView, cellForRowAt: indexPath)
            
        case .addToGrocery:
            return addToGroceryBagCell(of: tableView, cellForRowAt: indexPath)
            
        case .topTip:
            return recipeTipCell(of: tableView, cellForRowAt: indexPath)
            
        case .relatedRecipesBody:
            return relatedRecipesCell(of: tableView, cellForRowAt: indexPath)
            
        case .preparationsBody:
            return recipePreparationCell(of: tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: Recipe Detail Cells
extension RecipeDetailViewController {
    private func headerCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderTableViewCell.identifier, for: indexPath) as? DetailHeaderTableViewCell
        else { return UITableViewCell() }
        
        var headerDetail: DetailHeaderParams? = nil
        
        if let recipeDetail = recipeDetailViewModel.recipeDetail {
            headerDetail = DetailHeaderParams(
                recipeName: recipeDetail.name,
                recipeImageUrlString: recipeDetail.thumbnailUrlString,
                recipeDescription: recipeDetail.description,
                isCommunityRecipe: recipeDetail.isCommunityMemberRecipe,
                communityMemberName: recipeDetail.creditsNames,
                wouldMakeAgainPercentage: recipeDetail.userRatings?.percentage
            )
        }
        
        headerCell.setupCell(detail: headerDetail, isLoading: recipeDetailViewModel.isLoading)
        
        return headerCell
    }
    
    private func headerTitleCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath, section: RecipeDetailSection?) -> UITableViewCell {
        guard let headerTitleCell = tableView.dequeueReusableCell(withIdentifier: HeaderTitleTableViewCell.identifier, for: indexPath) as? HeaderTitleTableViewCell
        else { return UITableViewCell() }
        
        headerTitleCell.backgroundColor = .clear
        
        var showSeeAllButton: Bool = false
        var title: String = "Title"
        
        switch section {
        case .relatedRecipesHeader:
            title = "Related Recipes"
            if let relatedRecipes = recipeDetailViewModel.relatedRecipes,
               relatedRecipes.count > recipeDetailViewModel.maxRelatedRecipesShown {
                showSeeAllButton = true
            }
            
        case .preparationsHeader:
            title = "Preparation"
            headerTitleCell.backgroundColor = preparationCellBackgroundColor
            
        case .ingredientsHeader:
            if let recipeDetail = recipeDetailViewModel.recipeDetail,
               let recipeHeaderSection = recipeDetailViewModel.ingredientHeaderSectionIndexes[indexPath.section],
               let ingredientSections = recipeDetail.ingredientSections,
               let headerTitle = ingredientSections[recipeHeaderSection].name {
                title = headerTitle
            }
        default:
            return UITableViewCell()
        }
        
        headerTitleCell.setupCell(
            title: title,
            showSeeAllButton: showSeeAllButton,
            isLoading: recipeDetailViewModel.isLoading
        )
        
        return headerTitleCell
    }
    
    private func ingredientsServingCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientsServingCell = tableView.dequeueReusableCell(withIdentifier: ServingsCountTableViewCell.identifier, for: indexPath) as? ServingsCountTableViewCell
        else { return UITableViewCell() }
        
        var serving: ServingsCountCellParams? = nil
        
        if let recipeDetail = recipeDetailViewModel.recipeDetail {
            serving = ServingsCountCellParams(
                servingCount: recipeDetail.numServings ?? 1,
                servingNounSingular: recipeDetail.servingsNounSingular ?? "serving",
                servingNounPlural: recipeDetail.servingsNounPlural ?? "servings"
            )
        }
        
        ingredientsServingCell.setupCell(serving: serving, isLoading: recipeDetailViewModel.isLoading)
        ingredientsServingCell.delegate = self
        
        return ingredientsServingCell
    }
    
    private func ingredientsBodyCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell
        else { return UITableViewCell() }
        
        var ingredient: IngredientCellParams? = nil
        if let recipeDetail = recipeDetailViewModel.recipeDetail,
           let ingredientSections = recipeDetail.ingredientSections,
           let ingredientsBodySection = recipeDetailViewModel.ingredientBodySectionIndexes[indexPath.section] {
            let ingredientSection = ingredientSections[ingredientsBodySection]
            let ingredientOfIndex = ingredientSection.components[indexPath.row]
            
            var ingredientName: String = ingredientOfIndex.ingredient.name.capitalized(with: .current)
            if let extraComment = ingredientOfIndex.extraComment, ingredientOfIndex.extraComment != "" {
                ingredientName = "\(ingredientName), \(extraComment)"
            }
            
            ingredient = IngredientCellParams(
                ingredientName: ingredientName,
                ingredientRatio: ingredientOfIndex.measurementString(servingCount: recipeDetailViewModel.servingCount)
            )
        }
        
        ingredientCell.setupCell(ingredient: ingredient, isLoading: recipeDetailViewModel.isLoading)
        
        return ingredientCell
    }
    
    private func nutritionInfoHeaderCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nutritionInfoHeaderCell = tableView.dequeueReusableCell(withIdentifier: NutritionInfoHeaderTableViewCell.identifier, for: indexPath) as? NutritionInfoHeaderTableViewCell
        else { return UITableViewCell() }
        
        nutritionInfoHeaderCell.setupCell(showInfo: recipeDetailViewModel.showNutritionInfo, isLoading: recipeDetailViewModel.isLoading)
        nutritionInfoHeaderCell.delegate = self
        
        return nutritionInfoHeaderCell
    }
    
    private func nutritionBodyCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nutritionBodyCell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell
        else { return UITableViewCell() }
        
        var ingredient: IngredientCellParams? = nil

        if let nutritions = recipeDetailViewModel.recipeDetail?.nutrition?.nutritions,
           let nutrition = nutritions[indexPath.row+1] {
            ingredient = IngredientCellParams(
                ingredientName: nutrition.title,
                ingredientRatio: nutrition.value
            )
        }
        
        nutritionBodyCell.setupCell(ingredient: ingredient, isLoading: recipeDetailViewModel.isLoading)
        
        return nutritionBodyCell
    }
    
    private func addToGroceryBagCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addToGroceryBagCell = tableView.dequeueReusableCell(withIdentifier: AddToGroceryBagTableViewCell.identifier, for: indexPath) as? AddToGroceryBagTableViewCell
        else { return UITableViewCell() }
        
        addToGroceryBagCell.setupCell(isLoading: recipeDetailViewModel.isLoading)
        
        return addToGroceryBagCell
    }
    
    private func recipeTipCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeTipCell = tableView.dequeueReusableCell(withIdentifier: RecipeTipTableViewCell.identifier, for: indexPath) as? RecipeTipTableViewCell
        else { return UITableViewCell() }
        
        var recipeTopTip: RecipeTipCellParams? = nil
        if let recipeTips = recipeDetailViewModel.recipeTips {
            let topTip = recipeTips.result[indexPath.row]
            recipeTopTip = RecipeTipCellParams(
                totalTipsCount: recipeTips.count,
                topTipImageUrl: topTip.authorAvatarUrlString,
                topTipName: topTip.authorName,
                topTipDescription: topTip.tipBody
            )
        }
        
        recipeTipCell.setupCell(recipeTopTip: recipeTopTip, isLoading: recipeDetailViewModel.isLoading)
        
        return recipeTipCell
    }
    
    private func relatedRecipesCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let relatedRecipesCell = tableView.dequeueReusableCell(withIdentifier: RelatedRecipesTableViewCell.identifier, for: indexPath) as? RelatedRecipesTableViewCell
        else { return UITableViewCell() }
        
        relatedRecipesCell.setupCell(
            relatedRecipes: recipeDetailViewModel.relatedRecipes,
            maxShown: recipeDetailViewModel.maxRelatedRecipesShown,
            screenSize: view.safeAreaLayoutGuide.layoutFrame.size,
            isLoading: recipeDetailViewModel.isLoading
        )
        
        return relatedRecipesCell
    }
    
    private func recipePreparationCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipePreparationCell = tableView.dequeueReusableCell(withIdentifier: RecipePreparationTableViewCell.identifier, for: indexPath) as? RecipePreparationTableViewCell
        else { return UITableViewCell() }
        
        var recipePreparation: RecipePreparationCellParams? = nil
        if let recipeDetail = recipeDetailViewModel.recipeDetail,
           let instructions = recipeDetail.instructions {
            let preparationOfIndex = instructions[indexPath.row]
            recipePreparation = RecipePreparationCellParams(
                preparationNumber: preparationOfIndex.position,
                preparationDescription: preparationOfIndex.displayText
            )
        }
        
        recipePreparationCell.setupCell(
            recipePreparation: recipePreparation,
            isLoading: recipeDetailViewModel.isLoading
        )
        recipePreparationCell.backgroundColor = preparationCellBackgroundColor
        
        return recipePreparationCell
    }
}

extension RecipeDetailViewController: NutritionInfoHeaderCellDelegate {
    func handleShowNutritionInfo(_ showInfo: Bool) {
        recipeDetailViewModel.changeShowNutritionInfo()
        if let nutritionBodySection = recipeDetailViewModel.getSectionIndex(of: .nutritionsBody) {
            recipeDetailTableView.reloadSections(IndexSet(integer: nutritionBodySection), with: .automatic)
        }
    }
}

extension RecipeDetailViewController: ServingStepperDelegate {
    func handleServingValueChanged(_ value: Int) {
        recipeDetailViewModel.changeServingNums(to: value)
    }
    
    
}
