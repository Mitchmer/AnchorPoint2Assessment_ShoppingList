//
//  ItemController.swift
//  ShopList
//
//  Created by Mitch Merrell on 8/9/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    //MARK: Singleton
    
    static let sharedInstance = ItemController()
    
    //MARK: NSFRC
    
    var fetchedResultsController: NSFetchedResultsController<Item>
    
    init() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let resultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error: \(error): \(error.localizedDescription)")
        }
    }
    
    //MARK: CRUD
    
    func createItem(name: String) {
        let _ = Item(name: name)
        
        saveToPersistentStore()
    }
    
    func deleteItem(item: Item) {
        if let moc = item.managedObjectContext {
            moc.delete(item)
            
            saveToPersistentStore()
        }
    }
    
    //MARK: State
    
    func toggleIsComplete(item: Item) {
        item.isComplete.toggle()
        saveToPersistentStore()
    }
    
    //MARK: Persistence
    
    private func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
    
}
