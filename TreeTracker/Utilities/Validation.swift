//
//  Validation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct Validation {

    enum Result {
        case valid
        case invalid
        case empty
    }

    enum ValidationType {
        case email
        case phoneNumber
        case firstName
        case lastName
        case organization
    }

    static func validate(_ value: String?, type: ValidationType) -> Result {

        guard let value = value, isEmpty(text: value) == false else {
            return .empty
        }

        switch type {
        case .email:
            return isEmailValid(email: value)
        case .phoneNumber:
            return isPhoneNumberValid(phoneNumber: value)
        case .firstName, .lastName, .organization:
            return .valid
        }
    }
}

// MARK: - Private
private extension Validation {

    static func isEmailValid(email: String) -> Result {
        let regex = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@"
            + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
            + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9]))|"
            + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,6})$"
        return evalute(value: email, regex: regex)
    }

    static func isPhoneNumberValid(phoneNumber: String) -> Result {
        let cleanPhoneNumber = cleanedPhoneNumber(phoneNumber: phoneNumber)
        let regex = "\\d{7,15}"
        return evalute(value: cleanPhoneNumber, regex: regex)
    }

    static func evalute(value: String, regex: String) -> Result {
        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        guard test.evaluate(with: value) else {
            return .invalid
        }
        return .valid
    }

    static func isEmpty(text: String?) -> Bool {
        guard text != "", text != nil else {
            return true
        }
        return false
    }

    static func cleanedPhoneNumber(phoneNumber: String) -> String {
        return phoneNumber
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
