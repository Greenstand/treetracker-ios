//
//  Validation.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct Validation {

    static func isEmailValid(email: String) -> Bool {

        let regex = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@"
            + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
            + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
            + "[0-9]{1,2}|25[0-5]|2[0-4][0-9]))|"
            + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,6})$"

        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)

        return test.evaluate(with: email)
    }

    static func isValidPhoneNumber(phoneNumber: String) -> Bool {

        let regex = "\\d{7,15}"

        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)

        let cleanPhoneNumber = cleanedPhoneNumber(phoneNumber: phoneNumber)

        return test.evaluate(with: cleanPhoneNumber)
    }
}

// MARK: - Private Functions
private extension Validation {

    static func cleanedPhoneNumber(phoneNumber: String) -> String {
        return phoneNumber
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
