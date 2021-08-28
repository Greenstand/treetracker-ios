//
//  LocationDataService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

// MARK: - Errors
enum LocationDataServiceError: Swift.Error {
    case planterError
    case identificationError
    case missingPlanterCheckInID
    case documentStorageError
}


protocol LocationDataService {
    func addLocation(
        location: Location,
        withConvergenceStatus convergenceStatus: String,
        forTree treeUUID: String,
        planter: Planter,
        completion: ((Result<LocationData, Error>) -> Void)?
    )
}

class LocalLocationDataService: LocationDataService {

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func addLocation(
        location: Location,
        withConvergenceStatus convergenceStatus: String,
        forTree treeUUID: String,
        planter: Planter,
        completion: ((Result<LocationData, Error>) -> Void)?
    ) {
        guard let planter = planter as? PlanterDetail else {
            completion?(.failure(LocationDataServiceError.planterError))
            return
        }

        guard let latestPlanterIdentification = planter.latestIdentification as? PlanterIdentification else {
            completion?(.failure(LocationDataServiceError.identificationError))
            return
        }

        guard let latestPlanterCheckInId = latestPlanterIdentification.uuid else {
            completion?(.failure(LocationDataServiceError.missingPlanterCheckInID))
            return
        }

        let locationData = LocationDataEntity(context: coreDataManager.viewContext)
        locationData.accuracy = location.horizontalAccuracy
        locationData.longitude = location.longitude
        locationData.latitude = location.latitude
        locationData.uploaded = false
        locationData.capturedAt = Date()
        locationData.planterCheckInId = latestPlanterCheckInId
        locationData.treeUUID = treeUUID
        locationData.convergenceStatus = convergenceStatus

        do {
            try coreDataManager.viewContext.save()
            completion?(.success(locationData))
        } catch {
            completion?(.failure(error))
        }
    }
}
