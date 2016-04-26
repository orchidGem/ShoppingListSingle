//
//  FavoriteRecipes.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/15/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import Foundation

class FavoriteRecipes: NSObject {
    
    static let sharedInstance = FavoriteRecipes()
    
    var favoriteRecipes = [Recipe]()
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("favoriteRecipes").path!
    }
    
    var favoriteRecipeIds : [String]? {
        if let recipes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String] {
            return recipes
        }
        else {
            return [String]()
        }
    }
    
    func fetchFavoriteRecipes() {
        if let recipes = FavoriteRecipes.sharedInstance.favoriteRecipeIds {
            for recipeId in recipes {
                FoodForkRecipes.sharedInstance.getRecipeFromId(recipeId, completionHandler: { (success, recipeResults, error) in
                    if success {
                        self.favoriteRecipes.append(recipeResults)

                    }
                })
            }
        }
    }
    
    
    func addToFavorites(recipe: Recipe) {
        
        self.favoriteRecipes.append(recipe)
        
        var recipes = [String]()
        
        if let favoriteRecipes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String]{
            recipes = favoriteRecipes
        }
        
        recipes.append(recipe.recipeID!)
        NSKeyedArchiver.archiveRootObject(recipes, toFile: filePath)
        
    }
    
    func removeFromFavorites(recipe: Recipe) {
        
        for (index,faveRecipe) in favoriteRecipes.enumerate() {
            if faveRecipe.recipeID == recipe.recipeID {
                favoriteRecipes.removeAtIndex(index)
            }
        }
        
        var recipes = [String]()
        
        if let favoriteRecipes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String]{
            recipes = favoriteRecipes
        }
        
        if let index = recipes.indexOf(recipe.recipeID!){
            recipes.removeAtIndex(index)
        }
        
        NSKeyedArchiver.archiveRootObject(recipes, toFile: filePath)
        
    }
    
    func removeAllRecipes() {
        var recipes = [String]()
        if let _ = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String]{
            recipes.removeAll()
        }
        NSKeyedArchiver.archiveRootObject(recipes, toFile: filePath)
    }
    
}