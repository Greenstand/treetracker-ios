//
//  TreeImageUploadOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 14/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TreeImageUploadOperation: Operation {

    private let tree: Tree
    private let treeUploadService: TreeUploadService
    //private var awsUploadTask

    init(tree: Tree, treeUploadService: TreeUploadService) {
        self.tree = tree
        self.treeUploadService = treeUploadService
    }

    override func main() {
        Logger.log("TREE UPLOAD: TreeImageUploadOperation: Started")
        do {
            try treeUploadService.uploadImage(forTree: tree)
        } catch {
            cancel()
        }
    }

    override func cancel() {
        super.cancel()
        //Cancel AWSUploadTask
    }
}
