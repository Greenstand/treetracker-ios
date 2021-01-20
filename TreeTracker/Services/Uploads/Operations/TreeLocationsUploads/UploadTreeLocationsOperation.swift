//
//  UploadTreeLocationsOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class UploadTreeLocationsOperation: Operation {

    private let treeUploadService: TreeUploadService

    init(treeUploadService: TreeUploadService) {
        self.treeUploadService = treeUploadService
    }
    override func main() {
        Logger.log("LOCATION UPLOAD: UploadTreeLocationsOperation: Started")
        treeUploadService.uploadTreeLocations()
    }
}
