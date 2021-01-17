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
        let key = "\(formattedDate())_\(latitude)_\(logitude)_\(UUID().uuidString)_\(uuid)"
        put(data: imageData, bucketName: Constants.imagesBucketName, key: key, completion: completion)
    }

    func uploadBundle(jsonBundle: String, bundleId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let key = "\(formattedDate())_\(UUID().uuidString)_\(bundleId)"

        guard let jsonData = jsonBundle.data(using: .utf8) else {
            completion(.failure(AWSS3ClientError.jsonEncodingError))
            return
        }

        put(data: jsonData, bucketName: Constants.batchUploadsBucketName, key: key, completion: completion)
    }
}

// MARK: - Private
private extension AWSS3Client {

    var credentialsProvider: AWSCredentialsProvider {
        return AWSCognitoCredentialsProvider(
            regionType: AWSCredentials.regionType,
            identityPoolId: AWSCredentials.identityPoolId
        )
    }

    var serviceConfiguration: AWSServiceConfiguration {
        return AWSServiceConfiguration(
            region: AWSCredentials.regionType,
            credentialsProvider: credentialsProvider
        )
    }

    func formattedDate(forDate date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        return dateFormatter.string(from: date)
    }

    func put(data: Data, bucketName: String, key: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard let request = AWSS3PutObjectRequest() else {
            return
        }

        request.bucket = bucketName
        request.body = data
        request.key = key
        request.acl = .bucketOwnerRead
        request.contentLength = NSNumber(value: data.count)

        s3Client.putObject(request) { (_, error) in

            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(key))
        }
    }
}

// MARK: - Constants
private extension AWSS3Client {

    struct Constants {
        static let s3ServiceKey: String = "treetracker-s3-service"
        static let imagesBucketName: String = "treetracker-dev-images"
        static let batchUploadsBucketName: String = "treetracker-dev-batch-uploads"
    }

    struct AWSCredentials {
        static let identityPoolId: String = ""
        static let regionType: AWSRegionType = .EUCentral1
    }
}
