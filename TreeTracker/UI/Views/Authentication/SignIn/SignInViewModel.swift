//
//  SignInViewControllerViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol SignInViewModelCoordinatorDelegate: class {
    func signInViewModel(_ signInViewModel: SignInViewModel, didLoginPlanter planter: Planter)
    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithExpiredSession planter: Planter)
    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithUnknownUser username: Username)
    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithRequiredTerms planter: Planter)
    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithSelfieRequired planter: Planter)
}

protocol SignInViewModelViewDelegate: class {
    func signInViewModel(_ signInViewModel: SignInViewModel, didReceiveError error: Error)
    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateValidationState result: Validation.Result)
    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginEnabled enabled: Bool)
    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginType loginType: SignInViewModel.LoginType)
}

class SignInViewModel {

    enum LoginType {
        case phoneNumber
        case email
    }

    weak var coordinatorDelegate: SignInViewModelCoordinatorDelegate?
    weak var viewDelegate: SignInViewModelViewDelegate?

    private let loginService: LoginService

    init(loginService: LoginService) {
        self.loginService = loginService
    }

    let title: String = L10n.SignIn.title

    private var loginType: LoginType = .phoneNumber {
        didSet {
            viewDelegate?.signInViewModel(self, didUpdateLoginType: loginType)
            viewDelegate?.signInViewModel(self, didUpdateValidationState: usernameValid)
            viewDelegate?.signInViewModel(self, didUpdateLoginEnabled: loginEnabled)
        }
    }

    func updateLoginType(loginType: LoginType) {
        self.loginType = loginType
    }

    var usernameValue: String = "" {
        didSet {
            viewDelegate?.signInViewModel(self, didUpdateValidationState: usernameValid)
            viewDelegate?.signInViewModel(self, didUpdateLoginEnabled: loginEnabled)
        }
    }

    func updateUsername(username: String) {
        if loginType == .phoneNumber {
            usernameValue = Validation.cleanedPhoneNumber(phoneNumber: username) }
        else {
            usernameValue = username
        }
    }

    func login() {

        loginService.login(withUsername: username) { (result) in
            switch result {
            case .success(let planter):
                coordinatorDelegate?.signInViewModel(self, didLoginPlanter: planter)
            case .failure(let error):
                switch error {
                case LoginServiceError.sessionTimedOut(let planter):
                    coordinatorDelegate?.signInViewModel(self, didFailLoginWithExpiredSession: planter)
                case LoginServiceError.unknownUser(let username):
                    coordinatorDelegate?.signInViewModel(self, didFailLoginWithUnknownUser: username)
                case LoginServiceError.acceptTermsRequired(let planter):
                    coordinatorDelegate?.signInViewModel(self, didFailLoginWithRequiredTerms: planter)
                case LoginServiceError.selfieRequired(let planter):
                    coordinatorDelegate?.signInViewModel(self, didFailLoginWithSelfieRequired: planter)
                default:
                    viewDelegate?.signInViewModel(self, didReceiveError: error)
                }
            }
        }
    }
}

// MARK: - Private
private extension SignInViewModel {

    var username: Username {
        switch loginType {
        case .email:
            return .email(usernameValue)
        case .phoneNumber:
            return .phoneNumber(usernameValue)
        }
    }

    var usernameValid: Validation.Result {
        return username.isValid
    }

    var loginEnabled: Bool {
        switch username.isValid {
        case .valid:
            return true
        case .invalid, .empty:
            return false
        }
    }
}
