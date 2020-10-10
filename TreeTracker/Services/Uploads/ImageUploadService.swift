//
//  ImageUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 22/09/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct ImageUploadRequest {
    let jpegData: Data
    let latitude: Double
    let longitude: Double
    let uuid: String
}

protocol ImageUploadService {
    func uploadImage(request: ImageUploadRequest, completion: @escaping (Result<String, Error>) -> Void)
}

class AWSS3ImageUploadService: ImageUploadService {

    private let s3Client: AWSS3Client

    init(s3Client: AWSS3Client) {
        self.s3Client = s3Client
    }

    func uploadImage(request: ImageUploadRequest, completion: @escaping (Result<String, Error>) -> Void) {
        s3Client.uploadImage(imageData: request.jpegData, uuid: request.uuid, latitude: request.latitude, logitude: request.longitude) { (result) in
            completion(result)
        }
    }
}
