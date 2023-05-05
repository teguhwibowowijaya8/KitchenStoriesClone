//
//  ProfileAccountTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import UIKit

class ProfileAccountTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
       let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    private lazy var imageContainerView: UIView = {
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.backgroundColor = Constant.secondaryColor
        imageContainerView.layer.cornerRadius = Constant.cornerRadius
        imageContainerView.clipsToBounds = true
        
        return imageContainerView
    }()
    
    private lazy var defaultImageLabel: UILabel = {
       let defaultImageLabel = UILabel()
        defaultImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        defaultImageLabel.font = .boldSystemFont(ofSize: 30)
        defaultImageLabel.textColor = .black
        
        return defaultImageLabel
    }()
    
    private lazy var userImageView: UIImageView = {
       let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return userImageView
    }()
    
    private lazy var userNameLabel: UILabel = {
       let userNameLabel = UILabel()
        
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        userNameLabel.numberOfLines = 0
        
        return userNameLabel
    }()
    
    private lazy var editProfileLabel: UILabel = {
        let editProfileLabel = UILabel()
        
        editProfileLabel.text = "Edit profile"
        editProfileLabel.textColor = .gray
        editProfileLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        editProfileLabel.adjustsFontSizeToFitWidth = true
        
        return editProfileLabel
    }()
    
    private lazy var verticalContainerStackView: UIStackView = {
        let verticalContainerStackView = UIStackView()
        
        verticalContainerStackView.axis = .vertical
        verticalContainerStackView.distribution = .fill
        verticalContainerStackView.alignment = .fill
        
        return verticalContainerStackView
    }()
    
    private lazy var horizontalContainerStackView: UIStackView = {
        let horizontalContainerStackView = UIStackView()
        
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .fill
        
        return horizontalContainerStackView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
