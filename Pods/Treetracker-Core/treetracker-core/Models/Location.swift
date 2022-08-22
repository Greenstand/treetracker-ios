//
//  Location.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public protocol Location {
    var latitude: Double { get }
    var longitude: Double { get }
    var altitude: Double { get }
    var horizontalAccuracy: Double { get }
    var verticalAccuracy: Double { get }
}
