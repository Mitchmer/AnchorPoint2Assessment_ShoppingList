//
//  CoreDataStack.swift
//  ShopList
//
//  Created by Mitch Merrell on 8/9/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShopList")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error): \(error.userInfo)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext{ return container.viewContext }
}
