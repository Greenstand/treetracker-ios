//
//  SignUpService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SignUpService {

    typealias Result = Swift.Result<State, Error>

    struct Details {
        let username: Username
        let name: Name
        let organization: Organization
    }

    enum State {
        case signedUp
    }

    enum Error: Swift.Error {
        case generalError
    }

    func signUp(withDetails signUpDetails: Details, completion: (Result) -> Void) {
        completion(.success(.signedUp))
    }
}
