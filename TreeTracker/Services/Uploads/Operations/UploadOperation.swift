//
//  UploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

class UploadOperation: Operation {

    private let planterUploadService: PlanterUploadService
    private let treeUploadService: TreeUploadService
    private let locationDataUploadService: LocationDataUploadService

    private lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "UploadQueue"
        return queue
    }()

    init(
        planterUploadService: PlanterUploadService,
        treeUploadService: TreeUploadService,
        locationDataUploadService: LocationDataUploadService
    ) {
        self.planterUploadService = planterUploadService
        self.treeUploadService = treeUploadService
        self.locationDataUploadService = locationDataUploadService
    }

    override func main() {

        Logger.log("UPLOAD: UploadOperation: Started")

        let planterUploadOperation = PlanterUploadOperation(
            planterUploadService: planterUploadService
        )

        let treeUploadOperation = TreeUploadOperation(
            treeUploadService: treeUploadService
        )
        treeUploadOperation.addDependency(planterUploadOperation)

        let locationUploadOperation = LocationUploadOperation(
            locationDataUploadService: locationDataUploadService
        )
        locationUploadOperation.addDependency(treeUploadOperation)

        uploadOperationQueue.addOperations(
            [
                planterUploadOperation,
                treeUploadOperation,
                locationUploadOperation
            ],
            waitUntilFinished: true
        )
    }

    override func cancel() {
        super.cancel()
        uploadOperationQueue.cancelAllOperations()
    }
}
