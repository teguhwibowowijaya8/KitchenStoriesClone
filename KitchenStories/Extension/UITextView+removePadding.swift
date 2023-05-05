//
//  UITextView+removePadding.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import UIKit

extension UITextView {
    func removePadding() {
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
    }
}
