//
//  DeviceRequest.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 06/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import UIKit.UIDevice

struct DeviceRequest: Encodable {

    let appVersion: String
    let appBuild: String
    let deviceIdentifier: String
    let model: String
    let hardware: String
    let device: String
    let iOSRelease: String
    let manufacturer: String
    let brand: String
    let iOSSDKVersion: String

    init(
        deviceInfoProvider: DeviceInfoProviding = DeviceInfoProvider(),
        appBundleInfoProvider: AppBundleInfoProviding = AppBundleInfoProvider()
    ) {
        self.appVersion = appBundleInfoProvider.versionNumber
        self.appBuild = appBundleInfoProvider.buildNumber
        self.deviceIdentifier = deviceInfoProvider.deviceId
        self.model = deviceInfoProvider.model
        self.hardware = deviceInfoProvider.machineName
        self.device = deviceInfoProvider.machineName
        self.iOSRelease = deviceInfoProvider.systemVersion
        self.manufacturer = deviceInfoProvider.manufacturer
        self.brand = deviceInfoProvider.manufacturer
        self.iOSSDKVersion = appBundleInfoProvider.sdkVersion
    }

    let serial: String = ""
    let instanceId: String = "" //Firebase instance ID

    private enum CodingKeys: String, CodingKey {
        case deviceIdentifier = "device_identifier"
        case appVersion = "app_version"
        case appBuild = "app_build"
        case manufacturer
        case brand
        case model
        case hardware
        case device
        case serial
        case iOSRelease = "ios_release"
        case iOSSDKVersion = "ios_sdk_version"
        case instanceId
    }
}
