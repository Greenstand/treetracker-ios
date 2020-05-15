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

    var phoneNumberPlaceHolder: String {
        return L10n.SignIn.PhoneNumber.placeholder
    }

    var emailPlaceHolder: String {
        return L10n.SignIn.Email.placeholder
    }

    var phoneNumberValid: Bool {
        return true
    }

    var emailValid: Bool {
        return true
    }
}
