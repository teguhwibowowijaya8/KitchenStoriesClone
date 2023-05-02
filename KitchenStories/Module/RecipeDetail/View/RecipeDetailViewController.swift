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
    
    private lazy var recipeDetailTableView: UITableView = {
        let recipeDetailTableView = UITableView()
        recipeDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        recipeDetailTableView.delegate = self
        recipeDetailTableView.dataSource = self
        recipeDetailTableView.separatorStyle = .none
        
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewModel() {
        recipeDetailViewModel = RecipeDetailViewModel(recipeId: recipeId)
        recipeDetailViewModel.delegate = self
    }
    
    private func setupTableView() {
        registerTableViewCell()
        
        self.view.addSubview(recipeDetailTableView)
        
        NSLayoutConstraint.activate([
            recipeDetailTableView.topAnchor.constraint(equalTo: view.topAnchor),
            recipeDetailTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipeDetailTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            recipeDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func registerTableViewCell() {
        let detailHeaderNib = UINib(nibName: DetailHeaderTableViewCell.identifier, bundle: nil)
        recipeDetailTableView.register(detailHeaderNib, forCellReuseIdentifier: DetailHeaderTableViewCell.identifier)
        
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
        if recipeDetailViewModel.errorMessage.count <= 0 {
            print(recipeDetailViewModel.errorMessage)
        } else {
            DispatchQueue.main.async {
                self.recipeDetailTableView.reloadData()
            }
        }
    }
    
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch RecipeDetailSection(rawValue: indexPath.section) {
            
        case .header:
            return UITableViewCell()
        case .ingredientServing:
            return UITableViewCell()
        case .ingredientsBody:
            return UITableViewCell()
        case .nutritionsInfoHeader:
            return UITableViewCell()
        case .nutritionsBody:
            return UITableViewCell()
        case .addToGrocery:
            return UITableViewCell()
        case .topTip:
            return UITableViewCell()
        case .relatedRecipesHeader:
            return UITableViewCell()
        case .relatedRecipesBody:
            return UITableViewCell()
        case .preparationsHeader:
            return UITableViewCell()
        case .preparationsBody:
            return UITableViewCell()
        case .none:
            return UITableViewCell()
        }
    }
    
    private func headerCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderTableViewCell.identifier, for: indexPath) as? DetailHeaderTableViewCell
        else { return UITableViewCell() }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
