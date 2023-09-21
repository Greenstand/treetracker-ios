//
//  CoreDataManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import CoreData

class CoreDataManager: CoreDataManaging {

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataManager.self)
        return makePersistentContainer(modelName: "TreeTracker", bundle: bundle)
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
