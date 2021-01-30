//
//  Configuration.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 26/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import AWSS3
import Keys

enum Configuration {

    enum ConfigurationError: Error {
        case missingKey
        case invalidValue
    }

    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw ConfigurationError.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else {
                fallthrough
            }
            return value
        default:
            throw ConfigurationError.invalidValue
        }
    }

    // swiftlint:disable force_try
    private enum Environment: String {
        case dev = "DEV"
        case test = "TEST"
        case production = "PRODUCTION"
    }

    private static var environment: Environment {
        let value: String = try! Configuration.value(for: "Environment")
        return Environment(rawValue: value)!
    }

    enum AWS {
        static var imagesBucketName: String {
            return try! Configuration.value(for: "AWSS3_BucketName_ImageUploads")
        }

        static var batchUploadsBucketName: String {
            return try! Configuration.value(for: "AWSS3_BucketName_BundleUploads")
        }

        static var regionString: String {
            return try! Configuration.value(for: "AWS_RegionString")
        }

        static var region: AWSRegionType {
            return .EUCentral1
        }

        static var identityPoolId: String {
            switch environment {
            case .dev:
                return TreeTrackerKeys().aWSIdentityPoolId_Dev
            case .test:
                return TreeTrackerKeys().aWSIdentityPoolId_Test
            case .production:
                return TreeTrackerKeys().aWSIdentityPoolId_Prod
            }
        }
    }
    // swiftlint:enable force_try
}
