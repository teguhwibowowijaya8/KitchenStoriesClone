//
//  SaveUserProfileTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

protocol SaveUserProfileCellDelegate {
    func handleSaveUserInformation()
}

class SaveUserProfileTableViewCell: UITableViewCell {
    static let identifier = "SaveUserProfileTableViewCell"
    
    private let saveButtonTitle: String = "Save Profile"
    
    var delegate: SaveUserProfileCellDelegate?
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle(saveButtonTitle, for: .normal)
        saveButton.backgroundColor = Constant.secondaryColor
        saveButton.layer.cornerRadius = Constant.cornerRadius
        saveButton.clipsToBounds = true
        saveButton.tintColor = .white
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        saveButton.addTarget(self, action: #selector(onSaveButtonSelected), for: .touchUpInside)
        
        return saveButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSaveButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSaveButton() {
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constant.horizontalSpacing),
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            saveButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc func onSaveButtonSelected(_ sender: UIButton) {
        delegate?.handleSaveUserInformation()
    }

}
