//
//  UploadManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol UploadManagerDelegate: class {
    func uploadManagerDidStartUploadingTrees(_ uploadManager: UploadManager)
    func uploadManagerDidStopUploadingTrees(_ uploadManager: UploadManager)
    func uploadManager(_ uploadManager: UploadManager, didError error: Error)
}

protocol UploadManaging: class {
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
    private(set) var isUploading: Bool = false
    private lazy var uploadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "UploadQueue"
        return queue
    }()

    init(treeUploadService: TreeUploadService, planterUploadService: PlanterUploadService, coredataManager: CoreDataManaging) {
        self.treeUploadService = treeUploadService
        self.planterUploadService = planterUploadService
        self.coredataManager = coredataManager
    }

    func startUploading() {

        guard !isUploading else {
            return
        }

        let planterUploadOperation = PlanterUploadOperation(
            planterUploadService: planterUploadService
        )

        let treeUploadOperation = TreeUploadOperation(
            treeUploadService: treeUploadService
        )
        treeUploadOperation.addDependency(planterUploadOperation)

        let treeLocationsUploadOperation = UploadTreeLocationsOperation(
            treeUploadService: treeUploadService
        )
        treeLocationsUploadOperation.addDependency(treeUploadOperation)

        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                Logger.log("UploadManager: Upload operation complete")
                self.isUploading = false
                self.delegate?.uploadManagerDidStopUploadingTrees(self)
            }
        }
        finishOperation.addDependency(treeLocationsUploadOperation)

        uploadOperationQueue.addOperations(
            [
                planterUploadOperation,
                treeUploadOperation,
                treeLocationsUploadOperation,
                finishOperation
            ],
            waitUntilFinished: false
        )

        Logger.log("UploadManager.startUploading() started")
        isUploading = true
        delegate?.uploadManagerDidStartUploadingTrees(self)
    }

    func stopUploading() {
        guard isUploading else {
            return
        }
        Logger.log("UploadManager.stopUploading()")
        isUploading = false
        uploadOperationQueue.cancelAllOperations()
        delegate?.uploadManagerDidStopUploadingTrees(self)
    }
}
