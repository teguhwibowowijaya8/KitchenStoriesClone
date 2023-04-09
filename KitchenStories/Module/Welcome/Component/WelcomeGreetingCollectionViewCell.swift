//
//  WelcomeGreetingCollectionViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 09/04/23.
//

import UIKit

class WelcomeGreetingCollectionViewCell: UICollectionViewCell {
    static let identifier = "WelcomeGreetingCollectionViewCell"
    
    private lazy var welcomeTitleLabel: UILabel = {
       let welcomeTitleLabel = UILabel()
        welcomeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeTitleLabel.font = .boldSystemFont(ofSize: 27)
        welcomeTitleLabel.numberOfLines = 0
        welcomeTitleLabel.textAlignment = .center
        welcomeTitleLabel.textColor = .white
        
        return welcomeTitleLabel
    }()
    
    private lazy var welcomeSubtitleLabel: UILabel = {
        let welcomeSubtitleLabel = UILabel()
        welcomeSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeSubtitleLabel.font = .systemFont(ofSize: 20)
        welcomeSubtitleLabel.textAlignment = .center
        welcomeSubtitleLabel.numberOfLines = 0
        welcomeSubtitleLabel.textColor = .white
        
        return welcomeSubtitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSelfAttributes()
        addSubviews()
        setComponentsConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSelfAttributes()
        addSubviews()
        setComponentsConstraints()
    }
    
    func setCell(title: String, subtitle: String) {
        welcomeTitleLabel.text = title
        welcomeSubtitleLabel.text = subtitle
    }
    
    private func setSelfAttributes() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        self.addSubview(welcomeTitleLabel)
        self.addSubview(welcomeSubtitleLabel)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            welcomeTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            welcomeTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            welcomeTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            
            welcomeSubtitleLabel.topAnchor.constraint(equalTo: welcomeTitleLabel.bottomAnchor, constant: 20),
            welcomeSubtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            welcomeSubtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            welcomeSubtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
        ])
    }
}
