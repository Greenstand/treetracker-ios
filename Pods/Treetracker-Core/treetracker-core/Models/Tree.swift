//
//  Tree.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public protocol Tree: AnyObject {
    var createdAt: Date? { get set }
    var horizontalAccuracy: Double { get set }
    var latitude: Double { get }
    var localPhotoPath: String? { get set }
    var longitude: Double { get set }
    var noteContent: String? { get set }
    var photoURL: String? { get set }
    var uploaded: Bool { get set }
    var uuid: String? { get set }
    var bundleId: String? { get set }
    var planterCheckIn: PlanterCheckIn? { get }
}

extension TreeCapture: Tree {
    public var planterCheckIn: PlanterCheckIn? {
        return planterIdentification
    }
}
