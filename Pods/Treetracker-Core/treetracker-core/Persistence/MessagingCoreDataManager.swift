//
//  MessagingCoreDataManager.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 18/09/2023.
//

import CoreData

class MessagingCoreDataManager: CoreDataManaging {

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: MessagingCoreDataManager.self)
        return makePersistentContainer(modelName: "Messaging", bundle: bundle)
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
