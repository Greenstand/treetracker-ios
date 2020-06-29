//
//  SignUpService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SignUpService {

    struct Details {
        let username: Username
        let name: Name
        let organization: Organization
    }

    enum Error: Swift.Error {
        case generalError
    }

    func signUp(withDetails signUpDetails: Details, completion: (Result<Username, Error>) -> Void) {
        completion(.success(signUpDetails.username))
    }
}
