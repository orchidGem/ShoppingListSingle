//
//  Recipe.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 4/6/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

struct Recipe {
    var title: String?
    var imageURL: String?
    var recipeID: String?
    
    init(title: String, imageURL: String, recipeID: String){
        self.title = title
        self.imageURL = imageURL
        self.recipeID = recipeID
    }
}