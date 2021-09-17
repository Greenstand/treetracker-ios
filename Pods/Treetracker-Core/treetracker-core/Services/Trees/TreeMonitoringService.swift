//
//  TreeMonitoringService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CoreData

public protocol TreeMonitoringServiceDelegate: AnyObject {
    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didUpdateTrees trees: [Tree])
    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didError error: Error)
}

public protocol TreeMonitoringService: AnyObject {
    var delegate: TreeMonitoringServiceDelegate? { get set }
    func startMonitoringTrees(forPlanter planter: Planter)
}

// MARK: - Errors
enum TreeMonitoringServiceError: Swift.Error {
    case missingPlanterID
}

class LocalTreeMonitoringService: NSObject, TreeMonitoringService {

    weak var delegate: TreeMonitoringServiceDelegate?

    private var fetchedResultsController: NSFetchedResultsController<TreeCapture>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func startMonitoringTrees(forPlanter planter: Planter) {

        guard let planterID = planter.identifier else {
            delegate?.treeMonitoringService(self, didError: TreeMonitoringServiceError.missingPlanterID)
            return
        }

        let dateSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        let predicate = NSPredicate(
            format: "planterIdentification.planter.identifier == %@", planterID
        )

        let fetchRequest: NSFetchRequest<TreeCapture> = TreeCapture.fetchRequest()
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        fetchRequest.predicate = predicate

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            try fetchedResultsController?.performFetch()

            guard let trees = fetchedResultsController?.fetchedObjects else {
                return
            }

            delegate?.treeMonitoringService(self, didUpdateTrees: trees)

        } catch {
            delegate?.treeMonitoringService(self, didError: error)
        }

    }
}

extension LocalTreeMonitoringService: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        guard let trees = controller.fetchedObjects?.compactMap({ $0 as? TreeCapture }) else {
            return
        }

        delegate?.treeMonitoringService(self, didUpdateTrees: trees)
    }
}
