//
//  UploadBundle.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct UploadBundleJSONData {
    let jsonString: String
    let bundleId: String
}

protocol UploadBundle: Encodable {
    var jsonData: UploadBundleJSONData? { get }
}

fileprivate extension UploadBundle {

    var encodedString: String? {
        guard let data = try? JSONEncoder().encode(self),
           let encodedString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return encodedString
    }
}

struct RegistrationsUploadBundle: UploadBundle {

    let registrations: [RegistrationRequest]?
    let devices: [DeviceRequest] = [DeviceRequest()]

    var jsonData: UploadBundleJSONData? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleJSONData(
            jsonString: encodedString,
            bundleId: "\(encodedString.md5)_registrations"
        )
    }
}

struct TreeUploadBundle: UploadBundle {

    let trees: [NewTreeRequest]?
    let devices: [DeviceRequest] = [DeviceRequest()]

    var jsonData: UploadBundleJSONData? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleJSONData(
            jsonString: encodedString,
            bundleId: "\(encodedString.md5)"
        )
    }
}

struct TreeLocationUploadBundle: UploadBundle {

    var jsonData: UploadBundleJSONData? {
        guard let encodedString = encodedString else {
            return nil
        }
        return UploadBundleJSONData(
            jsonString: encodedString,
            bundleId: "loc_data\(encodedString.md5)"
        )
    }
}
