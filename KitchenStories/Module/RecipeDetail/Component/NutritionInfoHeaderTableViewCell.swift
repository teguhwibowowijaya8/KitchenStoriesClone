//
//  NutritionInfoHeaderTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 29/04/23.
//

import UIKit

protocol NutritionInfoHeaderCellDelegate {
    /// If the passed parameter 'showInfo' is true, show the list of
    /// nutrition info. And if 'showInfo' is false, hide the list of nutrition info.
    func handleShowNutritionInfo(_ showInfo: Bool)
}

class NutritionInfoHeaderTableViewCell: UITableViewCell {
    static let identifier = "NutritionInfoHeaderTableViewCell"
    
    var delegate: NutritionInfoHeaderCellDelegate?
    
    private var showInfo: Bool? {
        didSet {
//            showNutritionButton.setAttributedTitle(nutritionButtonTitle(), for: .normal)
        }
    }
    
    private lazy var nutritionTitleLabel: UILabel = {
        let nutritionTitleLabel = UILabel()
        nutritionTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        nutritionTitleLabel.numberOfLines = 0
        nutritionTitleLabel.font = .boldSystemFont(ofSize: 18)
        nutritionTitleLabel.text = "Nutrition Info"
        
        return nutritionTitleLabel
    }()
    
    private lazy var showNutritionButton: UIButton = {
        let showNutritionButton = UIButton(type: .system)
        
//        showNutritionButton.setAttributedTitle(nutritionButtonTitle(), for: .normal)
        showNutritionButton.setTitle("Show Info", for: .normal)
        showNutritionButton.setContentHuggingPriority(.required, for: .horizontal)
        showNutritionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        showNutritionButton.addTarget(self, action: #selector(changeShowInfo), for: .touchUpInside)
        
        return showNutritionButton
    }()
    
    private lazy var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
        containerStackView.spacing = 8
        
        return containerStackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func nutritionButtonTitle() -> NSAttributedString {
//        showInfo = showInfo == nil ? false : showInfo
//        let showSymbol: String = showInfo! ? "-" : "+"
//
//        let title = NSAttributedString(
//            string: "View Info \(showSymbol)",
//            attributes: [
//                .font: UIFont.boldSystemFont(ofSize: 13),
//                .foregroundColor: Constant.secondaryColor
//            ]
//        )
//        return title
//    }
    
    @objc func changeShowInfo(_ sender: UIButton) {
        guard let showInfo = showInfo else { return }
        self.showInfo?.toggle()
        delegate?.handleShowNutritionInfo(showInfo)
    }
    
    func setupCell(showInfo: Bool = false, isLoading: Bool) {
        addSubviews()
        setComponentsConstraints()
        
        if isLoading {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        self.showInfo = showInfo
    }
    
    private func addSubviews() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(nutritionTitleLabel)
        containerStackView.addArrangedSubview(showNutritionButton)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            containerStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constant.horizontalSpacing),
            containerStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constant.horizontalSpacing),
            containerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func showLoadingView() {
        nutritionTitleLabel.textColor = .clear
        nutritionTitleLabel.backgroundColor = Constant.loadingColor
        
        showNutritionButton.tintColor = .clear
//        showNutritionButton.setAttributedTitle(nutritionButtonTitle(), for: .normal)
        showNutritionButton.isUserInteractionEnabled = false
        showNutritionButton.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        nutritionTitleLabel.textColor = .label
        nutritionTitleLabel.backgroundColor = .clear
        
        showNutritionButton.tintColor = Constant.secondaryColor
        showNutritionButton.isUserInteractionEnabled = true
        showNutritionButton.backgroundColor = .clear
    }
}
