//
//  CoreDataStack.swift
//  Foodie
//
//  Created by Nathan Hedgeman on 2/3/20.
//  Copyright © 2020 Nathan Hedgeman. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private init() { }
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Foodie")
        container.loadPersistentStores() { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data Stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { return container.viewContext }
}
