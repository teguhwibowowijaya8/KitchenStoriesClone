//
//  ProfileSettingTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 05/05/23.
//

import UIKit

struct ProfileSettingCellParams {
    let settingImageSymbolName: String
    let settingName: String
    var settingTintColor: UIColor = .label
}

class ProfileSettingTableViewCell: UITableViewCell {
    static let identifier = "ProfileSettingTableViewCell"
    
    private let settingImageHeight: CGFloat = 25
    private let settingNameLabelSize: CGFloat = 16
    
    private lazy var horizontalStackContainer: UIStackView = {
       let horizontalStackContainer = UIStackView()
        horizontalStackContainer.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackContainer.axis = .horizontal
        horizontalStackContainer.distribution = .fill
        horizontalStackContainer.alignment = .center
        horizontalStackContainer.spacing = 10
        
        return horizontalStackContainer
    }()
    
    private lazy var settingImageView: UIImageView = {
       let settingImageView = UIImageView()
        
        settingImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            settingImageView.widthAnchor.constraint(equalToConstant: settingImageHeight),
            settingImageView.heightAnchor.constraint(equalTo: settingImageView.widthAnchor)
        ])
        
        return settingImageView
    }()
    
    private lazy var settingNameLabel: UILabel = {
       let settingNameLabel = UILabel()
        
        settingNameLabel.numberOfLines = 0
        settingNameLabel.font = .systemFont(ofSize: settingNameLabelSize, weight: .semibold)
        
        return settingNameLabel
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
        self.contentView.addSubview(horizontalStackContainer)
        horizontalStackContainer.addArrangedSubview(settingImageView)
        horizontalStackContainer.addArrangedSubview(settingNameLabel)
    }

    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            horizontalStackContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            horizontalStackContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            horizontalStackContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func setupCell(
        profileSetting: ProfileSettingCellParams?,
        isLoading: Bool
    ) {
        guard isLoading == false,
              let profileSetting = profileSetting
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        
        settingImageView.image = UIImage(systemName: profileSetting.settingImageSymbolName)
        settingNameLabel.text = profileSetting.settingName
        
        settingImageView.tintColor = profileSetting.settingTintColor
        settingNameLabel.tintColor = profileSetting.settingTintColor
    }
    
    private func showLoadingView() {
        settingNameLabel.backgroundColor = Constant.loadingColor
        settingNameLabel.textColor = .clear
        settingNameLabel.text = Constant.shortPlaceholderText
        
        settingImageView.image = nil
        settingImageView.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        settingNameLabel.backgroundColor = .clear
        settingNameLabel.textColor = .label
        
        settingImageView.backgroundColor = .clear
    }
}
