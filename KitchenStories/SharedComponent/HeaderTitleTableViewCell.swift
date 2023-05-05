//
//  HeaderTitleTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

protocol HeaderTitleCellDelegate {
    func handleOnSeeAllButtonSelected()
}

class HeaderTitleTableViewCell: UITableViewCell {
    
    static let identifier = "HeaderTitleTableViewCell"
    
    var delegate: HeaderTitleCellDelegate?
    
    private lazy var headerTitleLabel: UILabel = {
       let headerTitleLabel = UILabel()
        
        headerTitleLabel.font = .boldSystemFont(ofSize: 18)
        headerTitleLabel.numberOfLines = 1
        headerTitleLabel.adjustsFontSizeToFitWidth = true
        
        return headerTitleLabel
    }()
    
    private lazy var headerSeeAllButton: UIButton = {
        let headerSeeAllButton = UIButton(type: .system)
        
        let arrowRightImage = UIImage(systemName: "arrow.right")
        headerSeeAllButton.setImage(arrowRightImage, for: .normal)
        headerSeeAllButton.tintColor = Constant.secondaryColor
        headerSeeAllButton.isHidden = true
        
        NSLayoutConstraint.activate([
            headerSeeAllButton.heightAnchor.constraint(equalToConstant: 30),
            headerSeeAllButton.widthAnchor.constraint(equalTo: headerSeeAllButton.heightAnchor)
        ])
        
        headerSeeAllButton.scalesLargeContentImage = true
        
        headerSeeAllButton.addTarget(self, action: #selector(onSeeAllButtonSelected), for: .touchUpInside)
        
        return headerSeeAllButton
    }()
    
    private lazy var headerStackContainerView: UIStackView = {
        let headerStackContainerView = UIStackView()
        
        headerStackContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackContainerView.axis = .horizontal
        headerStackContainerView.distribution = .fill
        headerStackContainerView.alignment = .center
        headerStackContainerView.spacing = 8
        
        return headerStackContainerView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(
        title: String? = nil,
        showSeeAllButton: Bool = true,
        isLoading: Bool = false
    ) {
        addSubviews()
        setComponentsConstraints()
        
        guard isLoading == false
        else {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        if title != nil { headerTitleLabel.text = title }
        headerSeeAllButton.isHidden = !showSeeAllButton
    }
    
    @objc func onSeeAllButtonSelected(_ sender: UIButton) {
        delegate?.handleOnSeeAllButtonSelected()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(headerStackContainerView)
        headerStackContainerView.addArrangedSubview(headerTitleLabel)
        headerStackContainerView.addArrangedSubview(headerSeeAllButton)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            headerStackContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            headerStackContainerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            headerStackContainerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            headerStackContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    private func showLoadingView() {
        headerTitleLabel.backgroundColor = Constant.loadingColor
        headerSeeAllButton.backgroundColor = Constant.loadingColor
        
        headerTitleLabel.text = Constant.placholderText1
        
        headerTitleLabel.textColor = .clear
        headerSeeAllButton.tintColor = .clear
    }
    
    private func removeLoadingView() {
        headerTitleLabel.backgroundColor = .clear
        headerSeeAllButton.backgroundColor = .clear
        
        headerTitleLabel.textColor = .label
        headerSeeAllButton.tintColor = Constant.secondaryColor
    }
}
