//
//  FoodForkRecipes.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/5/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit

class FoodForkRecipes {
    
    static let sharedInstance = FoodForkRecipes()
    
    func getRecentRecipes(completionHandler: (success: Bool, recipeData: [Recipe], error: String?) -> Void) {
        
        let session  = NSURLSession.sharedSession()
        let url = NSURL(string: "http://food2fork.com/api/search?key=46a0a82a9f10b597b08a4b2adb7ca574")
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            // GAURD: was there an error?
            guard (error == nil) else {
                print("there was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            //print(parsedResult)
            
            guard let recipesArray = parsedResult["recipes"] as? NSArray else {
                print("cannot find recipes key in \(parsedResult)")
                return
            }
            
            var recipesDictionary = [Recipe]()
            
            for recipe in recipesArray {
                let recipe = Recipe(title: recipe["title"] as! String, imageURL: recipe["image_url"] as! String, recipeID: recipe["recipe_id"] as! String, ingredients: nil)
                recipesDictionary.append(recipe)
            }
            
            completionHandler(success: true, recipeData: recipesDictionary, error: nil)
            
        }
        
        task.resume()
        
    } // End of getRecentRecipes function
    
    
    func getRecipeFromID(recipeID: String, completionHandler: (success: Bool, ingredients: [String], error: String?) -> Void) {
        
        let session  = NSURLSession.sharedSession()
        let url = NSURL(string: "http://food2fork.com/api/get?key=46a0a82a9f10b597b08a4b2adb7ca574&rId=\(recipeID)")
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            // GAURD: was there an error?
            guard (error == nil) else {
                print("there was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let recipe = parsedResult["recipe"] as? NSDictionary else {
                print("cannot find recipe key in \(parsedResult)")
                return
            }
            
            guard let ingredientsArray = recipe["ingredients"] as? NSArray else {
                print("cannot find ingredient key in \(parsedResult)")
                return
            }
            
            var ingredients = [String]()
            
            for ingredient in ingredientsArray {
                ingredients.append(ingredient as! String)
            }
            
            
            completionHandler(success: true, ingredients: ingredients, error: nil)
            
        }
        
        task.resume()
        
    }

    
}
