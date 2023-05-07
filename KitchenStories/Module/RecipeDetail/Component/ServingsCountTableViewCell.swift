//
//  ServingsCountTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 28/04/23.
//

import UIKit

struct ServingsCountCellParams {
    let servingCount: Int
    let servingNounSingular: String
    let servingNounPlural: String
}

class ServingsCountTableViewCell: UITableViewCell {
    static let identifier = "ServingsCountTableViewCell"
    
    var delegate: ServingStepperDelegate?
    
    private var servingCount: Int = 1 {
        didSet {
            let servingNoun = servingCount > 1 ? servingNounPlural : servingNounSingular
            servingCountLabel.text = "\(servingCount) \(servingNoun)"
            servingStepper.setValue(servingCount)
        }
    }
    
    private var servingNounSingular: String = "serving"
    private var servingNounPlural: String = "servings"
    
    private lazy var servingTitleLabel: UILabel = {
       let servingTitleLabel = UILabel()
        
        servingTitleLabel.text = "Ingredients for"
        servingTitleLabel.numberOfLines = 0
        servingTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        return servingTitleLabel
    }()
    
    private lazy var servingCountLabel: UILabel = {
       let servingCountLabel = UILabel()
        
        servingCountLabel.numberOfLines = 0
        servingCountLabel.font = .systemFont(ofSize: 17)
        
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
    
    func setupCell(
        serving: ServingsCountCellParams?,
        isLoading: Bool
    ) {
        addSubviews()
        setComponentsConstraints()
        
        if isLoading {
            showLoadingView()
            return
        }
        
        if let serving = serving {
            removeLoadingView()
            
            servingNounPlural = serving.servingNounPlural
            servingNounSingular = serving.servingNounSingular
            servingCount = serving.servingCount
        }
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
            horizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }
    
    private func showLoadingView() {
        servingTitleLabel.textColor = .clear
        servingTitleLabel.backgroundColor = Constant.loadingColor
        
        servingCountLabel.text = "0 serving"
        servingCountLabel.textColor = .clear
        servingCountLabel.backgroundColor = Constant.loadingColor
        
        servingStepper.showLoadingView()
    }
    
    private func removeLoadingView() {
        servingTitleLabel.textColor = .label
        servingTitleLabel.backgroundColor = .clear
        
        servingCountLabel.textColor = .label
        servingCountLabel.backgroundColor = .clear
        
        servingStepper.removeLoadingView()
    }
}

extension ServingsCountTableViewCell: ServingStepperDelegate {
    func handleServingValueChanged(_ value: Int) {
        servingCount = value
        delegate?.handleServingValueChanged(value)
    }
}
