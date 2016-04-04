//
//  ShoppingItem.swift
//  ShoppingListSingle
//
//  Created by Laura Evans on 3/28/16.
//  Copyright © 2016 Ivie. All rights reserved.
//

import CoreData

class ShoppingItem: NSManagedObject {
    @NSManaged var name: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("ShoppingItem", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
}
