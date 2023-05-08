//
//  UIImageView+LoadImageFromUrl.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

extension UIImageView {
    func loadImageFromUrl(
        _ urlString: String?,
        defaultImage: UIImage?,
        getImageNetworkService: GetNetworkImageProtocol
    ) {
        guard let urlString = urlString
        else {
            self.image = defaultImage
            return
        }
        getImageNetworkService.getImage(urlString) { [weak self] urlImage, errorMessage in
            
            var image: UIImage? = defaultImage
            if let urlImage = urlImage {
                image = urlImage
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
