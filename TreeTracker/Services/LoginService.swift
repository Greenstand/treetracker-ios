//
//  LoginService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class LoginService {

    enum Error: Swift.Error {
        case unknownUser(Username)
        case sessionTimedOut(Username)
        case generalError
    }

    func login(withUsername username: Username, compltion: (Result<Username, Error>) -> Void) {
        compltion(.failure(.unknownUser(username)))
    }
}
