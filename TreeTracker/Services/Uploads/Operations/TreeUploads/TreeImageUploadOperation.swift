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

    init(tree: Tree, treeUploadService: TreeUploadService) {
        self.tree = tree
        self.treeUploadService = treeUploadService
    }

    override func main() {
        Logger.log("TREE IMAGE UPLOAD: TreeImageUploadOperation: Started")

        let semaphore = DispatchSemaphore(value: 0)

        treeUploadService.uploadImage(forTree: tree) { (result) in
            switch result {
            case .success:
                break
            case .failure:
                self.cancel()
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}
