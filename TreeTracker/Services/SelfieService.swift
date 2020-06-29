//
//  SelfieService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SelfieService {

    enum Error: Swift.Error {
        case generalError
    }

    struct Selfie {
        let pngData: Data
    }

    func storeSelfie(selfieImageData data: Selfie, forUser username: Username, completion: (Result<Username, Error>) -> Void) {
        completion(.success(username))
    }
}
