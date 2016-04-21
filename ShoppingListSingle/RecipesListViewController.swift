//
//  RecipesListViewController.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

class RecipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipesTableView: UITableView!
    
    var recipes = [Recipe]()
    var allRecipes = [Recipe]()
    var paginationCount = 1
    @IBOutlet weak var toggleRecipesButton: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        //recipes = allRecipes
        
        // Fetch Recipes
        FoodForkRecipes.sharedInstance.getRecipeList(page: paginationCount) { (success, recipesDictionary, errorString) in
            
            if success {
                
                self.allRecipes = recipesDictionary
                self.recipes = self.allRecipes
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.recipesTableView.reloadData()
                })
                
            } else {
                print("error with recipe request")
            }
        }
        
        // Fetch Favorite Recipes
        FavoriteRecipes.sharedInstance.fetchFavoriteRecipes()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        print("view will appear")
        
        if toggleRecipesButton.selectedSegmentIndex == 1 {
            recipes = FavoriteRecipes.sharedInstance.favoriteRecipes
            print("favorites is selected on view will appear. Number of favorites is: ")
            print(FavoriteRecipes.sharedInstance.favoriteRecipes.count)
            recipesTableView.reloadData()
            
        }
    }
    
    // MARK: Actions
    
    //Toggle Recipes for All and Favorites
    @IBAction func toggleRecipes(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 { // ALL
            recipes = allRecipes
            
        } else { // Favorites
            recipes = FavoriteRecipes.sharedInstance.favoriteRecipes
            print("Toggled to Favorites. Number of recipes is: ")
            print(FavoriteRecipes.sharedInstance.favoriteRecipes.count)
        }
        
        recipesTableView.reloadData()
    }
    
    
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell") as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        cell.recipeTitleLabel.text = recipe.title
        cell.recipeImageView.image = UIImage(named: "placeholder")
        
        // Load image asynchronously with AlamoFire
        Alamofire.request(.GET, recipe.imageURL!)
            .responseImage { response in
                
                if let image = response.result.value {
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.recipeImageView.image = image
                    })
                }
        }
        
        return cell
    }
    
    // Load More Recipes if on the last cell
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,     forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 1) == recipes.count {
            
            // If show ALL recipes, load more recipes
            if toggleRecipesButton.selectedSegmentIndex == 0 {
                
                paginationCount+=1
                
                // Load more recipes
                FoodForkRecipes.sharedInstance.getRecipeList(page: paginationCount) { (success, recipesArray, errorString) in
                    
                    if success {
                        
                        for recipe in recipesArray {
                            self.allRecipes.append(recipe)
                        }
                        
                        self.recipes = self.allRecipes
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.recipesTableView.reloadData()
                        })
                        
                    } else {
                        print("error with recipe request")
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let recipe = recipes[indexPath.row]
        
        let recipeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController
 
        recipeDetailViewController.recipe = recipe
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }
    
}
