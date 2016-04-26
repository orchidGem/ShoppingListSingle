//
//  RecipeDetailViewController.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    
    var recipe: Recipe!
    var recipeIndex: Int!
    
    // Managed Object for Shopping Items
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.managedObjectContext
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientsLabel.text = ""
        
        let recipe = Recipe.allRecipes[recipeIndex]
        
        recipeTitle.text = recipe.title
        let imageURL = NSURL(string: recipe.imageURL!)
        recipeImage.image = UIImage( data: NSData(contentsOfURL: imageURL!)! )
        
        // Get recipe ingredients
        if let _ = recipe.ingredients {
            self.ingredientsLabel.text = recipe.ingredients!.joinWithSeparator("\n")
            self.activityMonitor.stopAnimating()
            self.activityMonitor.hidden = true
        } else {
            FoodForkRecipes.sharedInstance.getRecipeIngredients(recipe.recipeID!) { (success, ingredients, error) in
                if success {
                    Recipe.allRecipes[self.recipeIndex].ingredients = ingredients
                    self.recipe.ingredients = ingredients
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.ingredientsLabel.text = self.recipe.ingredients!.joinWithSeparator("\n")
                        self.activityMonitor.stopAnimating()
                        self.activityMonitor.hidden = true
                    })
                    
                    
                } else {
                    self.ingredientsLabel.text = "Unable to load ingredients"
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Check if recipe is a favorite recipe
        if FavoriteRecipes.sharedInstance.favoriteRecipeIds!.contains(recipe.recipeID!) {
            favoriteButton.tintColor = UIColor.orangeColor()
            recipe.favorite = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func addRecipeToFavorites(sender: AnyObject) {
        
        // If aleady favorited, remove, otherwise, add
        if recipe.favorite {
            FavoriteRecipes.sharedInstance.removeFromFavorites(recipe)
            recipe.favorite = false
            favoriteButton.tintColor = UIColor.darkGrayColor()
        } else {
            FavoriteRecipes.sharedInstance.addToFavorites(recipe)
            favoriteButton.tintColor = UIColor.orangeColor()
            recipe.favorite = true
        }
    }
    
    @IBAction func addIngredientsToList(sender: AnyObject) {
        
        for ingredient in self.recipe.ingredients! {
            insertNewObject(ingredient)
        }
        
        addToListButton.setTitle("Items Added!", forState: .Normal)
        
    }
    
    @IBAction func viewDirections(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        guard let recipeURL = recipe.recipeURL else {
            return
        }
        app.openURL(NSURL(string: recipeURL)!)
    }
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        // Edit the entity name as appropriate.
        
        fetchRequest.sortDescriptors = []
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    // Add New Shopping List Item
    func insertNewObject(ingredient: String) {
        let context = self.fetchedResultsController.managedObjectContext
        _ = ShoppingItem(name: ingredient, context: context)
        
        // Save the context.
        do {
            try context.save()
        } catch {
            print("unable to save ingredient")
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }
    

}
