//
//  ProfileAccountTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import UIKit

struct ProfileAccountCellParams {
    var userImageUrlString: String?
    var userName: String
    var abbreviation: String
}

class ProfileAccountTableViewCell: UITableViewCell {
    static let identifier = "ProfileAccountTableViewCell"
    
    private let imageContainerHeight: CGFloat = 80
    
    private var getNetworkImageService = GetNetworkImageService()
    
    private lazy var imageContainerView: UIView = {
        let imageContainerView = UIView()
        
        imageContainerView.backgroundColor = Constant.secondaryColor
        imageContainerView.layer.cornerRadius = Constant.cornerRadius
        imageContainerView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalToConstant: imageContainerHeight),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor)
        ])
        
        return imageContainerView
    }()
    
    private lazy var defaultImageLabel: UILabel = {
       let defaultImageLabel = UILabel()
        defaultImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        defaultImageLabel.isHidden = true
        defaultImageLabel.font = .boldSystemFont(ofSize: 30)
        defaultImageLabel.adjustsFontSizeToFitWidth = true
        defaultImageLabel.textColor = .black
        
        return defaultImageLabel
    }()
    
    private lazy var userImageView: UIImageView = {
       let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.isHidden = true
        userImageView.contentMode = .scaleAspectFill
        
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
        verticalContainerStackView.spacing = 5
        
        return verticalContainerStackView
    }()
    
    private lazy var horizontalContainerStackView: UIStackView = {
        let horizontalContainerStackView = UIStackView()
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .center
        horizontalContainerStackView.spacing = 10
        
        return horizontalContainerStackView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setComponentsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.contentView.addSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(imageContainerView)
        imageContainerView.addSubview(defaultImageLabel)
        imageContainerView.addSubview(userImageView)
        
        horizontalContainerStackView.addArrangedSubview(verticalContainerStackView)
        verticalContainerStackView.addArrangedSubview(userNameLabel)
        verticalContainerStackView.addArrangedSubview(editProfileLabel)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            horizontalContainerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            horizontalContainerStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            horizontalContainerStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            horizontalContainerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            defaultImageLabel.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 5),
            defaultImageLabel.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor, constant: 5),
            defaultImageLabel.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor, constant: -5),
            defaultImageLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -5),
            
            userImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            userImageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor),
            userImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),
            userImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        getNetworkImageService.cancel()
    }
    
    func setupCell(
        profileAccount: ProfileAccountCellParams?,
        isLoading: Bool
    ) {
        guard isLoading == false,
           let profileAccount = profileAccount
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        userNameLabel.text = profileAccount.userName
        if let imageUrlString = profileAccount.userImageUrlString {
            userImageView.loadImageFromUrl(imageUrlString, defaultImage: nil, getImageNetworkService: getNetworkImageService)
            userImageView.isHidden = false
            defaultImageLabel.isHidden = true
        } else {
            defaultImageLabel.text = profileAccount.abbreviation.uppercased()
            userImageView.isHidden = true
            defaultImageLabel.isHidden = false
        }
    }
    
    private func showLoadingView() {
        defaultImageLabel.isHidden = true
        userImageView.isHidden = true
        
        userNameLabel.text = Constant.shortPlaceholderText
        
        userNameLabel.textColor = .clear
        editProfileLabel.textColor = .clear
        
        imageContainerView.backgroundColor = Constant.loadingColor
        userNameLabel.backgroundColor = Constant.loadingColor
        editProfileLabel.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        userNameLabel.textColor = .label
        editProfileLabel.textColor = .gray
        
        imageContainerView.backgroundColor = Constant.secondaryColor
        userNameLabel.backgroundColor = .clear
        editProfileLabel.backgroundColor = .clear
    }
}
