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
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("favoriteRecipes").path!
    }
    
    var favoriteRecipes : [Recipe] {
        if let recipes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String] {
            var recipesArray = [Recipe]()
            print(recipesArray)
            for recipeId in recipes {
                FoodForkRecipes.sharedInstance.getRecipeFromId(recipeId, completionHandler: { (success, recipeResults, error) in
                    if success {
                        recipesArray.append(recipeResults)
                        print(recipesArray)
                    }
                })
            }
            
            return recipesArray
            
        }
        else {
            return [Recipe]()
        }
    }
    
    
    func saveFavoriteRecipes(recipeID: String) {
        
        var recipes = [String]()
        
        if let favoriteRecipes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String]{
            recipes = favoriteRecipes
        }
        
        recipes.append(recipeID)
        
        NSKeyedArchiver.archiveRootObject(recipes, toFile: filePath)
        
        print("recipe was saved!!!")
        
    }
    
}