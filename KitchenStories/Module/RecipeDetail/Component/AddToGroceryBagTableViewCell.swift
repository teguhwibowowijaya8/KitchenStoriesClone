//
//  AddToGroceryBagTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 30/04/23.
//

import UIKit

protocol AddToGroceryBagCellDelegate {
    func handleAddToGroceryBag()
}

class AddToGroceryBagTableViewCell: UITableViewCell {
    
    var delegate: AddToGroceryBagCellDelegate?
    
    private lazy var titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Save time, shop ingredients"
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        return titleLabel
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subTitleLabel.text = "Build your grocery bag with Kitchen Stories to save your time and organize your grocery bag."
        subTitleLabel.font = .systemFont(ofSize: 13)
        subTitleLabel.numberOfLines = 0
        
        return subTitleLabel
    }()
    
    private lazy var addToGroceryButton: UIButton = {
        let addToGroceryButton = UIButton(type: .system)
        addToGroceryButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToGroceryButton.setTitle("Add item to grocery bag", for: .normal)
        addToGroceryButton.backgroundColor = Constant.secondaryColor
        addToGroceryButton.tintColor = .white
        addToGroceryButton.layer.cornerRadius = 5
        addToGroceryButton.clipsToBounds = true
        
        addToGroceryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addToGroceryButton.addTarget(self, action: #selector(addItemToGroceryBag), for: .touchUpInside)
        
        return addToGroceryButton
    }()
    
    func setupCell() {
        addSubviews()
        setComponentsConstraints()
    }

    private func addSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subTitleLabel)
        self.contentView.addSubview(addToGroceryButton)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            subTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            
            addToGroceryButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 8),
            addToGroceryButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            addToGroceryButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            addToGroceryButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func addItemToGroceryBag(_ sender: UIButton) {
        delegate?.handleAddToGroceryBag()
    }
}
