//
//  RecipeDetailViewController.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTitle.text = recipe.title
        
        let imageURL = NSURL(string: recipe.imageURL!)
        recipeImage.image = UIImage( data: NSData(contentsOfURL: imageURL!)! )
    }

}
