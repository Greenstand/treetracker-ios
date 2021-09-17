//
//  LocationDataUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import CoreData

protocol LocationDataUploadService {
    func uploadTreeLocations(completion: @escaping (Result<String?, Error>) -> Void)
    func clearUploadedLocations() throws
}

// MARK: - Errors
enum LocationDataUploadServiceError: Error {
    case locationDataFetchError
    case bundleCreationError
    case invalidPlanterData
}

class LocalLocationDataUploadService: LocationDataUploadService {

    private let coreDataManager: CoreDataManaging
    private let bundleUploadService: BundleUploadService

    init(
        coreDataManager: CoreDataManaging,
        bundleUploadService: BundleUploadService
    ) {
        self.coreDataManager = coreDataManager
        self.bundleUploadService = bundleUploadService
    }

    func uploadTreeLocations(completion: @escaping (Result<String?, Error>) -> Void) {
        Logger.log("TREE LOCATION UPLOAD: Uploading locations")

        guard let locations = coreDataManager.perform(fetchRequest: locationsToUpload) else {
            Logger.log("TREE LOCATION UPLOAD: LocationDataUploadServiceError.locationFetchError")
            completion(.failure(LocationDataUploadServiceError.locationDataFetchError))
            return
        }

        let requests: [LocationDataRequest] = locations.compactMap(\.request)

        guard requests.count > 0 else {
            Logger.log("TREE LOCATION UPLOAD: No locations to upload")
            completion(.success(nil))
            return
        }

        let uploadBundle = TreeLocationUploadBundle(locations: requests)

        bundleUploadService.upload(bundle: uploadBundle) { (result) in
            switch result {
            case .success(let url):
                locations
                    .filter({ $0.request != nil })
                    .forEach { location in
                        location.uploaded = true
                        self.coreDataManager.saveContext()
                    }
                Logger.log("TREE LOCATION UPLOAD: Location upload success")
                completion(.success(url))
            case .failure(let error):
                Logger.log("TREE LOCATION UPLOAD ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func clearUploadedLocations() throws {

        guard let locations = coreDataManager.perform(fetchRequest: locationsToDelete) else {
            Logger.log("TREE LOCATION UPLOAD: LocationDataUploadServiceError.locationFetchError")
            throw LocationDataUploadServiceError.locationDataFetchError
        }

        locations.forEach { location in
            location.prepareForDeletion()
            coreDataManager.viewContext.delete(location)
            coreDataManager.saveContext()
        }
    }
}

// MARK: - Private
private extension LocalLocationDataUploadService {

    var locationsToUpload: NSFetchRequest<LocationDataEntity> {
        let fetchRequest: NSFetchRequest<LocationDataEntity> = LocationDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uploaded == false")
        return fetchRequest
    }

    var locationsToDelete: NSFetchRequest<LocationDataEntity> {
        let fetchRequest: NSFetchRequest<LocationDataEntity> = LocationDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uploaded == true")
        return fetchRequest
    }

}

// MARK: - LocationData Extension
private extension LocationDataEntity {

    var request: LocationDataRequest? {

        guard let planterCheckInId = self.planterCheckInId,
              let treeUUID = self.treeUUID,
              let capturedAt = self.capturedAt,
              let convergenceStatus = self.convergenceStatus else {
            return nil
        }

        return LocationDataRequest(
            planterCheckInId: planterCheckInId,
            latitude: self.latitude,
            longitude: self.longitude,
            accuracy: self.accuracy,
            treeUUID: treeUUID,
            convergenceStatus: convergenceStatus,
            capturedAt: capturedAt.timeIntervalSince1970
        )
    }

}
