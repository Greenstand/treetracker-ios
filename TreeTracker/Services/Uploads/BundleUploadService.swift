//
//  BundleUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol BundleUploadService {
    func upload(withRequest bundleUploadRequest: UploadBundleRequest, completion: @escaping (Result<String, Error>) -> Void)
}

class AWSS3BundleUploadService: BundleUploadService {

    private let s3Client: AWSS3Client

    init(s3Client: AWSS3Client) {
        self.s3Client = s3Client
    }

    func upload(withRequest bundleUploadRequest: UploadBundleRequest, completion: @escaping (Result<String, Error>) -> Void) {
        s3Client.uploadBundle(jsonBundle: bundleUploadRequest.jsonString, bundleId: bundleUploadRequest.bundleId) { (result) in
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
