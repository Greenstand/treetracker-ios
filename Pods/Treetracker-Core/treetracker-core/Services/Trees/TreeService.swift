//
//  TreeService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public struct TreeServiceData {

    let jpegData: Data
    let location: Location
    let uuid: String

    public init(jpegData: Data, location: Location, uuid: String) {
        self.jpegData = jpegData
        self.location = location
        self.uuid = uuid
    }
}

// MARK: - Errors
public enum TreeServiceError: Swift.Error {
    case planterError
    case identificationError
    case documentStorageError
}

public protocol TreeService {
    func saveTree(treeData: TreeServiceData, forPlanter: Planter, completion: (Result<Tree, Error>) -> Void)
}

class LocalTreeService: TreeService {

    private let coreDataManager: CoreDataManaging
    private let documentManager: DocumentManaging

    init(coreDataManager: CoreDataManaging, documentManager: DocumentManaging) {
        self.coreDataManager = coreDataManager
        self.documentManager = documentManager
    }

    func saveTree(treeData: TreeServiceData, forPlanter planter: Planter, completion: (Result<Tree, Error>) -> Void) {

        guard let planter = planter as? PlanterDetail else {
            completion(.failure(TreeServiceError.planterError))
            return
        }

        guard let latestPlanterIdentification = planter.latestIdentification as? PlanterIdentification else {
            completion(.failure(TreeServiceError.identificationError))
            return
        }

        guard let photoPath = try? documentManager.store(data: treeData.jpegData, withFileName: treeData.uuid).get() else {
            completion(.failure(TreeServiceError.documentStorageError))
            return
        }

        let treeCapture = TreeCapture(context: coreDataManager.viewContext)
        treeCapture.createdAt = Date()
        treeCapture.horizontalAccuracy = treeData.location.horizontalAccuracy
        treeCapture.latitude = treeData.location.latitude
        treeCapture.longitude = treeData.location.longitude
        treeCapture.uploaded = false
        treeCapture.localPhotoPath = photoPath
        treeCapture.uuid = treeData.uuid

        latestPlanterIdentification.addToTrees(treeCapture)

        do {
            try coreDataManager.viewContext.save()
            completion(.success(treeCapture))
        } catch {
            completion(.failure(error))
        }
    }
}
