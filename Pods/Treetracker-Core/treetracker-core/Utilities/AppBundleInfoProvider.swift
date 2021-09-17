//
//  AppBundleInfoProvider.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 07/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

protocol AppBundleInfoProviding {
    var versionNumber: String { get }
    var buildNumber: String { get }
    var sdkVersion: String { get }
}

struct AppBundleInfoProvider: AppBundleInfoProviding {

    var versionNumber: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }

    var buildNumber: String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }

    var sdkVersion: String {
        return "14.3"
    }
}
