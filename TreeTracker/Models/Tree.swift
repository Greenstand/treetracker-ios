//
//  Tree.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol Tree: class {
    var createdAt: Date? { get set }
    var horizontalAccuracy: Double { get set }
    var latitude: Double { get }
    var localPhotoPath: String? { get set }
    var longitude: Double { get set }
    var noteContent: String? { get set }
    var photoURL: String? { get set }
    var uploaded: Bool { get set }
}

extension TreeCapture: Tree { }
