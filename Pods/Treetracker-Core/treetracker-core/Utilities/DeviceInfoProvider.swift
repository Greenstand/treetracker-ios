//
//  DeviceInfoProvider.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 07/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import UIKit.UIDevice

protocol DeviceInfoProviding {
    var deviceId: String { get }
    var manufacturer: String { get }
    var model: String { get }
    var systemVersion: String { get }
    var machineName: String { get }
}

struct DeviceInfoProvider: DeviceInfoProviding {

    var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    var manufacturer: String {
        return "Apple"
    }

    var model: String {
        return UIDevice.current.model
    }

    var machineName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
}
