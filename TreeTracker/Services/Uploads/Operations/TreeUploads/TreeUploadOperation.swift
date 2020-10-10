//
//  TreeUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CoreData

class TreeUploadOperation: Operation {

    private let treeUploadService: TreeUploadService
    private lazy var treeUploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "TreeUploadQueue"
        return queue
    }()

    init(treeUploadService: TreeUploadService) {
        self.treeUploadService = treeUploadService
    }

    override func main() {

        guard let trees = treeUploadService.treesToUpload else {
            cancel()
            return
        }

        let operations = trees.chunked(into: 5).map { (trees) -> TreeBatchUploadOperation in
            return TreeBatchUploadOperation(
                trees: trees,
                treeUploadService: treeUploadService
            )
        }

        treeUploadQueue.addOperations(operations, waitUntilFinished: true)
    }

    override func cancel() {
        super.cancel()
        treeUploadQueue.cancelAllOperations()
    }
}

// MARK: - Array Extension
private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
