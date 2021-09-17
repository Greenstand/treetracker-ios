//
//  Name.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public struct Name {
    
    let firstName: String
    let lastName: String

    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

// MARK: - Validation
public extension Name {

    enum NameValidationError: Error {
        case firstNameInvalid
        case lastNameInvalid
        case missingFirstName
        case missingLastName
        case empty
    }

    enum NameValidationResult {
        case valid
        case invalid(NameValidationError)
    }

    var isValid: NameValidationResult {
        switch (firstNameValid, lastNameValid) {
        case (.valid, .valid):
            return .valid
        case (.invalid, _):
            return .invalid(.firstNameInvalid)
        case (_, .invalid):
            return .invalid(.lastNameInvalid)
        case (.empty, .empty):
            return .invalid(.empty)
        case (.empty, _):
            return .invalid(.missingFirstName)
        case (_, .empty):
            return .invalid(.missingLastName)
        }
    }

    var firstNameValid: Validation.Result {
        return Validation.validate(firstName, type: .firstName)
    }

    var lastNameValid: Validation.Result {
        return Validation.validate(lastName, type: .lastName)
    }
}
