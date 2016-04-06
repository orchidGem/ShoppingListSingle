//
//  RecipesListViewController.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipesTableView: UITableView!
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        
        print("view did load")
        
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
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
        
        print("view will appear")
        
        super.viewWillAppear(animated)

    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath)
        
        let recipe = recipes[indexPath.row]
        let imageURL = NSURL(string: recipe.imageURL!)
        
        
        cell.textLabel?.text = recipe.title
        cell.imageView?.image = UIImage( data: NSData(contentsOfURL: imageURL!)! )
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let recipe = recipes[indexPath.row]
        
        let recipeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RecipeDetailViewController") as! RecipeDetailViewController
        recipeDetailViewController.recipe = recipe
        
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }

}
