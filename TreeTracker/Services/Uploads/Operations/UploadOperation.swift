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

    private lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "UploadQueue"
        return queue
    }()

    init(planterUploadService: PlanterUploadService, treeUploadService: TreeUploadService) {
        self.planterUploadService = planterUploadService
        self.treeUploadService = treeUploadService
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

        let treeLocationsUploadOperation = UploadTreeLocationsOperation(
            treeUploadService: treeUploadService
        )
        treeLocationsUploadOperation.addDependency(treeUploadOperation)

        uploadOperationQueue.addOperations(
            [
                planterUploadOperation,
                treeUploadOperation,
                treeLocationsUploadOperation
            ],
            waitUntilFinished: true
        )
    }

    override func cancel() {
        super.cancel()
        uploadOperationQueue.cancelAllOperations()
    }
}
