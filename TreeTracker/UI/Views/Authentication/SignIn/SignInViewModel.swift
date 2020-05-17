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

    var phoneNumberValid: Bool {
        return Validation.isValidPhoneNumber(phoneNumber: phoneNumber)
    }

    var emailValid: Bool {
        return Validation.isEmailValid(email: email)
    }
}
