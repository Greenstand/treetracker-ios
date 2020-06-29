//
//  LoginService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class LoginService {

    typealias Result = Swift.Result<State, Error>

    enum State {
        case loggedIn
    }

    enum Error: Swift.Error {
        case unknownUser(Username)
        case sessionTimedOut
        case generalError
    }

    func login(withUsername username: Username, compltion: (Result) -> Void) {
        compltion(.failure(.unknownUser(username)))
    }
}
