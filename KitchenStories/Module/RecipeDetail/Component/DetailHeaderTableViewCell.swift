//
//  DetailHeaderTableViewCell.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 18/04/23.
//

import UIKit

struct DetailHeaderParams {
    let recipeName: String
    let recipeImageUrlString: String
    var recipeDescription: String?
    var isCommunityRecipe: Bool = false
    var communityMemberName: String?
    var wouldMakeAgainPercentage: Double?
}

class DetailHeaderTableViewCell: UITableViewCell {
    static let identifier = "DetailHeaderTableViewCell"
    
    private let communityWarningText = "This recipe was submited by a Tasty Community Member, and hasn't been tested by the Tasty recipe team."
    
    private var getNetworkService = GetNetworkImageService()
    
    @IBOutlet weak var recipeNameLabel: UILabel! {
        didSet {
            recipeNameLabel.font = .boldSystemFont(ofSize: 22)
            recipeNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var recipeDescriptionTextView: UITextView! {
        didSet {
            recipeDescriptionTextView.font = .systemFont(ofSize: 13)
            recipeDescriptionTextView.contentInset = .zero
            recipeDescriptionTextView.textContainerInset = .zero
        }
    }
    
    @IBOutlet weak var communityMemberStackView: UIStackView!
    
    @IBOutlet weak var communityMemberNameLabel: UILabel! {
        didSet {
            communityMemberNameLabel.font = .boldSystemFont(ofSize: 13)
            communityMemberNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var communityMemberLabel: UILabel! {
        didSet {
            communityMemberLabel.font = .systemFont(ofSize: 13)
            communityMemberLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var recipeFeaturedInLabel: UILabel! {
        didSet {
            recipeFeaturedInLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var wouldMakeAgainStackView: UIStackView!
    
    @IBOutlet weak var wouldMakeAgainImageView: UIImageView! {
        didSet {
            wouldMakeAgainImageView.tintColor = .label
            wouldMakeAgainImageView.image = UIImage(systemName: "hand.thumbsup")
        }
    }
    
    @IBOutlet weak var wouldMakeAgainLabel: UILabel!
    
    @IBOutlet weak var communityRecipeWarningTextView: UITextView! {
        didSet {
            communityRecipeWarningTextView.backgroundColor = .systemBackground.withAlphaComponent(0.3)
            communityRecipeWarningTextView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
            communityRecipeWarningTextView.font = .systemFont(ofSize: 12)
            communityRecipeWarningTextView.textColor = .label
        }
    }
    
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.contentMode = .scaleAspectFill
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
        getNetworkService.cancel()
    }
    
    func setupCell(detail: DetailHeaderParams?, isLoading: Bool) {
        recipeNameLabel.isHidden = true
        recipeFeaturedInLabel.isHidden = true
        recipeDescriptionTextView.isHidden = true
        communityMemberStackView.isHidden = true
        communityMemberNameLabel.isHidden = true
        communityRecipeWarningTextView.isHidden = true
        wouldMakeAgainStackView.isHidden = true
        
        if isLoading {
            showLoadingView()
            return
        }
        
        removeLoadingView()
        if let detail = detail {
            recipeImageView.loadImageFromUrl(detail.recipeImageUrlString, defaultImage: nil, getImageNetworkService: getNetworkService)
            
            if let recipeDescription = detail.recipeDescription {
                recipeDescriptionTextView.text = recipeDescription
                recipeDescriptionTextView.isHidden = false
            }
            
            if detail.isCommunityRecipe {
                communityMemberStackView.isHidden = false
                communityRecipeWarningTextView.isHidden = false
                if let memberName = detail.communityMemberName {
                    communityMemberNameLabel.text = memberName
                    communityMemberNameLabel.isHidden = false
                }
            }
            
            if let wouldMakeAgainPercentage = detail.wouldMakeAgainPercentage {
                wouldMakeAgainLabel.attributedText = wouldMakeAgainText(wouldMakeAgainPercentage)
                
                wouldMakeAgainStackView.isHidden = false
            }
        }
    }
    
    
    private func wouldMakeAgainText(_ percentage: Double) -> NSAttributedString {
        let percentageAttributedText = NSMutableAttributedString(
            string: "\(percentage)%",
            attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13)
        ])
        
        let wouldMakeAgainAttributedText = NSAttributedString(
            string: "would make this again",
            attributes:  [
            .font: UIFont.systemFont(ofSize: 13)
        ])
        
        percentageAttributedText.append(wouldMakeAgainAttributedText)
        
        return percentageAttributedText
    }
    
    private func showLoadingView() {
        recipeDescriptionTextView.isHidden = false
        wouldMakeAgainStackView.isHidden = false
        
        recipeDescriptionTextView.text = Constant.placholderText2
        recipeDescriptionTextView.textColor = .clear
        recipeDescriptionTextView.backgroundColor = Constant.loadingColor
        
        wouldMakeAgainImageView.tintColor = .clear
        wouldMakeAgainLabel.textColor = .clear
        wouldMakeAgainLabel.text = Constant.placholderText1
        wouldMakeAgainStackView.backgroundColor = Constant.loadingColor
        
        recipeImageView.image = nil
        recipeImageView.backgroundColor = Constant.loadingColor
    }
    
    private func removeLoadingView() {
        recipeDescriptionTextView.isHidden = true
        wouldMakeAgainStackView.isHidden = true
        
        recipeDescriptionTextView.text = ""
        recipeDescriptionTextView.textColor = .label
        recipeDescriptionTextView.backgroundColor = .clear
        
        wouldMakeAgainImageView.tintColor = Constant.secondaryColor
        wouldMakeAgainLabel.textColor = .label
        wouldMakeAgainLabel.text = ""
        wouldMakeAgainStackView.backgroundColor = .clear
        
        recipeImageView.backgroundColor = .clear
    }
}
