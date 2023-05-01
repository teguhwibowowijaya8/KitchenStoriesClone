//
//  UIView+getParentViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 24/04/23.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
}
