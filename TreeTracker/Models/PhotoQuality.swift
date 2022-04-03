//
//  PhotoQuality.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/04/2022.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import Foundation

enum PhotoQuality: String, CaseIterable {

    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"

    var photoSize: Double {
        switch self {
        case .low:
            return Configuration.TreePhotoImageQualitySettingsOptions.Size.low
        case .medium:
            return Configuration.TreePhotoImageQualitySettingsOptions.Size.medium
        case .high:
            return Configuration.TreePhotoImageQualitySettingsOptions.Size.high
        }
    }

    var compression: Double {
        switch self {
        case .low:
            return Configuration.TreePhotoImageQualitySettingsOptions.Compression.low
        case .medium:
            return Configuration.TreePhotoImageQualitySettingsOptions.Compression.medium
        case .high:
            return Configuration.TreePhotoImageQualitySettingsOptions.Compression.high
        }
    }
}
