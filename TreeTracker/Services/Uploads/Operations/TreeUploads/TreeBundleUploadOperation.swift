//
//  TreeBundleUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TreeBundleUploadOperation: Operation {

    private let trees: [Tree]
    private let treeUploadService: TreeUploadService

    init(trees: [Tree], treeUploadService: TreeUploadService) {
        self.trees = trees
        self.treeUploadService = treeUploadService
    }

    override func main() {
        Logger.log("TREE UPLOAD: TreeBundleUploadOperation: Started")
        do {
            try treeUploadService.uploadDataBundle(forTrees: trees)
        } catch {
            cancel()
        }
    }
}
