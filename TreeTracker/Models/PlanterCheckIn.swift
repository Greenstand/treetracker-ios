//
//  PlanterIdentification.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 07/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

protocol PlanterCheckIn: class {
    var createdAt: Date? { get }
    var uuid: String? { get }
    var localPhotoPath: String? { get }
    var photoURL: String? { get }
    var planterDetail: Planter? { get }
    var trees: NSSet? { get }
}

extension PlanterIdentification: PlanterCheckIn {
    var planterDetail: Planter? {
        return planter
    }
}
