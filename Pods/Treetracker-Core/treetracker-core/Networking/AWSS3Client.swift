//
//  AWSS3Client.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 19/09/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import AWSS3

class AWSS3Client {

    private let configuration: AWSConfiguration

    init(configuration: AWSConfiguration) {
        self.configuration = configuration
    }

    enum AWSS3ClientError: Error {
        case jsonEncodingError
    }

    private lazy var s3Client: AWSS3 = {
        return AWSS3.s3(forKey: Constants.s3ServiceKey)
    }()

    func registerS3CLient() {
        AWSS3.register(with: serviceConfiguration, forKey: Constants.s3ServiceKey)
    }

    func uploadImage(imageData: Data, uuid: String, latitude: Double, logitude: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let key = "\(formattedDate())_\(latitude)_\(logitude)_\(UUID().uuidString)_\(uuid).jpg"
        put(data: imageData, bucketName: configuration.imagesBucketName, key: key, acl: .publicRead, completion: completion)
    }

    func uploadBundle(jsonBundle: String, bundleId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let key = "\(formattedDate())_\(UUID().uuidString)_\(bundleId)"

        guard let jsonData = jsonBundle.data(using: .utf8) else {
            completion(.failure(AWSS3ClientError.jsonEncodingError))
            return
        }

        put(data: jsonData, bucketName: configuration.batchUploadsBucketName, key: key, acl: nil, completion: completion)
    }
}

// MARK: - Private
private extension AWSS3Client {

    var credentialsProvider: AWSCredentialsProvider {
        return AWSCognitoCredentialsProvider(
            regionType: configuration.regionType,
            identityPoolId: configuration.identityPoolId
        )
    }

    var serviceConfiguration: AWSServiceConfiguration {
        return AWSServiceConfiguration(
            region: configuration.regionType,
            credentialsProvider: credentialsProvider
        )
    }

    func formattedDate(forDate date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        return dateFormatter.string(from: date)
    }

    func put(data: Data, bucketName: String, key: String, acl: AWSS3ObjectCannedACL?, completion: @escaping (Result<String, Error>) -> Void) {

        guard let request = AWSS3PutObjectRequest() else {
            return
        }

        request.bucket = bucketName
        request.body = data
        request.key = key
        request.contentLength = NSNumber(value: data.count)

        if let acl = acl {
            request.acl = acl
        }

        s3Client.putObject(request) { (_, error) in

            if let error = error {
                completion(.failure(error))
                return
            }
            let url = "https://\(bucketName).s3.\(self.configuration.regionString).amazonaws.com/\(key)"
            completion(.success(url))
        }
    }
}

// MARK: - Constants
private extension AWSS3Client {
    struct Constants {
        static let s3ServiceKey: String = "treetracker-s3-service"
    }
}

// MARK: - Configuration

public struct AWSConfiguration {

    let identityPoolId: String
    let regionType: AWSRegionType
    let regionString: String
    let imagesBucketName: String
    let batchUploadsBucketName: String

    public init(
        identityPoolId: String,
        regionType: AWSRegionType,
        regionString: String,
        imagesBucketName: String,
        batchUploadsBucketName: String
    ) {
        self.identityPoolId = identityPoolId
        self.regionType = regionType
        self.regionString = regionString
        self.imagesBucketName = imagesBucketName
        self.batchUploadsBucketName = batchUploadsBucketName
    }
}

//// MARK: - Constants
//private extension AWSS3Client {
//
//    struct Constants {
//        static let s3ServiceKey: String = "treetracker-s3-service"
//        static let imagesBucketName: String = Configuration.AWS.imagesBucketName
//        static let batchUploadsBucketName: String = Configuration.AWS.batchUploadsBucketName
//    }
//
//    struct AWSCredentials {
//        static let identityPoolId: String = Configuration.AWS.identityPoolId
//        static let regionType: AWSRegionType = Configuration.AWS.region
//        static let regionString: String = Configuration.AWS.regionString
//    }
//}

