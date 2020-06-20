//
//  SignUpViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class SignUpViewModel {

    var firstName: String = ""
    var lastName: String = ""
    var organisation: String = ""
    let username: String

    init(username: String) {
        self.username = username
    }

    var title: String {
        return L10n.App.title
    }

    var firstNameValid: Validation.Result {
        return Validation.validate(firstName, type: .firstName)
    }

    var lastNameValid: Validation.Result {
        return Validation.validate(lastName, type: .lastName)
    }

    var organisationValid: Validation.Result {
        return Validation.validate(organisation, type: .organisation)
    }

    var signUpEnabled: Bool {
        switch (firstNameValid, lastNameValid, organisationValid) {
        case (.valid, .valid, .valid),
             (.valid, .valid, .empty):
            return true
        default:
            return false
        }
    }
}
