//
//  SignInCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SignInCoordinatorDelegate: class {
    func signInCoordinator(_ signInCoordinator: SignInCoordinator, didSignInUser username: Username)
}

class SignInCoordinator: Coordinator {

    weak var delegate: SignInCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    private let configuration: CoordinatorConfigurable

    required init(configuration: CoordinatorConfigurable) {
        self.configuration = configuration
    }

    func start() {
        showInitialSignIn()
    }
}

// MARK: - Navigation
private extension SignInCoordinator {

    func showInitialSignIn() {
        configuration.navigationController.viewControllers = [
            signInViewController
        ]
    }

    func showSignUp(username: Username) {
        configuration.navigationController.pushViewController(
            signUpViewController(username: username),
            animated: true
        )
    }

    func showTerms(username: Username) {
        configuration.navigationController.pushViewController(
            termsViewController(username: username),
            animated: true
        )
    }

    func showSelfie(username: Username) {
        configuration.navigationController.pushViewController(
            selfieViewController(username: username),
            animated: true
        )
    }

    func signUpComplete(username: Username) {
        delegate?.signInCoordinator(self, didSignInUser: username)
    }
}

// MARK: - View Controllers
private extension SignInCoordinator {

    var signInViewController: UIViewController {
        let viewController = StoryboardScene.SignIn.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = SignInViewModel()
             viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func signUpViewController(username: Username) -> UIViewController {
        let viewController = StoryboardScene.SignUp.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = SignUpViewModel(username: username)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func termsViewController(username: Username) -> UIViewController {
        let viewController = StoryboardScene.Terms.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = TermsViewModel(username: username)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func selfieViewController(username: Username) -> UIViewController {
        let viewController = StoryboardScene.Selfie.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = SelfieViewModel(username: username)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }
}

// MARK: - SignInViewControllerDelegate
extension SignInCoordinator: SignInViewModelCoordinatorDelegate {

    func signInViewModel(_ signInViewModel: SignInViewModel, didLoginUser username: Username) {
        signUpComplete(username: username)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithExpiredSession username: Username) {
        showSelfie(username: username)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithUnknownUser username: Username) {
        showSignUp(username: username)
    }
}

// MARK: - SignUpViewControllerDelegate
extension SignInCoordinator: SignUpViewModelCoordinatorDelegate {

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didSignUpWithusername username: Username) {
        showTerms(username: username)
    }
}

// MARK: - TermsViewControllerDelegate
extension SignInCoordinator: TermsViewModelCoordinatorDelegate {

    func termsViewModel(_ termsViewModel: TermsViewModel, didAcceptTermsForUser username: Username) {
        showSelfie(username: username)
    }
}

// MARK: - SelfieViewControllerDelegate
extension SignInCoordinator: SelfieViewModelCoordinatorDelegate {

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didTakeSelfieForUser username: Username) {
        signUpComplete(username: username)
    }
}
