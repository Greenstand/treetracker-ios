//
//  NewTreeRequest.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 06/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct NewTreeRequest: Encodable {

    let userId: Int
    let uuid: String
    let latitude: Double
    let longitude: Double
    let gpsAccuracy: Double
    let note: String
    let timestamp: TimeInterval
    let imgeURL: String
    let sequenceId: Double
    let deviceIdentifier: String
    let planterPhotoUrl: String
    let planterIdentifier: String
    let attributes: [AttributeRequest]?

    struct AttributeRequest: Encodable {
        let key: String
        let value: String
    }

    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case uuid
        case latitude = "lat"
        case longitude = "lon"
        case gpsAccuracy = "gps_accuracy"
        case note
        case timestamp
        case imgeURL = "image_url"
        case sequenceId = "sequence_id"
        case deviceIdentifier = "device_identifier"
        case planterPhotoUrl = "planter_photo_url"
        case planterIdentifier = "planter_identifier"
        case attributes
    }
}
