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

    init(planterIdentification: PlanterIdentification, planterUploadService: PlanterUploadService) {
        self.planterIdentification = planterIdentification
        self.planterUploadService = planterUploadService
    }

    override func main() {
        Logger.log("PLANTER IMAGE UPLOAD: PlanterImageUploadOperation: Started")

        let semaphore = DispatchSemaphore(value: 0)

        planterUploadService.uploadPlanterImage(planterIdentification: planterIdentification) { (result) in
            switch result {
            case .success:
                break
            case .failure:
                self.cancel()
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}
