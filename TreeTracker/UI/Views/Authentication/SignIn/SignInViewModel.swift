//
//  SignInViewControllerViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SignInViewModel {

    var phoneNumber: String = ""
    var email: String = ""

    var title: String {
        return L10n.App.title
    }

    var phoneNumberValid: Validation.Result {
        return Validation.isPhoneNumberValid(phoneNumber: phoneNumber)
    }

    var emailValid: Validation.Result {
        return Validation.isEmailValid(email: email)
    }

    var loginButtonEnabled: Bool {
        switch (phoneNumberValid, emailValid) {
        case (.valid, .valid),
             (.valid, .empty),
             (.empty, .valid):
            return true
        default:
            return false
        }
    }
}
