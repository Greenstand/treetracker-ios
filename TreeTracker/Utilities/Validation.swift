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

    static func isEmailValid(email: String?) -> Result {

        guard isEmpty(text: email) == false else {
            return .empty
        }

        let regex = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@"
            + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
            + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9]))|"
            + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,6})$"

        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)

        guard test.evaluate(with: email) else {
            return .invalid
        }

        return .valid
    }

    static func isPhoneNumberValid(phoneNumber: String?) -> Result {

        guard isEmpty(text: phoneNumber) == false else {
            return .empty
        }

        let regex = "\\d{7,15}"

        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)

        let cleanPhoneNumber = cleanedPhoneNumber(phoneNumber: phoneNumber)

        guard test.evaluate(with: cleanPhoneNumber) else {
            return .invalid
        }

        return .valid
    }
}

// MARK: - Private Functions
private extension Validation {

    static func isEmpty(text: String?) -> Bool {
        guard text != "", text != nil else {
            return true
        }
        return false
    }

    static func cleanedPhoneNumber(phoneNumber: String?) -> String? {
        return phoneNumber?
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
