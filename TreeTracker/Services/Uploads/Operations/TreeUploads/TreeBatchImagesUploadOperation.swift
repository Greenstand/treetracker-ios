//
//  TreeBatchImagesUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TreeBatchImagesUploadOperation: Operation {

    private let trees: [Tree]
    private let treeUploadService: TreeUploadService
    private lazy var treeBatchImagesUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "treeBatchImagesUploadQueue"
        return queue
    }()

    init(trees: [Tree], treeUploadService: TreeUploadService) {
        self.trees = trees
        self.treeUploadService = treeUploadService
    }

    override func main() {
        Logger.log("TREE UPLOAD: TreeBatchImagesUploadOperation: Started")

        let operations = trees
            .filter({ $0.photoURL == nil })
            .map { (tree) -> TreeImageUploadOperation in
                return TreeImageUploadOperation(
                    tree: tree,
                    treeUploadService: treeUploadService
                )
            }

        treeBatchImagesUploadQueue.addOperations(operations, waitUntilFinished: true)
    }

    override func cancel() {
        super.cancel()
        treeBatchImagesUploadQueue.cancelAllOperations()
    }
}
