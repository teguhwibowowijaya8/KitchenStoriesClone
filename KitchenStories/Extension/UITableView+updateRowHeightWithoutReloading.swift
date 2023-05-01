//
//  UITableView+updateRowHeightWithoutReloading.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 24/04/23.
//

import UIKit

extension UITableView {
    func updateRowHeightWithoutReloadingRows(animated: Bool = false) {
        let update = {
            self.beginUpdates()
            self.endUpdates()
        }
        
        if animated {
            return update()
        }
        
        UIView.performWithoutAnimation {
            update()
        }
    }
}
