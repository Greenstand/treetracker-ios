//
//  DeletePlanterImagesOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class DeletePlanterImagesOperation: Operation {

    private let planterUploadService: PlanterUploadService

    init(planterUploadService: PlanterUploadService) {
        self.planterUploadService = planterUploadService
    }

    override func main() {
        Logger.log("PLANTER IMAGE DELETION: DeletePlanterImagesOperation: Started")

        do {
            try planterUploadService.deleteLocalImagesThatWereUploaded()
        } catch {
            cancel()
        }
    }
}
