//
//  UploadBundle.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct UploadBundleRequest {
    let jsonString: String
    let bundleId: String
}

struct UploadBundle: Encodable {

    let trees: [NewTreeRequest]?
    let registrations: [RegistrationRequest]?
    let devices: [DeviceRequest] = [DeviceRequest()]

    private var encodedString: String? {
        guard let data = try? JSONEncoder().encode(self),
           let encodedString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return encodedString
    }

    var registrationBundleUploadRequest: UploadBundleRequest? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleRequest(
            jsonString: encodedString,
            bundleId: "\(encodedString.md5)_registrations"
        )
    }

    var treeBundleUploadRequest: UploadBundleRequest? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleRequest(
            jsonString: encodedString,
            bundleId: "\(encodedString.md5)"
        )
    }

    var treeLocationBundleUploadRequest: UploadBundleRequest? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleRequest(
            jsonString: encodedString,
            bundleId: "loc_data\(encodedString.md5)"
        )
    }

}
