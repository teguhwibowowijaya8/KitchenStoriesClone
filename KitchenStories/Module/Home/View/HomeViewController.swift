//
//  HomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

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
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return homeTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViewModel() {
        homeViewModel = HomeViewModel()
        homeViewModel?.delegate = self
        homeViewModel?.fetchFeeds()
    }
    
    private func setupTableView() {
        self.view.addSubview(homeTableView)
        setComponentConstraints()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        homeTableView.register(HomeItemHeaderTableViewCell.self, forCellReuseIdentifier: HomeItemHeaderTableViewCell.identifier)
        
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
                self.homeTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel?.feeds?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feed = homeViewModel?.feeds?.results[indexPath.section]
        else { return UITableViewCell() }
        
        switch HomeTableRowType(rawValue: indexPath.section) {
        case .itemsHeader:
            guard let itemsHeaderCell = tableView.dequeueReusableCell(withIdentifier: HomeItemHeaderTableViewCell.identifier) as? HomeItemHeaderTableViewCell
            else { return UITableViewCell() }
            
            let headerTitle: String
            if let title = feed.name {
                headerTitle = title
            } else {
                let type = feed.type.rawValue
                headerTitle = type.capitalized(with: .current)
            }
            
            itemsHeaderCell.setupCell(title: headerTitle)
                    
            return itemsHeaderCell
                    
        case .itemsBody:
            guard let itemsBodyCell = tableView.dequeueReusableCell(withIdentifier: HomeItemsTableViewCell.identifier) as? HomeItemsTableViewCell
            else { return UITableViewCell() }
            
            let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height
            itemsBodyCell.setupCell(
                feed: feed,
                screenHeight: screenHeight
            )
                    
            return itemsBodyCell
            
            
        case .none:
            return UITableViewCell()
        }
    }
}
