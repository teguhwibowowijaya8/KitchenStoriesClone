//
//  HomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

enum HomeTableRowType: Int {
    case feedsHeader
    case feedsBody
}

enum FeedsBodyType {
    case horizontal
    case vertical
}

class HomeViewController: UIViewController {
    static let tabTitle = "Home"
    static let tabImage = UIImage(systemName: "house")
    static let tabSelectedImage = UIImage(systemName: "house.fill")
    
    private let headerTopPadding: CGFloat = 15
    private let headerBottomPadding: CGFloat = 0
    
    private var homeViewModel: HomeViewModel!
    
    private lazy var homeTableView: UITableView = {
        let homeTableView = UITableView()
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
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViewModel() {
        homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        
        homeViewModel.fetchFeeds()
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
        if let errorMessage = homeViewModel.errorMessage {
            print(errorMessage)
        } else {
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = homeViewModel.feeds?.results.count
        else { return homeViewModel.dummyFeeds.results.count }
        // + 1 is recent feeds
        return sectionCount + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var feed: FeedModel? = nil
        var title: String? = nil
        var showSeeAllButton = false
        
        if let feeds = homeViewModel.feeds?.results {
            if indexPath.section < feeds.count {
                let feedItem = feeds[indexPath.section]
                feed = feedItem
                title = feedItem.name
                showSeeAllButton = feedItem.itemList.count > feedItem.minimumShowItems
            } else if indexPath.section == feeds.count,
                let recentFeeds = homeViewModel.recentFeeds {
                feed = recentFeeds
                title = "Recent"
                showSeeAllButton = recentFeeds.itemList.count > recentFeeds.minimumShowItems
            }
        }
        
        switch HomeTableRowType(rawValue: indexPath.row) {
        case .feedsHeader:
            return feedsHeaderCell(
                tableView,
                cellForRowAt: indexPath,
                title: title,
                showSeeAllButton: showSeeAllButton
            )
            
        case .feedsBody:
            let feedBody = feed ?? homeViewModel.dummyFeeds.results[indexPath.section]
            return feedsBodyCell(
                tableView,
                cellForRowAt: indexPath,
                feed: feedBody
            )
            
        default:
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

extension HomeViewController {
    private func feedsHeaderCell(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        title: String?,
        showSeeAllButton: Bool
    ) -> UITableViewCell {
        guard let itemsHeaderCell = tableView.dequeueReusableCell(withIdentifier: HeaderTitleTableViewCell.identifier) as? HeaderTitleTableViewCell
        else { return UITableViewCell() }
        
        itemsHeaderCell.setupCell(
            title: title,
            showSeeAllButton: showSeeAllButton,
            isLoading: homeViewModel.isLoading,
            paddingTop: headerTopPadding,
            paddingBottom: headerBottomPadding
        )
        
        return itemsHeaderCell
    }
    
    private func feedsBodyCell(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        feed: FeedModel
    ) -> UITableViewCell {
        guard let itemsBodyCell = tableView.dequeueReusableCell(withIdentifier: HomeItemsTableViewCell.identifier) as? HomeItemsTableViewCell
        else { return UITableViewCell() }
        
        let screenSize = view.safeAreaLayoutGuide.layoutFrame.size
        
        itemsBodyCell.setupCell(
            feed: feed,
            screenSize: screenSize,
            isLoading: homeViewModel.isLoading
        )
        itemsBodyCell.delegate = self
        
        return itemsBodyCell
    }
}

extension HomeViewController: HeaderTitleCellDelegate {
    func handleOnSeeAllButtonSelected(title: String) {
        guard let feed = homeViewModel.getFeedBasedOn(title: title)
        else { return }
        
        var startRecentFeedFrom: Int? = nil
        var showAllRecipesType: ShowAllRecipesType = .withoutFetchMore
        if feed.type == .recent,
           let feeds = homeViewModel.feeds?.results,
           let recentFeeds = homeViewModel.recentFeeds?.itemList {
            startRecentFeedFrom = feeds.count + recentFeeds.count
            showAllRecipesType = .canFetchMore
        }
        
        let showAllFeedRecipesVc = ShowAllRecipesViewController(
            showAllRecipesType: showAllRecipesType,
            recipes: feed.itemList,
            startRecentFeedFrom: startRecentFeedFrom
        )
        showAllFeedRecipesVc.title = feed.name
        
        navigationController?.pushViewController(showAllFeedRecipesVc, animated: true)
    }
}

extension HomeViewController: HomeItemTableCellDelegate {
    func handleFeedItemSelected(recipe: RecipeModel) {
        let recipeDetailVc = Utilities.recipeDetailController(recipe: recipe)
        
        self.navigationController?.pushViewController(recipeDetailVc, animated: true)
    }
}
