//
//  SelfieService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SelfieService {

    typealias Result = Swift.Result<State, Error>

    enum State {
        case selfieStored
    }

    enum Error: Swift.Error {
        case generalError
    }

    func storeSelfie(user: Username, completion: (Result) -> Void) {
        completion(.success(.selfieStored))
    }
}
