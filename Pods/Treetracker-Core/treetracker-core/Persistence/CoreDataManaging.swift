//
//  CoreDataManaging.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 18/09/2023.
//

import CoreData

public protocol CoreDataManaging {
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
    func perform<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> [T]?
}

extension CoreDataManaging {

    func perform<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch {
            return nil
        }
    }

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func makePersistentContainer(modelName: String, bundle: Bundle) -> NSPersistentContainer {

        guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to load managed object model URL")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load managed object model: \(modelURL)")
        }

        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }
}
