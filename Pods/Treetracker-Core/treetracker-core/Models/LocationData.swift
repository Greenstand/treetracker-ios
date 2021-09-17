//
//  LocationData.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

public enum ConvergenceStatus: String {
    case converged = "CONVERGED"
    case notConverged = "NOT_CONVERGED"
    case timedOut = "TIMED_OUT"
}

public protocol LocationData {
    var uploaded: Bool { get }
    var capturedAt: Date? { get }
    var convergenceStatus: String? { get }
    var planterCheckInId: String? { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var accuracy: Double { get }
    var treeUUID: String? { get }
}

extension LocationDataEntity: LocationData { }
