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
        Logger.log("PLANTER UPLOAD: PlanterInfoUploadOperation: Started")

        do {
            try planterUploadService.uploadPlanterInfo()
        } catch {
            cancel()
        }
    }
}
