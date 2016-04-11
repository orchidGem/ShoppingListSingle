//
//  RecipesListViewController.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit
import CoreData

class RecipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipesTableView: UITableView!
    
    var recipes = [Recipe]()
//    let allRecipes = [
//    
//        Recipe(title: "Turkery Sausage Sliders", imageURL: "https://photo.foodgawker.com/wp-content/uploads/2016/04/2623949.jpg", recipeID: nil, ingredients: ["Breakfast Sausage", "8 Eggs", "1/2 cup almond milk", "pepper", "salt", "8 Kings Hawaiin rolls"]),
//        Recipe(title: "Lemon Thyme Sidecar", imageURL: "https://photo2.foodgawker.com/wp-content/uploads/2016/04/2624247.jpg", recipeID: nil, ingredients: ["1 Tbsp lemon juice", "1/4 cupe cognac", "1 Tbsp triple sec", "Sugar", "1 Lemon Wedge", "Simple Syrup"]),
//        
//        Recipe(title: "Fatoush Salad", imageURL: "https://photo.foodgawker.com/wp-content/uploads/2016/04/2624609.jpg", recipeID: nil, ingredients: ["Cucumbers", "Tomatoes", "Lettuce", "Sweet Corn", "Sumac", "Parsley"]),
//        
//        Recipe(title: "Salted Toffee Cookie Bars", imageURL: "https://photo2.foodgawker.com/wp-content/uploads/2016/04/2624441.jpg", recipeID: nil, ingredients: ["Butter", "Sugar", "Brown Sugar", "Flour", "Vanilla", "Salt"]),
//        
//    ]
    
    let favoriteRecipes = [
        
        Recipe(title: "Lemon Thyme Sidecar", imageURL: "https://photo2.foodgawker.com/wp-content/uploads/2016/04/2624247.jpg", recipeID: nil, ingredients: ["1 Tbsp lemon juice", "1/4 cupe cognac", "1 Tbsp triple sec", "Sugar", "1 Lemon Wedge", "Simple Syrup"]),
        
        Recipe(title: "Salted Toffee Cookie Bars", imageURL: "https://photo2.foodgawker.com/wp-content/uploads/2016/04/2624441.jpg", recipeID: nil, ingredients: ["Butter", "Sugar", "Brown Sugar", "Flour", "Vanilla", "Salt"]),
        
        ]
    
    
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        //recipes = allRecipes
        
        
        // Fetch Recipes
        FoodForkRecipes.sharedInstance.getFoodForkRequest() { (success, recipesDictionary, errorString) in
            
            if success {
                
                self.recipes = recipesDictionary
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.recipesTableView.reloadData()
                })
                
            } else {
                print("error with recipe request")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

    }
    
    // MARK: Actions
    
    // Toggle Recipes for All and Favorites
//    @IBAction func toggleRecipes(sender: AnyObject) {
//        if sender.selectedSegmentIndex == 0 { // ALL
//            
//            recipes = allRecipes
//            
//            
//        } else { // Favorites
//            
//            recipes = favoriteRecipes
//            
//        }
//        
//        recipesTableView.reloadData()
//    }
//    
    
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath)
        
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.title

        //cell.imageView!.image = image;
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let recipe = recipes[indexPath.row]
        
        let recipeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController
        recipeDetailViewController.recipe = recipe
        
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }

}
