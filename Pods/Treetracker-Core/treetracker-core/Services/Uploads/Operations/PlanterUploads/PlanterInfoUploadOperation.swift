//
//  PlanterInfoUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class PlanterInfoUploadOperation: Operation {

    private let planterUploadService: PlanterUploadService

    init(planterUploadService: PlanterUploadService) {
        self.planterUploadService = planterUploadService
    }

    override func main() {
        Logger.log("PLANTER INFO UPLOAD: PlanterInfoUploadOperation: Started")

        let semaphore = DispatchSemaphore(value: 0)

        planterUploadService.uploadPlanterInfo { (result) in
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
