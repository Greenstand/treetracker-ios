//
//  PlanterImageUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 14/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class PlanterImageUploadOperation: Operation {

    private let planterIdentification: PlanterIdentification
    private let planterUploadService: PlanterUploadService
    //private var awsUploadTask

    init(planterIdentification: PlanterIdentification, planterUploadService: PlanterUploadService) {
        self.planterIdentification = planterIdentification
        self.planterUploadService = planterUploadService
    }

    override func main() {
        Logger.log("PLANTER UPLOAD: PlanterImageUploadOperation: Started")
        do {
            try planterUploadService.uploadPlanterImage(
                planterIdentification: planterIdentification
            )
        } catch {
            cancel()
        }
    }

    override func cancel() {
        super.cancel()
        //Cancel AWSUploadTask
    }
}
