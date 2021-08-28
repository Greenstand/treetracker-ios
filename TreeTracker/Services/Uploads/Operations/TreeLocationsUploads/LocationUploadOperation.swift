//
//  LocationUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

class LocationUploadOperation: Operation {

    private let locationDataUploadService: LocationDataUploadService

    private lazy var locationUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "LocationUploadQueue"
        return queue
    }()

    init(locationDataUploadService: LocationDataUploadService) {
        self.locationDataUploadService = locationDataUploadService
    }

    override func main() {

        Logger.log("LOCATION UPLOAD: LocationUploadOperation: Started")

        let uploadTreeLocationsOperation = UploadTreeLocationsOperation(
            locationDataUploadService: locationDataUploadService
        )

        let clearTreeLocationsOperation = ClearTreeLocationsOperation(
            locationDataUploadService: locationDataUploadService
        )
        clearTreeLocationsOperation.addDependency(uploadTreeLocationsOperation)

        locationUploadQueue.addOperations(
            [
                uploadTreeLocationsOperation,
                clearTreeLocationsOperation
            ],
            waitUntilFinished: true
        )
    }

    override func cancel() {
        super.cancel()
        locationUploadQueue.cancelAllOperations()
    }
}
