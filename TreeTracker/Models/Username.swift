//
//  Username.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

enum Username {
    case email(String)
    case phoneNumber(String)
}

// MARK: - Validation
extension Username {

    enum UsernameValidationError: Error {
        case emailInvalid
        case phoneNumberInvalid
        case empty
    }

    var isValid: Validation.Result {
        switch self {
        case .email(let email):
            return Validation.validate(email, type: .email)
        case .phoneNumber(let phoneNumber):
            return Validation.validate(phoneNumber, type: .phoneNumber)
        }
    }

    var value: String {
        switch self {
        case .email(let email):
            return email
        case .phoneNumber(let phoneNumber):
            return phoneNumber
        }
    }
}
