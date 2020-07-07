//
//  CoreDataManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import CoreData

protocol CoreDataManaging {
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
}

class CoreDataManager: CoreDataManaging {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TreeTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
