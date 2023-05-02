//
//  ServingsStepper.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 28/04/23.
//

import UIKit

protocol ServingStepperDelegate {
    func didMinButtonSelected(_ value: Int)
    func didPlusButtonSelected(_ value: Int)
}

class ServingStepper: UIView {
    private var value: Int = 1 {
        didSet {
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
    private var maxValue: Int = 100 {
        didSet {
            if value > maxValue {
                value = maxValue
            }
        }
    }
    
    static private let minusImage: UIImage = UIImage(systemName: "minus")!
    static private let plusImage: UIImage = UIImage(systemName: "plus")!
    
    var delegate: ServingStepperDelegate?
    
    var buttonWidth: CGFloat = 35 {
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
        let buttonWidthConstraint = numberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        
        return buttonWidthConstraint
    }()
    
    private lazy var minusButton: UIButton = {
        let minusButton = UIButton(type: .system)
        minusButton.setImage(ServingStepper.minusImage, for: .normal)
        minusButton.tintColor = Constant.secondaryColor
        
        return minusButton
    }()
    
    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = .systemFont(ofSize: 13)
        
        return numberLabel
    }()
    
    private lazy var plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(ServingStepper.plusImage, for: .normal)
        plusButton.tintColor = Constant.secondaryColor
        
        return plusButton
    }()
    
    private lazy var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.layer.cornerRadius = 5
        containerStackView.layer.borderWidth = 0.5
        containerStackView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        containerStackView.clipsToBounds = true
        
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 5
        
        return containerStackView
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
        if sender.currentImage == ServingStepper.minusImage {
            if value <= minValue {
                value = minValue
            } else { value -= 1 }
        } else if sender.currentImage == ServingStepper.plusImage {
            if value >= maxValue {
                value = maxValue
            } else { value += 1 }
        }
        delegate?.didMinButtonSelected(value)
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
