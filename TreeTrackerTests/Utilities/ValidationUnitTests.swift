//
//  ValidationUnitTests.swift
//  TreeTrackerTests
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import XCTest
@testable import TreeTracker

class ValidationUnitTests: XCTestCase {

    // MARK: - Email Validation
    func testEmailValidation_Valid() {

        //Given
        let sut = Validation.self
        let emails = [
            //From https://en.wikipedia.org/wiki/Email_address

            //Not supporting:
            //"disposable.style.email.with+symbol@example.com",
            //"user.name+tag+sorting@example.com", //(may go to user.name@example.com inbox depending on mail server)
            //"admin@mailserver1", //(local domain name with no TLD, although ICANN highly discourages dotless email addresses[13])
            //"example@s.example", //(see the List of Internet top-level domains)
            //"\" \"@example.org", //(space between the quotes)
            //"\"john..doe\"@example.org", //(quoted double dot)
            //"mailhost!username@example.org", //(bangified host route used for uucp mailers)
            //"user%example.com@example.org" //(% escaped mail route to user@example.com via example.org)

            "simple@example.com",
            "very.common@example.com",
            "other.email-with-hyphen@example.com",
            "fully-qualified-domain@example.com",
            "x@example.com", //(one-letter local-part)
            "example-indeed@strange-example.com",
            "simple@example.ab",
            "simple@example.abc",
            "simple@example.abcd",
            "simple@example.abcde",
            "simple@example.abcdef"
        ]

        //Then
        for email in emails {
            XCTAssertTrue(sut.isEmailValid(email: email), "Email: \(email)")
        }
    }

    func testEmailValidation_Invalid() {

        //Given
        let sut = Validation.self
        let emails = [
            //From https://en.wikipedia.org/wiki/Email_address
            "plainaddress",
            "@example.com",
            "Joe Smith <email@example.com>",
            "Abc.example.com", //(no @ character)
            "A@b@c@example.com", //(only one @ is allowed outside quotation marks)
            "a\"b(c)d,e:f;g<h>i[j\\k]l@example.com", //(none of the special characters in this local-part are allowed outside quotation marks)
            "just\"not\"right@example.com", //(quoted strings must be dot separated or the only element making up the local-part)
            "this is\"not\\allowed@example.com", //(spaces, quotes, and backslashes may only exist when within quoted strings and preceded by a backslash)
            "this\\ still\"not\\allowed@example.com", //(even if escaped (preceded by a backslash), spaces, quotes, and backslashes must still be contained by quotes)
            "1234567890123456789012345678901234567890123456789012345678901234+x@example.com" //(local part is longer than 64 characters)
        ]

        //Then
        for email in emails {
            XCTAssertFalse(sut.isEmailValid(email: email), "Email: \(email)")
        }
    }

    // MARK: - Phone Number Validation
    func testPhoneNUmberValidation_Valid() {

        //Given
        let numbers = [
            "01234556789", //Valid
            "+012 34-55678(9)" //Valid & needs cleaning
        ]
        let sut = Validation.self

        //Then
        for number in numbers {
            XCTAssertTrue(sut.isValidPhoneNumber(phoneNumber: number), "Number: \(number)")
        }
    }

    func testPhoneNUmberValidation_InValid() {

        //Given
        let numbers = [
            "Not a phone number", //Words
            "012345567890123456789", //Too long
            "+(01)2345567-890123 456789" //Too long & needs cleaning
        ]
        let sut = Validation.self

        //Then
        for number in numbers {
            XCTAssertFalse(sut.isValidPhoneNumber(phoneNumber: number), "Number: \(number)")
        }
    }
}
