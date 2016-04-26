//
//  FoodForkRecipes.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/5/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit
import Alamofire

class FoodForkRecipes {
    
    static let sharedInstance = FoodForkRecipes()
    
    func getRecipeList(page page: Int, completionHandler: (success: Bool, error: String?) -> Void) {
        
        Alamofire.request(.GET, "http://food2fork.com/api/search", parameters: ["key":"46a0a82a9f10b597b08a4b2adb7ca574", "page":page])
            .responseJSON { response in
                
                guard let parsedResult = response.result.value else {
                    completionHandler(success: false, error: "error parsing data")
                    return
                }
                
                guard let recipesArray = parsedResult["recipes"] as? NSArray else {
                    completionHandler(success: false, error: "cannot find recipes key in \(parsedResult)")
                    return
                }
                
                for recipe in recipesArray {
                    let recipe = Recipe(
                        title: recipe["title"] as? String,
                        imageURL: recipe["image_url"] as? String,
                        recipeURL: recipe["source_url"] as? String,
                        recipeID: recipe["recipe_id"] as? String,
                        ingredients: nil, favorite: false
                    )
                    
                    Recipe.allRecipes.append(recipe)
                }
                
                completionHandler(success: true, error: nil)
        }
        
    }
    
    func getRecipeFromId(recipeID: String, completionHandler: (success: Bool, recipeResults: Recipe?, error: String?) -> Void) {
        
        Alamofire.request(.GET, "http://food2fork.com/api/get", parameters: ["key":"46a0a82a9f10b597b08a4b2adb7ca574", "rId":recipeID])
            .responseJSON { response in
                
                guard let parsedResult = response.result.value else {
                    completionHandler(success: false, recipeResults: nil, error: "error parsing data")
                    return
                }
   
                guard let recipeDictionary = parsedResult["recipe"] as? NSDictionary else {
                    completionHandler(success: false, recipeResults: nil, error: "cannot find recipe key in \(parsedResult)")
                    return
                }
                
                let recipe = Recipe(
                    title: recipeDictionary["title"] as? String,
                    imageURL: recipeDictionary["image_url"] as? String,
                    recipeURL: recipeDictionary["source_url"] as? String,
                    recipeID: recipeDictionary["recipe_id"] as? String,
                    ingredients: nil,
                    favorite: false
                )
                
                completionHandler(success: true, recipeResults: recipe, error: nil)
                
            }
        
    }
    
    func getRecipeIngredients(recipeID: String, completionHandler: (success: Bool, ingredients: [String]?, error: String?) -> Void) {
        
        Alamofire.request(.GET, "http://food2fork.com/api/get", parameters: ["key":"46a0a82a9f10b597b08a4b2adb7ca574", "rId":recipeID])
            .responseJSON { response in
                
                guard let parsedResult = response.result.value else {
                    completionHandler(success: false, ingredients: nil, error: "error parsing data")
                    return
                }
            
                guard let recipe = parsedResult["recipe"] as? NSDictionary else {
                    completionHandler(success: false, ingredients: nil, error: "cannot find recipe key in \(parsedResult)")
                    return
                }
                
                guard let ingredientsArray = recipe["ingredients"] as? NSArray else {
                    completionHandler(success: false, ingredients: nil, error: "cannot find ingredient key in \(parsedResult)")
                    return
                }
                
                var ingredients = [String]()
                
                for ingredient in ingredientsArray {
                    ingredients.append(ingredient as! String)
                }

                completionHandler(success: true, ingredients: ingredients, error: nil)
            
        }
        
    }

}
