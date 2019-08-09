//
//  Item+Convenience.swift
//  ShopList
//
//  Created by Mitch Merrell on 8/9/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    @discardableResult
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
        self.isComplete = false
    }
}
