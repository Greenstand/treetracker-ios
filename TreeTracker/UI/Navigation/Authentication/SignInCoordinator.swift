//
//  SignInCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInCoordinator: Coordinator {

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

    func showTerms() {
        configuration.navigationController.pushViewController(
            termsViewController,
            animated: true
        )
    }

    func showSelfie() {
        configuration.navigationController.pushViewController(
            selfieViewController,
            animated: true
        )
    }

    func showLoggedIn() {
        configuration.navigationController.viewControllers = [
            UIViewController()
        ]

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

    var termsViewController: UIViewController {
        let viewController = StoryboardScene.Terms.initialScene.instantiate()
        viewController.viewModel = TermsViewModel()
        viewController.delegate = self
        return viewController
    }

    var selfieViewController: UIViewController {
        let viewController = StoryboardScene.Selfie.initialScene.instantiate()
        viewController.delegate = self
        viewController.viewModel = SelfieViewModel()
        return viewController
    }
}

// MARK: - SignInViewControllerDelegate
extension SignInCoordinator: SignInViewModelCoordinatorDelegate {

    func signInViewModelDidLogin(_ signInViewModel: SignInViewModel) {
        showLoggedIn()
    }

    func signInViewModelFailedLoginWithExpiredSession(_ signInViewModel: SignInViewModel) {
        showSelfie()
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, failedLoginWithUnknownUser username: Username) {
        showSignUp(username: username)
    }
}

// MARK: - SignUpViewControllerDelegate
extension SignInCoordinator: SignUpViewModelCoordinatorDelegate {

    func signUpViewModelDidSignUp(_ signUpViewModel: SignUpViewModel) {
        showTerms()
    }
}

// MARK: - TermsViewControllerDelegate
extension SignInCoordinator: TermsViewControllerDelegate {

    func termsViewControllerDidAcceptTerms(_ termsViewController: TermsViewController) {
        showSelfie()
    }
}

// MARK: - SelfieViewControllerDelegate
extension SignInCoordinator: SelfieViewControllerDelegate {

    func selfieViewControllerDidStoreSelfie(_ selfieViewController: SelfieViewController) {
        showLoggedIn()
    }
}
