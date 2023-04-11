//
//  HomeItemHeaderTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 11/04/23.
//

import UIKit

protocol HomeItemHeaderCellDelegate {
    func handleOnSeeAllButtonSelected()
}

class HomeItemHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "HomeItemHeaderTableViewCell"
    
    var delegate: HomeItemHeaderCellDelegate?
    
    private lazy var headerTitleLabel: UILabel = {
       let headerTitleLabel = UILabel()
        
        headerTitleLabel.font = .boldSystemFont(ofSize: 18)
        headerTitleLabel.numberOfLines = 0
        
        return headerTitleLabel
    }()
    
    private lazy var headerSeeAllButton: UIButton = {
        let headerSeeAllButton = UIButton(type: .system)
        
        let arrowRightImage = UIImage(systemName: "arrow.right")
        headerSeeAllButton.setImage(arrowRightImage, for: .normal)
        headerSeeAllButton.tintColor = .orange
        
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
        headerStackContainerView.alignment = .top
        headerStackContainerView.spacing = 8
        
        return headerStackContainerView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(title: String) {
        headerTitleLabel.text = title
        
        addSubviews()
        setComponentsConstraints()
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
            headerStackContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            headerStackContainerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            headerStackContainerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            headerStackContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
    }
}
