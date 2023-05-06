//
//  Utilities.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import UIKit

struct Utilities {
    static func changeViewControllerRoot(to newRootVc: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = UINavigationController(rootViewController: newRootVc)
            window.makeKeyAndVisible()
        }, completion: nil)
    }
}
