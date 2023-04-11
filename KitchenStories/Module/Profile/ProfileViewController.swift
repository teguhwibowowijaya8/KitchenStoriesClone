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

}
