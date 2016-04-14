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
    
    var recipe: Recipe!
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDel.managedObjectContext
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientsLabel.text = ""
        
        // Get recipe ingredients
        FoodForkRecipes.sharedInstance.getRecipeFromID(recipe.recipeID!) { (success, ingredients, error) in
            if success {
                self.recipe.ingredients = ingredients
                self.ingredientsLabel.text = self.recipe.ingredients!.joinWithSeparator("\n")
            } else {
                self.ingredientsLabel.text = "Unable to load ingredients"
            }
            
            
        }
        
        recipeTitle.text = recipe.title
        
        
        let imageURL = NSURL(string: recipe.imageURL!)
        recipeImage.image = UIImage( data: NSData(contentsOfURL: imageURL!)! )
    }
    
    @IBAction func addIngredientsToList(sender: AnyObject) {
        
        print("Adding this many ingredients to list")
        print(self.recipe.ingredients!.count)
        
        for ingredient in self.recipe.ingredients! {
            insertNewObject(ingredient)
        }
        
        addToListButton.setTitle("Items Added!", forState: .Normal)
        
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
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(ingredient, forKey: "name")
        
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
