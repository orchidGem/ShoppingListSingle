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
    var paginationCount = 1
    @IBOutlet weak var toggleRecipesButton: UISegmentedControl!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreActivityMonitor: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(recipes.count)
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        activityMonitor.stopAnimating()
        loadMoreActivityMonitor.stopAnimating()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.detectNetworkConnection), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.fetchInitialRecipes), name: "ReachStatusChanged", object: nil)
        
        detectNetworkConnection()
        fetchInitialRecipes()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if toggleRecipesButton.selectedSegmentIndex == 1 {
            recipes = FavoriteRecipes.sharedInstance.favoriteRecipes
            recipesTableView.reloadData()
            
        }
    }
    
    // MARK: Actions
    
    // MARK: Reachability Notification
    func fetchInitialRecipes() {
        
        if reachabilityStatus != kNOTREACHABLE && recipes.count == 0 {
            
            activityMonitor.startAnimating()

            FoodForkRecipes.sharedInstance.getRecipeList(page: paginationCount) { (success,  errorString) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.recipes = Recipe.allRecipes
                        self.recipesTableView.reloadData()
                        self.activityMonitor.stopAnimating()
                    })
                    
                } else {
                    let alertController = UIAlertController(title: nil, message: "Error retrieving recipes: \(errorString)", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in }
                    alertController.addAction(dismissAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
            }
            
            // Fetch Favorite Recipes
            FavoriteRecipes.sharedInstance.fetchFavoriteRecipes()
        } else {
            activityMonitor.stopAnimating()
        }
    }
    
    //Toggle Recipes for All and Favorites
    @IBAction func toggleRecipes(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 { // ALL
            recipes = Recipe.allRecipes
        } else { // Favorites
            recipes = FavoriteRecipes.sharedInstance.favoriteRecipes
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
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 1) == recipes.count && reachabilityStatus != kNOTREACHABLE {
            
            // If show ALL recipes, load more recipes
            if toggleRecipesButton.selectedSegmentIndex == 0 {
                
                loadMoreActivityMonitor.startAnimating()
   
                paginationCount+=1
                
                // Load more recipes
                FoodForkRecipes.sharedInstance.getRecipeList(page: paginationCount) { (success,  errorString) in
                    
                    if success {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.recipes = Recipe.allRecipes
                            self.recipesTableView.reloadData()
                            self.loadMoreActivityMonitor.stopAnimating()
                        })
                        
                    } else {
                        print("error with recipe request")
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let recipeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController
 
        recipeDetailViewController.recipeIndex = indexPath.row
        
        // Determine if in all recipes or favorite recipes
        if toggleRecipesButton.selectedSegmentIndex == 0 {
            recipeDetailViewController.recipeFavorite = false
        } else {
            recipeDetailViewController.recipeFavorite = true
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
}
