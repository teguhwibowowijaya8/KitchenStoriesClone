//
//  ProfilePhotoTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

struct ProfilePhotoCellParams {
    var userImageUrlString: String?
    var userNameAbbreviation: String
}

class ProfilePhotoTableViewCell: UITableViewCell {
    static let identifier = "ProfilePhotoTableViewCell"
    
    private let imageContainerHeight: CGFloat = 120
    
    private let editPhotoImageWidth: CGFloat = 22
    private let editPhotoImage: UIImage? = UIImage(systemName: "pencil.circle")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    private lazy var imageContainerView: UIView = {
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.backgroundColor = Constant.secondaryColor
        imageContainerView.layer.cornerRadius = Constant.cornerRadius
        imageContainerView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageContainerView.heightAnchor.constraint(equalToConstant: imageContainerHeight),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor)
        ])
        
        return imageContainerView
    }()
    
    private lazy var profileImageView: UIImageView = {
       let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
                
        return profileImageView
    }()
    
    private lazy var defaultImageLabel: UILabel = {
       let defaultImageLabel = UILabel()
        defaultImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        defaultImageLabel.isHidden = true
        defaultImageLabel.font = .boldSystemFont(ofSize: 35)
        defaultImageLabel.adjustsFontSizeToFitWidth = true
        defaultImageLabel.textColor = .black
        
        return defaultImageLabel
    }()
    
    private lazy var editPhotoImageView: UIImageView = {
        let editPhotoImageView = UIImageView()
        editPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        editPhotoImageView.backgroundColor = .gray.withAlphaComponent(0.5)
        editPhotoImageView.image = editPhotoImage
        editPhotoImageView.tintColor = .white
        
        NSLayoutConstraint.activate([
            editPhotoImageView.widthAnchor.constraint(equalToConstant: editPhotoImageWidth),
            editPhotoImageView.heightAnchor.constraint(equalTo: editPhotoImageView.widthAnchor)
        ])
        
        return editPhotoImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setComponentsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        getNetworkImageService.cancel()
    }
    
    func setupCell(profilePhoto: ProfilePhotoCellParams?, isLoading: Bool) {
        guard isLoading == false,
              let profilePhoto = profilePhoto
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        if let userImageUrlString = profilePhoto.userImageUrlString, userImageUrlString != "" {
            profileImageView.loadImageFromUrl(userImageUrlString, defaultImage: nil, getImageNetworkService: getNetworkImageService)
            
            profileImageView.isHidden = false
            defaultImageLabel.isHidden = true
        } else {
            defaultImageLabel.text = profilePhoto.userNameAbbreviation
            
            profileImageView.isHidden = true
            defaultImageLabel.isHidden = false
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(defaultImageLabel)
        imageContainerView.addSubview(profileImageView)
        imageContainerView.addSubview(editPhotoImageView)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageContainerView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            imageContainerView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            defaultImageLabel.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            defaultImageLabel.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor, constant: Constant.horizontalSpacing),
            defaultImageLabel.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor, constant: -Constant.horizontalSpacing),
            defaultImageLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            profileImageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor),
            profileImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            editPhotoImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),
            editPhotoImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
        ])
    }
    
    private func showLoadingView() {
        imageContainerView.backgroundColor = Constant.loadingColor
        profileImageView.isHidden = true
        defaultImageLabel.isHidden = true
    }

    private func removeLoadingView() {
        imageContainerView.backgroundColor = Constant.secondaryColor
    }
}
