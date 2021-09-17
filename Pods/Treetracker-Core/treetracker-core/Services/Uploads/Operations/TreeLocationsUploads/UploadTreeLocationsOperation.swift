//
//  UploadTreeLocationsOperation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class UploadTreeLocationsOperation: Operation {

    private let locationDataUploadService: LocationDataUploadService

    init(locationDataUploadService: LocationDataUploadService) {
        self.locationDataUploadService = locationDataUploadService
    }

    override func main() {
        Logger.log("LOCATION UPLOAD: UploadTreeLocationsOperation: Started")

        let semaphore = DispatchSemaphore(value: 0)

        locationDataUploadService.uploadTreeLocations { (result) in
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
