//
//  ServingsStepper.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 28/04/23.
//

import UIKit

protocol ServingStepperDelegate {
    func handleServingValueChanged(_ value: Int)
}

class ServingStepper: UIView {
    private var value: Int = 1 {
        didSet(oldValue) {
            if value < minValue {
                value = minValue
            } else if value > maxValue {
                value = maxValue
            }
            
            numberLabel.text = "\(value)"
        }
    }
    private var minValue: Int = 1 {
        didSet {
            if value < minValue {
                value = minValue
            }
        }
    }
    private var maxValue: Int = 1000 {
        didSet {
            if value > maxValue {
                value = maxValue
            }
        }
    }
    
    private lazy var imageButtonConfig: UIImage.SymbolConfiguration = {
        return UIImage.SymbolConfiguration(pointSize: buttonWidth * 0.5, weight: .semibold, scale: .medium)
    }()
    
    private let minusImage: UIImage = UIImage(systemName: "minus")!
    private let plusImage: UIImage = UIImage(systemName: "plus")!
    
    var delegate: ServingStepperDelegate?
    
    var buttonWidth: CGFloat = 30 {
        didSet {
            minusButtonWidth.constant = buttonWidth
            plusButtonWidth.constant = buttonWidth
        }
    }
    
    private lazy var minusButtonWidth: NSLayoutConstraint = {
        let buttonWidthConstraint = minusButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        return buttonWidthConstraint
    }()
    
    private lazy var plusButtonWidth: NSLayoutConstraint = {
        let buttonWidthConstraint = plusButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        return buttonWidthConstraint
    }()
    
    private lazy var numberLabelWidth: NSLayoutConstraint = {
        let buttonWidthConstraint = numberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        
        return buttonWidthConstraint
    }()
    
    private lazy var minusButton: UIButton = {
        let minusButton = UIButton(type: .system)
        minusButton.setImage(
            minusImage.withConfiguration(imageButtonConfig),
            for: .normal
        )
        minusButton.tintColor = Constant.secondaryColor
        
        return minusButton
    }()
    
    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        numberLabel.textAlignment = .center
        
        return numberLabel
    }()
    
    private lazy var plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(
            plusImage.withConfiguration(imageButtonConfig),
            for: .normal
        )
        plusButton.tintColor = Constant.secondaryColor
        
        return plusButton
    }()
    
    private lazy var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.layer.cornerRadius = Constant.cornerRadius
        containerStackView.layer.borderWidth = 0.5
        containerStackView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        containerStackView.clipsToBounds = true
        
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 5
        
        return containerStackView
    }()
    
    private lazy var stepperHeight: NSLayoutConstraint = {
        return containerStackView.heightAnchor.constraint(equalToConstant: 30)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setComponentsContraints()
        registerButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setComponentsContraints()
        registerButtonTarget()
    }
    
    func setValue(_ value: Int) {
        self.value = value
    }
    
    private func addSubviews() {
        self.addSubview(containerStackView)
        containerStackView.addArrangedSubview(minusButton)
        containerStackView.addArrangedSubview(numberLabel)
        containerStackView.addArrangedSubview(plusButton)
    }
    
    private func setComponentsContraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stepperHeight,
            minusButtonWidth,
            plusButtonWidth,
            numberLabelWidth
        ])
    }
    
    private func registerButtonTarget() {
        minusButton.addTarget(self, action: #selector(handlePlusMinButtonSelected), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(handlePlusMinButtonSelected), for: .touchUpInside)
    }
    
    @objc func handlePlusMinButtonSelected(_ sender: UIButton) {
        if sender.currentImage == minusImage.withConfiguration(imageButtonConfig) {
            if value <= minValue {
                return
            } else { value -= 1 }
        } else if sender.currentImage == plusImage.withConfiguration(imageButtonConfig) {
            if value >= maxValue {
                return
            } else { value += 1 }
        }
        delegate?.handleServingValueChanged(value)
    }
    
    func showLoadingView() {
        minusButton.tintColor = .clear
        plusButton.tintColor = .clear
        numberLabel.textColor = .clear
        
        minusButton.isUserInteractionEnabled = false
        plusButton.isUserInteractionEnabled = false
        
        containerStackView.backgroundColor = Constant.loadingColor
    }
    
    func removeLoadingView() {
        minusButton.tintColor = Constant.secondaryColor
        plusButton.tintColor = Constant.secondaryColor
        numberLabel.textColor = Constant.secondaryColor
        
        minusButton.isUserInteractionEnabled = true
        plusButton.isUserInteractionEnabled = true
        
        containerStackView.backgroundColor = .clear
    }
}
