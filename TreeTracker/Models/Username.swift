//
//  Username.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct Username {
    let email: String
    let phoneNumber: String
}

// MARK: - Validation
extension Username {

    enum UsernameValidationError: Error {
        case emailInvalid
        case phoneNumberInvalid
        case empty
    }

    enum UsernameValidationResult {
        case valid
        case invalid(UsernameValidationError)
    }

    var isValid: UsernameValidationResult {

        switch (emailValid, phoneNumberValid) {
        case (.valid, .valid),
             (.valid, .empty),
             (.empty, .valid):
            return .valid
        case (.invalid, _):
            return .invalid(.emailInvalid)
        case (_, .invalid):
            return .invalid(.phoneNumberInvalid)
        case (.empty, .empty):
            return .invalid(.empty)
        }
    }

    var emailValid: Validation.Result {
        return Validation.validate(email, type: .email)
    }

    var phoneNumberValid: Validation.Result {
        return Validation.validate(phoneNumber, type: .phoneNumber)
    }
}
