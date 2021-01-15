//
//  PlanterImagesUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class PlanterImagesUploadOperation: Operation {

    private let planterUploadService: PlanterUploadService
    private lazy var treeBatchImagesUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "PlanterImagesUploadQueue"
        return queue
    }()

    init(planterUploadService: PlanterUploadService) {
        self.planterUploadService = planterUploadService
    }

    override func main() {

        Logger.log("PLANTER IMAGE UPLOAD: PlanterImagesUploadOperation: Started")

        guard let planterIdentifications = planterUploadService.planterIdentificationsForUpload else {
            cancel()
            return
        }

        let operations = planterIdentifications.map { (planterIdentification) -> PlanterImageUploadOperation in
            return PlanterImageUploadOperation(
                planterIdentification: planterIdentification,
                planterUploadService: planterUploadService
            )
        }

        treeBatchImagesUploadQueue.addOperations(operations, waitUntilFinished: true)
    }

    override func cancel() {
        super.cancel()
        treeBatchImagesUploadQueue.cancelAllOperations()
    }
}
