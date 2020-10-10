//
//  PlanterUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class PlanterUploadOperation: Operation {

    private let planterUploadService: PlanterUploadService
    private lazy var planterUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "PlanterUploadQueue"
        return queue
    }()

    init(planterUploadService: PlanterUploadService) {
        self.planterUploadService = planterUploadService
    }

    override func main() {

        Logger.log("PLANTER UPLOAD: PlanterUploadOperation: Started")

        let planterImagesUploadOperation = PlanterImagesUploadOperation(
            planterUploadService: planterUploadService
        )

        let planterInfoUploadOperation = PlanterInfoUploadOperation(
            planterUploadService: planterUploadService
        )
        planterInfoUploadOperation.addDependency(planterImagesUploadOperation)

        let deletePlanterImagesOperation = DeletePlanterImagesOperation(
            planterUploadService: planterUploadService
        )
        deletePlanterImagesOperation.addDependency(planterInfoUploadOperation)

        planterUploadQueue.addOperations(
            [
                planterImagesUploadOperation,
                planterInfoUploadOperation,
                deletePlanterImagesOperation
            ],
            waitUntilFinished: true
        )
    }

    override func cancel() {
        super.cancel()
        planterUploadQueue.cancelAllOperations()
    }
}
