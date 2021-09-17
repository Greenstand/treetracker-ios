//
//  UploadManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public protocol UploadManagerDelegate: AnyObject {
    func uploadManagerDidStartUploadingTrees(_ uploadManager: UploadManaging)
    func uploadManagerDidStopUploadingTrees(_ uploadManager: UploadManaging)
    func uploadManager(_ uploadManager: UploadManaging, didError error: Error)
}

public protocol UploadManaging: AnyObject {
    var delegate: UploadManagerDelegate? { get set }
    func startUploading(currentPlanter: Planter)
    func stopUploading()
    var isUploading: Bool { get }
}

class UploadManager: UploadManaging {

    public weak var delegate: UploadManagerDelegate?

    private let treeUploadService: TreeUploadService
    private let planterUploadService: PlanterUploadService
    private let locationDataUploadService: LocationDataUploadService

    private(set) public var isUploading: Bool = false
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
        locationDataUploadService: LocationDataUploadService
    ) {
        self.treeUploadService = treeUploadService
        self.planterUploadService = planterUploadService
        self.locationDataUploadService = locationDataUploadService
    }

    func startUploading(currentPlanter: Planter) {

        guard !self.isUploading else {
            return
        }

        Logger.log("UploadManager: Uploads started")
        self.isUploading = true
        self.delegate?.uploadManagerDidStartUploadingTrees(self)

        let uploadOperation = UploadOperation(
            planterUploadService: self.planterUploadService,
            treeUploadService: self.treeUploadService,
            locationDataUploadService: self.locationDataUploadService,
            planter: currentPlanter
        )

        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                Logger.log("UploadManager: Uploads complete")
                self.finishUploading()
            }
        }
        finishOperation.addDependency(uploadOperation)

        self.uploadOperationQueue.addOperations(
            [
                uploadOperation,
                finishOperation
            ],
            waitUntilFinished: false
        )
    }

    func stopUploading() {
        guard self.isUploading else {
            return
        }
        Logger.log("UploadManager: Uploads stopped")
        self.uploadOperationQueue.cancelAllOperations()
        self.finishUploading()
    }
}

private extension UploadManager {

    func finishUploading() {
        self.isUploading = false
        self.delegate?.uploadManagerDidStopUploadingTrees(self)
    }
}
