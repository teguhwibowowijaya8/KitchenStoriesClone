//
//  HomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    static let tabTitle = "Home"
    static let tabImage = UIImage(systemName: "house")
    static let tabSelectedImage = UIImage(systemName: "house.fill")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
}
