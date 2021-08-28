//
//  ClearTreeLocationsOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

class ClearTreeLocationsOperation: Operation {

    private let locationDataUploadService: LocationDataUploadService

    init(locationDataUploadService: LocationDataUploadService) {
        self.locationDataUploadService = locationDataUploadService
    }

    override func main() {
        Logger.log("TREE LOCATION DELETION: ClearTreeLocationsOperation: Started")
        do {
            try locationDataUploadService.clearUploadedLocations()
        } catch {
            cancel()
        }
    }
}
