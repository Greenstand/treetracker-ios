//
//  SignInViewControllerViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol SignInViewModelCoordinatorDelegate: class {
    func signInViewModelDidLogin(_ signInViewModel: SignInViewModel)
    func signInViewModelFailedLoginWithExpiredSession(_ signInViewModel: SignInViewModel)
    func signInViewModel(_ signInViewModel: SignInViewModel, failedLoginWithUnknownUser username: Username)
}

protocol SignInViewModelViewDelegate: class {
    func signInViewModel(_ signInViewModel: SignInViewModel, didReceiveError error: Error)
    func signInViewModel(_ signInViewModel: SignInViewModel, didValidateEmail result: Validation.Result)
    func signInViewModel(_ signInViewModel: SignInViewModel, didValidatePhoneNumber result: Validation.Result)
    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginEnabled enabled: Bool)
}

class SignInViewModel {

    private let loginService: LoginService

    weak var coordinatorDelegate: SignInViewModelCoordinatorDelegate?
    weak var viewDelegate: SignInViewModelViewDelegate?

    init(loginService: LoginService = LoginService()) {
        self.loginService = loginService
    }

    let title: String = L10n.App.title

    var phoneNumber: String = "" {
        didSet {
            viewDelegate?.signInViewModel(self, didValidatePhoneNumber: phoneNumberValid)
            viewDelegate?.signInViewModel(self, didUpdateLoginEnabled: loginEnabled)
        }
    }

    var email: String = "" {
        didSet {
            viewDelegate?.signInViewModel(self, didValidateEmail: emailValid)
            viewDelegate?.signInViewModel(self, didUpdateLoginEnabled: loginEnabled)
        }
    }

    func login() {

        loginService.login(withUsername: username) {(result) in
            switch result {
            case .success:
                coordinatorDelegate?.signInViewModelDidLogin(self)
            case .failure(let error):
                switch error {
                case .sessionTimedOut:
                    coordinatorDelegate?.signInViewModelFailedLoginWithExpiredSession(self)
                case .unknownUser(let username):
                    coordinatorDelegate?.signInViewModel(self, failedLoginWithUnknownUser: username)
                case .generalError:
                    viewDelegate?.signInViewModel(self, didReceiveError: error)
                }
            }
        }
    }
}

// MARK: - Private
private extension SignInViewModel {

    var username: Username {
        return Username(
            email: email,
            phoneNumber: phoneNumber
        )
    }

    var phoneNumberValid: Validation.Result {
        return username.phoneNumberValid
    }

    var emailValid: Validation.Result {
        return username.emailValid
    }

    var loginEnabled: Bool {
        switch username.isValid {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
}
