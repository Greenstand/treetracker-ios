//
//  TermsService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TermsService {

    typealias Result = Swift.Result<State, Error>

    enum State {
        case termsAccepted
    }

    enum Error: Swift.Error {
        case generalError
    }

    func acceptTerms(user: Username, completion: (Result) -> Void) {
        completion(.success(.termsAccepted))
    }
}
