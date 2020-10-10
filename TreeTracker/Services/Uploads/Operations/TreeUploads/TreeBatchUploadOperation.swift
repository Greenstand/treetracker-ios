//
//  TreeBatchUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TreeBatchUploadOperation: Operation {

    private let trees: [Tree]
    private let treeUploadService: TreeUploadService
    private lazy var treeBatchUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "TreeBatchUploadQueue"
        return queue
    }()

    init(trees: [Tree], treeUploadService: TreeUploadService) {
        self.trees = trees
        self.treeUploadService = treeUploadService
    }

    override func main() {

        let imageUploadOperation = TreeBatchImagesUploadOperation(
            trees: trees,
            treeUploadService: treeUploadService
        )

        let treeBundleUploadOperation = TreeBundleUploadOperation(
            trees: trees,
            treeUploadService: treeUploadService
        )
        treeBundleUploadOperation.addDependency(imageUploadOperation)

        let deleteTreeImagesOperation = DeleteTreeImagesOperation(
            trees: trees,
            treeUploadService: treeUploadService
        )
        deleteTreeImagesOperation.addDependency(treeBundleUploadOperation)

        treeBatchUploadQueue.addOperations(
            [
                imageUploadOperation,
                treeBundleUploadOperation,
                deleteTreeImagesOperation
            ],
            waitUntilFinished: true
        )
    }

    override func cancel() {
        super.cancel()
        treeBatchUploadQueue.cancelAllOperations()
    }
}
