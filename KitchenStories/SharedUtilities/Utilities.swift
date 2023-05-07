//
//  Utilities.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import UIKit

struct Utilities {
    static func changeViewControllerRoot(to newRootVc: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = UINavigationController(rootViewController: newRootVc)
            window.makeKeyAndVisible()
        }, completion: nil)
    }
    
    
    static func getTextViewHeight(
        textSize: CGFloat,
        maxLines: Int,
        desiredText: String? = nil,
        availableWidth: CGFloat,
        removePadding: Bool = true
    ) -> CGFloat {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: availableWidth, height: .greatestFiniteMagnitude))
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        if removePadding {
            textView.removePadding()
        }
        
        textView.font = .systemFont(ofSize: textSize)
        textView.text = desiredText != nil ? desiredText : "A"
        textView.textContainer.maximumNumberOfLines = maxLines
        textView.sizeToFit()
        var measuredHeight = textView.frame.height
        if desiredText == nil && maxLines != 0 {
            measuredHeight *= CGFloat(maxLines)
        }

        return measuredHeight
    }
    
    static func getLabelHeight(
        textSize: CGFloat,
        maxLines: Int,
        desiredText: String? = nil,
        availableWidth: CGFloat
    ) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: availableWidth, height: .greatestFiniteMagnitude))
        
        label.font = .systemFont(ofSize: textSize)
        label.text = desiredText != nil ? desiredText : "A"
        label.numberOfLines = maxLines
        label.sizeToFit()
        var measuredHeight = label.frame.height
        if desiredText == nil && maxLines != 0 {
            measuredHeight *= CGFloat(maxLines)
        }

        return measuredHeight
    }
    
    static func cleanStringFromUrl(string: String) -> String {
        if let attributedString = try? NSAttributedString(
            data: string.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) {
            let cleanedString = attributedString.string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            return cleanedString
        }
        
        return string
    }
    
    static func recipeDetailController(recipe: RecipeModel) -> UIViewController {
        let viewController: UIViewController
        if var recipesOfRecipe = recipe.recipes,
            recipesOfRecipe.count > 0 {
            recipesOfRecipe.insert(recipe, at: 0)
            let recipesOfRecipeVc = RecipesOfRecipeViewController(recipes: recipesOfRecipe)
            recipesOfRecipeVc.title = recipe.name
            
            viewController = recipesOfRecipeVc
        } else {
            let recipeDetailVC = RecipeDetailViewController(recipeId: recipe.id)
            recipeDetailVC.title = recipe.name
            
            viewController = recipeDetailVC
        }
        
        return viewController
    }
}
