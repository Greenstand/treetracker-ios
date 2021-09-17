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
    private let planter: Planter

    init(
        planterUploadService: PlanterUploadService,
        planter: Planter
    ) {
        self.planterUploadService = planterUploadService
        self.planter = planter
    }

    override func main() {
        Logger.log("PLANTER IMAGE DELETION: DeletePlanterImagesOperation: Started")

        do {
            try self.planterUploadService.deleteLocalImagesThatWereUploaded(currentPlanter: self.planter)
        } catch {
            cancel()
        }
    }
}
