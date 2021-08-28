//
//  UploadManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol UploadManagerDelegate: AnyObject {
    func uploadManagerDidStartUploadingTrees(_ uploadManager: UploadManager)
    func uploadManagerDidStopUploadingTrees(_ uploadManager: UploadManager)
    func uploadManager(_ uploadManager: UploadManager, didError error: Error)
}

protocol UploadManaging: AnyObject {
    var delegate: UploadManagerDelegate? { get set }
    func startUploading()
    func stopUploading()
    var isUploading: Bool { get }
}

class UploadManager: UploadManaging {

    weak var delegate: UploadManagerDelegate?

    private let coredataManager: CoreDataManaging
    private let treeUploadService: TreeUploadService
    private let planterUploadService: PlanterUploadService
    private let locationDataUploadService: LocationDataUploadService

    private(set) var isUploading: Bool = false
    private lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "UploadManagerQueue"
        return queue
    }()

    init(
        treeUploadService: TreeUploadService,
        planterUploadService: PlanterUploadService,
        locationDataUploadService: LocationDataUploadService,
        coredataManager: CoreDataManaging
    ) {
        self.treeUploadService = treeUploadService
        self.planterUploadService = planterUploadService
        self.locationDataUploadService = locationDataUploadService
        self.coredataManager = coredataManager
    }

    func startUploading() {

        guard !isUploading else {
            return
        }

        Logger.log("UploadManager: Uploads started")
        isUploading = true
        delegate?.uploadManagerDidStartUploadingTrees(self)

        let uploadOperation = UploadOperation(
            planterUploadService: planterUploadService,
            treeUploadService: treeUploadService,
            locationDataUploadService: locationDataUploadService
        )

        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                Logger.log("UploadManager: Uploads complete")
                self.stopUpoading()
            }
        }
        finishOperation.addDependency(uploadOperation)

        uploadOperationQueue.addOperations(
            [
                uploadOperation,
                finishOperation
            ],
            waitUntilFinished: false
        )
    }

    func stopUploading() {
        guard isUploading else {
            return
        }
        Logger.log("UploadManager: Uploads stopped")
        uploadOperationQueue.cancelAllOperations()
        stopUpoading()
    }
}

private extension UploadManager {

    func stopUpoading() {
        isUploading = false
        delegate?.uploadManagerDidStopUploadingTrees(self)
    }
}
