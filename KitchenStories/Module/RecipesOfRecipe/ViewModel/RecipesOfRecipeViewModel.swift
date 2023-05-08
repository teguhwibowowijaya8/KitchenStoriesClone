//
//  RecipesOfRecipeViewModel.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 07/05/23.
//

import Foundation

struct RecipesOfRecipeViewModel {
    let compositions: [RecipesOfRecipeSection]
    var isLoading: Bool = false
    let dummyRecipeParams: RecipesFromRecipeOfCellParams
    
    init() {
        self.compositions = [
            .recipesFromRecipeOf,
            .recipesOfRecipe
        ]
        dummyRecipeParams = RecipesFromRecipeOfCellParams(
            name: "Recipe Title",
            imageUrlString: ""
        )
    }
}
