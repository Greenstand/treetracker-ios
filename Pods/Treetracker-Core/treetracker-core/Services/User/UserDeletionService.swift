//
//  UserDeletionService.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 07/09/2022.
//

import Foundation
import CoreData

public protocol UserDeletionService {
    func deletePlanter(planter: Planter) throws
}

// MARK: - Errors
public enum UserDeletionServiceError: Error {
    case missingPlanterId
    case unknownPlanterId(String)
}

class LocalUserDeletionService: UserDeletionService {

    private let coreDataManager: CoreDataManaging

    public init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func deletePlanter(planter: Planter) throws {

        guard let planterIdentifier = planter.identifier else {
            throw UserDeletionServiceError.missingPlanterId
        }

        let managedObjectContext = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<PlanterDetail> = PlanterDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", planterIdentifier)

        let planterDetails = try managedObjectContext.fetch(fetchRequest)

        guard let planterDetail = planterDetails.first else {
            throw UserDeletionServiceError.unknownPlanterId(planterIdentifier)
        }

        coreDataManager.viewContext.delete(planterDetail)
        coreDataManager.saveContext()
    }
}
