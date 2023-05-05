//
//  ProfileViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    static let tabTitle = "Profile"
    static let tabImage = UIImage(systemName: "person")
    static let tabSelectedImage = UIImage(systemName: "person.fill")
    
    private var profileViewModel: ProfileViewModel!
    
    private lazy var profileTableView: UITableView = {
       let profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return profileTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupViewModel() {
        profileViewModel = ProfileViewModel()
    }
    
    private func setupTableView() {
        view.addSubview(profileTableView)
        
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
