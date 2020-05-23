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

    func showSignUp() {
        configuration.navigationController.pushViewController(
            signUpViewController,
            animated: true
        )
    }

    func showTerms() {
        configuration.navigationController.pushViewController(
            termsViewController,
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
        viewController.viewModel = SignInViewModel()
        viewController.delegate = self
        return viewController
    }

    var signUpViewController: UIViewController {
        let viewController = StoryboardScene.SignUp.initialScene.instantiate()
        viewController.viewModel = SignUpViewModel()
        viewController.delegate = self
        return viewController
    }

    var termsViewController: UIViewController {
        let viewController = StoryboardScene.Terms.initialScene.instantiate()
        viewController.viewModel = TermsViewModel()
        viewController.delegate = self
        return viewController
    }
}

// MARK: - SignInViewControllerDelegate
 extension SignInCoordinator: SignInViewControllerDelegate {

    func signInViewControllerDidSelectLogin(_ signInViewController: SignInViewController) {
        showLoggedIn()
    }

    func signInViewControllerDidSelectSignUp(_ signInViewController: SignInViewController) {
        showSignUp()
    }
}

// MARK: - SignUpViewControllerDelegate
extension SignInCoordinator: SignUpViewControllerDelegate {

    func signUpViewControllerDidSignUp(_ signUpViewController: SignUpViewController) {
        showTerms()
    }
}

// MARK: - TermsViewControllerDelegate
extension SignInCoordinator: TermsViewControllerDelegate {

    func termsViewControllerDidAcceptTerms(_ termsViewController: TermsViewController) {
        showLoggedIn()
    }
}
