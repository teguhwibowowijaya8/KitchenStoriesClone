//
//  RecipeTipTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 30/04/23.
//

import UIKit

class RecipeTipTableViewCell: UITableViewCell {
    static let identifier = "RecipeTipTableViewCell"
    
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
            topTipLabel.font = .systemFont(ofSize: 13)
            topTipLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var topTipNameLabel: UILabel! {
        didSet {
            topTipNameLabel.font = .boldSystemFont(ofSize: 15)
            topTipNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var topTipDescriptionTextView: UITextView! {
        didSet {
            topTipDescriptionTextView.font = .systemFont(ofSize: 13)
            topTipDescriptionTextView.contentInset = .zero
            topTipDescriptionTextView.textContainerInset = .zero
        }
    }
    
    @IBOutlet weak var showAllTipsButton: UIButton! {
        didSet {
            showAllTipsButton.tintColor = Constant.secondaryColor
            showAllTipsButton.setTitle("See all tips and photo >", for: .normal)
            showAllTipsButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
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
    
    func setupCell(totalTipsCount: Int,
                   topTipImageUrl: String,
                   topTipName: String,
                   topTipDescription: String,
                   isLoading: Bool
    ) {
        if isLoading {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        if totalTipsCount == 1 {
            showAllTipsButton.isHidden = true
        }
        
        topTipImageView.loadImageFromUrl(topTipImageUrl, defaultImage: UIImage(systemName: "person"), getImageNetworkService: getNetworkImageService)
        
        tipsTitleLabel.attributedText = tipsTitleText(with: totalTipsCount)
        topTipNameLabel.text = topTipName
        topTipDescriptionTextView.text = topTipDescription
    }
    
    private func tipsTitleText(with tipsCount: Int) -> NSAttributedString {
        let tipsTitleAttributedText = NSMutableAttributedString(
            string: "Tips",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 15)
            ]
        )
        
        let tipsCountAttributedText = NSAttributedString(
            string: "(\(tipsCount))",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15)
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
