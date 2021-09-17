//
//  LocationDataRequest.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

struct LocationDataRequest: Encodable {
    let planterCheckInId: String
    let latitude: Double
    let longitude: Double
    let accuracy: Double
    let treeUUID: String
    let convergenceStatus: String
    let capturedAt: TimeInterval
}
