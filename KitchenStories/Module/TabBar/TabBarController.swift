//
//  TabBarController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabBar()
        
    }
    
    private func setupTabBar() {
        
        setTabBarAppearence()
        
        viewControllers = [
            createViewController(
                HomeViewController(),
                tabTitle: HomeViewController.tabTitle,
                tabImage: HomeViewController.tabImage,
                tabSelectedImage: HomeViewController.tabSelectedImage
            ),
            createViewController(
                ProfileViewController(),
                tabTitle: ProfileViewController.tabTitle,
                tabImage: ProfileViewController.tabImage,
                tabSelectedImage: ProfileViewController.tabSelectedImage
            )
        ]
    }
    
    private func setTabBarAppearence() {
        let tabBarAppearence = UITabBarAppearance()
        tabBarAppearence.stackedLayoutAppearance.normal.iconColor = Constant.mainOrangeColor
        tabBarAppearence.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Constant.mainOrangeColor
        ]
        
        tabBar.tintColor = .gray
        tabBar.standardAppearance = tabBarAppearence
        tabBar.scrollEdgeAppearance = tabBarAppearence
    }

    private func createViewController(
        _ viewController: UIViewController,
        tabTitle: String,
        tabImage: UIImage?,
        tabSelectedImage: UIImage?
    ) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        
        vc.tabBarItem.title = tabTitle
        vc.tabBarItem.image = tabImage
        
        if tabSelectedImage != nil {
            vc.tabBarItem.selectedImage = tabSelectedImage
        }
            
        return vc
    }
}
