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
    var wouldMakeAgainPercentage: Int?
}

class DetailHeaderTableViewCell: UITableViewCell {
    static let identifier = "DetailHeaderTableViewCell"
    
    private let communityWarningText = "This recipe was submited by a Tasty Community Member, and hasn't been tested by the Tasty recipe team."
    
    private var getNetworkService = GetNetworkImageService()
    
    @IBOutlet weak var recipeNameLabel: UILabel! {
        didSet {
            recipeNameLabel.font = .boldSystemFont(ofSize: 28)
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
            communityMemberLabel.text = "Community Member"
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
    
    @IBOutlet var communityWarningContainerView: UIView!
    
    @IBOutlet weak var communityRecipeWarningTextView: UITextView! {
        didSet {
            communityRecipeWarningTextView.backgroundColor = .gray.withAlphaComponent(0.3)
            communityRecipeWarningTextView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
            communityRecipeWarningTextView.font = .systemFont(ofSize: 12)
            communityRecipeWarningTextView.textColor = .label
            communityRecipeWarningTextView.text = communityWarningText
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
        recipeFeaturedInLabel.isHidden = true
        recipeDescriptionTextView.isHidden = true
        communityMemberStackView.isHidden = true
        communityMemberNameLabel.isHidden = true
        communityWarningContainerView.isHidden = true
        wouldMakeAgainStackView.isHidden = true
        
        if isLoading {
            showLoadingView()
            return
        }
        
        if let detail = detail {
            removeLoadingView()
            
            recipeImageView.loadImageFromUrl(detail.recipeImageUrlString, defaultImage: nil, getImageNetworkService: getNetworkService)
            
            recipeNameLabel.text = detail.recipeName
            
            if let recipeDescription = detail.recipeDescription,
                recipeDescription != "" {
                recipeDescriptionTextView.text = recipeDescription
                recipeDescriptionTextView.isHidden = false
            }
            
            if detail.isCommunityRecipe {
                communityMemberStackView.isHidden = false
                communityWarningContainerView.isHidden = false
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
    
    
    private func wouldMakeAgainText(_ percentage: Int) -> NSAttributedString {
        let percentageAttributedText = NSMutableAttributedString(
            string: "\(percentage)%",
            attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14)
        ])
        
        let wouldMakeAgainAttributedText = NSAttributedString(
            string: " would make this again",
            attributes:  [
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        percentageAttributedText.append(wouldMakeAgainAttributedText)
        
        return percentageAttributedText
    }
    
    private func showLoadingView() {
        recipeDescriptionTextView.isHidden = false
        wouldMakeAgainStackView.isHidden = false
        
        recipeNameLabel.text = Constant.placholderText1
        recipeNameLabel.textColor = .clear
        recipeNameLabel.backgroundColor = Constant.loadingColor
        
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
        
        recipeNameLabel.textColor = .label
        recipeNameLabel.backgroundColor = .clear
        
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
