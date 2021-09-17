//
//  RegistrationRequest.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 06/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct RegistrationRequest: Encodable {

    let planterIdentifier: String
    let firstName: String
    let lastName: String
    let organization: String?
    let phone: String?
    let email: String?
    let latitude: Double?
    let longitude: Double?
    let deviceIdentifier: String
    let recordUUID: String
    let imageURL: String

    private enum CodingKeys: String, CodingKey {
        case planterIdentifier = "planter_identifier"
        case firstName = "first_name"
        case lastName = "last_name"
        case organization
        case phone
        case email
        case latitude = "lat"
        case longitude = "lon"
        case deviceIdentifier = "device_identifier"
        case recordUUID = "record_uuid"
        case imageURL = "image_url"
    }

}
