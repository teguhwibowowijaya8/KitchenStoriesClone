//
//  HomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit
import SkeletonView

enum HomeTableRowType: Int {
    case itemsHeader
    case itemsBody
}

class HomeViewController: UIViewController {
    static let tabTitle = "Home"
    static let tabImage = UIImage(systemName: "house")
    static let tabSelectedImage = UIImage(systemName: "house.fill")
    
    private var homeViewModel: HomeViewModel?
    
    private lazy var homeTableView: UITableView = {
        let homeTableView = UITableView()
        homeTableView.isSkeletonable = true
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return homeTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViewModel()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViewModel() {
        homeViewModel = HomeViewModel()
        homeViewModel?.delegate = self
        
        showSkeleton()
        homeViewModel?.fetchFeeds()
    }
    
    private func showSkeleton() {
        homeTableView.showSkeleton()
    }
    
    private func hideSkeleton() {
        homeTableView.stopSkeletonAnimation()
        homeTableView.hideSkeleton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        homeTableView.reloadData()
    }
    
    private func setupTableView() {
        self.view.addSubview(homeTableView)
        setComponentConstraints()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.estimatedRowHeight = 100
        homeTableView.separatorStyle = .none
        
        homeTableView.register(HeaderTitleTableViewCell.self, forCellReuseIdentifier: HeaderTitleTableViewCell.identifier)
        
        homeTableView.register(HomeItemsTableViewCell.self, forCellReuseIdentifier: HomeItemsTableViewCell.identifier)
    }
    
    private func setComponentConstraints() {
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            homeTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    func handleFetchFeedsCompleted() {
        if let errorMessage = homeViewModel?.errorMessage {
            print(errorMessage)
        } else {
            DispatchQueue.main.async {
                self.hideSkeleton()
                self.homeTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = homeViewModel?.feeds?.results.count
        else { return homeViewModel?.dummyFeeds.results.count ?? 0 }
        return sectionCount + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch HomeTableRowType(rawValue: indexPath.row) {
        case .itemsHeader:
            return HeaderTitleTableViewCell.identifier
        default:
            return HomeItemsTableViewCell.identifier
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = homeViewModel
        else { return UITableViewCell() }
        
        let feed: FeedModel
        
        if let feeds = viewModel.feeds?.results {
            if indexPath.section < feeds.count {
                feed = feeds[indexPath.section]
            } else {
                feed = viewModel.recentFeeds
            }
        } else {
            feed = viewModel.dummyFeeds.results[indexPath.section]
        }
        
        switch HomeTableRowType(rawValue: indexPath.row) {
        case .itemsHeader:
            guard let itemsHeaderCell = tableView.dequeueReusableCell(withIdentifier: HeaderTitleTableViewCell.identifier) as? HeaderTitleTableViewCell
            else { return UITableViewCell() }
            
            let headerTitle: String
            
            if let title = feed.name {
                headerTitle = title
            } else {
                let type = feed.type.rawValue
                headerTitle = type.capitalized(with: .current)
            }
            
            itemsHeaderCell.setupCell(
                title: headerTitle,
                showSeeAllButton: feed.itemList.count > feed.minimumShowItems,
                isLoading: viewModel.isLoading
            )
            
            return itemsHeaderCell
            
        case .itemsBody:
            guard let itemsBodyCell = tableView.dequeueReusableCell(withIdentifier: HomeItemsTableViewCell.identifier) as? HomeItemsTableViewCell
            else { return UITableViewCell() }
            
            let screenSize = view.safeAreaLayoutGuide.layoutFrame.size
            
            itemsBodyCell.setupCell(
                feed: feed,
                screenSize: screenSize,
                isLoading: viewModel.isLoading
            )
            itemsBodyCell.delegate = self
            
            return itemsBodyCell
            
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: HomeItemTableCellDelegate {
    func handleFeedItemSelected(recipeId: Int, recipeName: String) {
        let recipeDetailVC = RecipeDetailViewController()
        recipeDetailVC.recipeId = recipeId
        recipeDetailVC.title = recipeName
        
        self.navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
}
