//
//  BundleUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol BundleUploadService {
    func upload(bundle: UploadBundle, completion: @escaping (Result<String, Error>) -> Void)
}

class AWSS3BundleUploadService: BundleUploadService {

    private let s3Client: AWSS3Client

    init(s3Client: AWSS3Client) {
        self.s3Client = s3Client
    }

    func upload(bundle: UploadBundle, completion: @escaping (Result<String, Error>) -> Void) {

        guard let jsonData = bundle.jsonData else {
            completion(.failure(BundleUploadServiceError.jsonStringEncodingError))
            return
        }

        s3Client.uploadBundle(jsonBundle: jsonData.jsonString, bundleId: jsonData.bundleId) { (result) in
            completion(result)
        }
    }
}

// MARK: - Errors
extension AWSS3BundleUploadService {
    enum BundleUploadServiceError: Error {
        case jsonStringEncodingError
    }
}
