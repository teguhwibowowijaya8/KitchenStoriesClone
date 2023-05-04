//
//  RecipeTipTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 30/04/23.
//

import UIKit

struct RecipeTipCellParams {
    let totalTipsCount: Int
    let topTipImageUrl: String
    let topTipName: String
    let topTipDescription: String
}

class RecipeTipTableViewCell: UITableViewCell {
    static let identifier = "RecipeTipTableViewCell"
    
    private let defaultTopTipImage = UIImage(systemName: "person")
    
    private var getNetworkImageService = GetNetworkImageService()
    
    @IBOutlet weak var tipsTitleLabel: UILabel! {
        didSet {
            tipsTitleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var topTipImageView: UIImageView! {
        didSet {
            topTipImageView.layer.cornerRadius = topTipImageView.bounds.width / 2
            topTipImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var topTipLabel: UILabel! {
        didSet {
            topTipLabel.text = "Top Tip"
            topTipLabel.font = .systemFont(ofSize: 14)
            topTipLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var topTipNameLabel: UILabel! {
        didSet {
            topTipNameLabel.font = .boldSystemFont(ofSize: 16)
            topTipNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var topTipDescriptionTextView: UITextView! {
        didSet {
            topTipDescriptionTextView.font = .systemFont(ofSize: 14)
            topTipDescriptionTextView.contentInset = .zero
            topTipDescriptionTextView.textContainerInset = .zero
        }
    }
    
    @IBOutlet weak var showAllTipsButton: UIButton! {
        didSet {
            showAllTipsButton.tintColor = Constant.secondaryColor
            showAllTipsButton.setTitle("See all tips and photo >", for: .normal)
            showAllTipsButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        getNetworkImageService.cancel()
    }
    
    func setupCell(
        recipeTopTip: RecipeTipCellParams?,
        isLoading: Bool
    ) {
        if isLoading {
            showLoadingView()
            return
        }
        
        if let recipeTopTip = recipeTopTip {
            removeLoadingView()
            
            if recipeTopTip.totalTipsCount == 1 {
                showAllTipsButton.isHidden = true
            }
            
            topTipImageView.loadImageFromUrl(
                recipeTopTip.topTipImageUrl,
                defaultImage: defaultTopTipImage,
                getImageNetworkService: getNetworkImageService
            )
            
            tipsTitleLabel.attributedText = tipsTitleText(with: recipeTopTip.totalTipsCount)
            topTipNameLabel.text = recipeTopTip.topTipName
            topTipDescriptionTextView.text = recipeTopTip.topTipDescription
        }
    }
    
    private func tipsTitleText(with tipsCount: Int) -> NSAttributedString {
        let tipsTitleAttributedText = NSMutableAttributedString(
            string: "Tips",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
        )
        
        let tipsCountAttributedText = NSAttributedString(
            string: "(\(tipsCount))",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18)
            ]
        )
        
        tipsTitleAttributedText.append(tipsCountAttributedText)
        
        return tipsTitleAttributedText
    }
    
    private func showLoadingView() {
        tipsTitleLabel.text = "Tips"
        tipsTitleLabel.textColor = .clear
        tipsTitleLabel.backgroundColor = Constant.loadingColor
        
        topTipImageView.image = nil
        topTipImageView.backgroundColor = Constant.loadingColor
        
        topTipLabel.textColor = .clear
        topTipLabel.backgroundColor = Constant.loadingColor
        
        topTipNameLabel.textColor = .clear
        topTipNameLabel.text = Constant.placholderText1
        topTipNameLabel.backgroundColor = Constant.loadingColor
        
        topTipDescriptionTextView.text = Constant.placholderText2
        topTipDescriptionTextView.textColor = .clear
        topTipDescriptionTextView.backgroundColor = Constant.loadingColor
        
        showAllTipsButton.tintColor = .clear
        showAllTipsButton.isUserInteractionEnabled = false
        showAllTipsButton.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        tipsTitleLabel.textColor = .label
        tipsTitleLabel.backgroundColor = .clear
        
        topTipImageView.backgroundColor = .clear
        
        topTipLabel.textColor = .label
        topTipLabel.backgroundColor = .clear
        
        topTipNameLabel.textColor = .label
        topTipNameLabel.text = ""
        topTipNameLabel.backgroundColor = .clear
        
        topTipDescriptionTextView.text = ""
        topTipDescriptionTextView.textColor = .label
        topTipDescriptionTextView.backgroundColor = .clear
        
        showAllTipsButton.tintColor = Constant.secondaryColor
        showAllTipsButton.isUserInteractionEnabled = true
        showAllTipsButton.backgroundColor = .clear
    }
}
