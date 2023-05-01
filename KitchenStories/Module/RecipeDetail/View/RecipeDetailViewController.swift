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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: indexPath) as? DetailHeaderTableViewCell
        else { return UITableViewCell() }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
