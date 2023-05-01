//
//  ServingsCountTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 28/04/23.
//

import UIKit

class ServingsCountTableViewCell: UITableViewCell {
    
    var delegate: ServingStepperDelegate?
    
    var servingCount: Int = 1 {
        didSet {
            servingCountLabel.text = "\(servingCount) servings"
            servingStepper.setValue(servingCount)
        }
    }
    
    private lazy var servingTitleLabel: UILabel = {
       let servingTitleLabel = UILabel()
        
        servingTitleLabel.text = "Ingredients for"
        servingTitleLabel.numberOfLines = 0
        servingTitleLabel.font = .boldSystemFont(ofSize: 14)
        
        return servingTitleLabel
    }()
    
    private lazy var servingCountLabel: UILabel = {
       let servingCountLabel = UILabel()
        
        servingCountLabel.numberOfLines = 0
        servingCountLabel.font = .systemFont(ofSize: 15)
        
        return servingCountLabel
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 0
        
        return verticalStackView
    }()
    
    private lazy var servingStepper: ServingStepper = {
       let servingStepper = ServingStepper()
        
        servingStepper.delegate = self
        
        return servingStepper
    }()
    
    private lazy var horizontalStackView: UIStackView = {
       let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 8
        
        return horizontalStackView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        addSubviews()
        setComponentsConstraints()
    }
    
    private func addSubviews() {
        verticalStackView.addArrangedSubview(servingTitleLabel)
        verticalStackView.addArrangedSubview(servingCountLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(servingStepper)
        self.contentView.addSubview(horizontalStackView)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            horizontalStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            horizontalStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])
    }
}

extension ServingsCountTableViewCell: ServingStepperDelegate {
    func didMinButtonSelected(_ value: Int) {
        servingCount = value
        delegate?.didMinButtonSelected(value)
    }
    
    func didPlusButtonSelected(_ value: Int) {
        servingCount = value
        delegate?.didPlusButtonSelected(value)
    }
    
    
}
