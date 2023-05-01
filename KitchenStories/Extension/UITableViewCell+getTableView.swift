//
//  UITableViewCell+getTableView.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 24/04/23.
//

import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        return (next as? UITableView) ?? (self.parentViewController as? UITableViewController)?.tableView
    }
}
