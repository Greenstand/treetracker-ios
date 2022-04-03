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

    private static func value<T>(for key: Configuration.Key) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
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
    private static var environment: Environment {
        let value: String = try! Configuration.value(for: .environment)
        return Environment(rawValue: value)!
    }

    enum AWS {
        static var imagesBucketName: String {
            return try! Configuration.value(for: .imagesBucketName)
        }

        static var batchUploadsBucketName: String {
            return try! Configuration.value(for: .batchUploadsBucketName)
        }

        static var regionString: String {
            return try! Configuration.value(for: .awsRegion)
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

    enum DefaultTreePhotoImageQuality {

        static var defaultPhotoImageQuality: PhotoQuality {
            let value: String = try! Configuration.value(for: .defaultTreePhotoQuality)
            return PhotoQuality(rawValue: value)!
        }
    }

    enum TreePhotoImageQualitySettingsOptions {

        enum Size {
            static var low: Double {
                return try! Configuration.value(for: .treePhotoSizeLow)
            }
            static var medium: Double {
                return try! Configuration.value(for: .treePhotoSizeMedium)
            }
            static var high: Double {
                return try! Configuration.value(for: .treePhotoSizeHigh)
            }
        }

        enum Compression {
            static var low: Double {
                return try! Configuration.value(for: .treePhotoCompressionLow)
            }
            static var medium: Double {
                return try! Configuration.value(for: .treePhotoCompressionMedium)
            }
            static var high: Double {
                return try! Configuration.value(for: .treePhotoCompressionHigh)
            }
        }
    }
    // swiftlint:enable force_try
}

// MARK: - Nested Types
private extension Configuration {

    enum Key: String {

        case environment = "Environment"

        case imagesBucketName = "AWSS3_BucketName_ImageUploads"
        case batchUploadsBucketName = "AWSS3_BucketName_BundleUploads"
        case awsRegion = "AWS_RegionString"

        case defaultTreePhotoQuality = "DefaultTreePhotoQuality"

        case treePhotoSizeLow = "TreePhotoSizeLow"
        case treePhotoSizeMedium = "TreePhotoSizeMedium"
        case treePhotoSizeHigh = "TreePhotoSizeHigh"

        case treePhotoCompressionLow = "TreePhotoCompressionLow"
        case treePhotoCompressionMedium = "TreePhotoCompressionMedium"
        case treePhotoCompressionHigh = "TreePhotoCompressionHigh"
    }

    enum Environment: String {
        case dev = "DEV"
        case test = "TEST"
        case production = "PRODUCTION"
    }

    enum ConfigurationError: Error {
        case missingKey
        case invalidValue
    }
}
