//
//  SignInCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SignInCoordinatorDelegate: class {
    func signInCoordinator(_ signInCoordinator: SignInCoordinator, didSignInPlanter planter: Planter)
}

class SignInCoordinator: Coordinator {

    weak var delegate: SignInCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    let configuration: CoordinatorConfigurable
    let coreDataManager: CoreDataManaging

    required init(configuration: CoordinatorConfigurable, coreDataManager: CoreDataManaging) {
        self.configuration = configuration
        self.coreDataManager = coreDataManager
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

    func showTerms(planter: Planter) {
        configuration.navigationController.pushViewController(
            termsViewController(planter: planter),
            animated: true
        )
    }

    func showSelfie(planter: Planter) {
        configuration.navigationController.pushViewController(
            selfieViewController(planter: planter),
            animated: true
        )
    }

    func signUpComplete(planter: Planter) {
        delegate?.signInCoordinator(self, didSignInPlanter: planter)
    }
}

// MARK: - View Controllers
private extension SignInCoordinator {

    var signInViewController: UIViewController {
        let viewController = StoryboardScene.SignIn.initialScene.instantiate()
        viewController.viewModel = {
            let loginService = LocalLoginService(coreDataManager: coreDataManager)
            let viewModel = SignInViewModel(loginService: loginService)
             viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func signUpViewController(username: Username) -> UIViewController {
        let viewController = StoryboardScene.SignUp.initialScene.instantiate()
        viewController.viewModel = {
            let localSignUpService = LocalSignUpService(
                coreDataManager: coreDataManager
            )
            let viewModel = SignUpViewModel(
                username: username,
                signUpService: localSignUpService
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func termsViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Terms.initialScene.instantiate()
        viewController.viewModel = {
            let termsService = LocalTermsService(
                coreDataManager: coreDataManager
            )
            let viewModel = TermsViewModel(
                planter: planter,
                termsService: termsService
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func selfieViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Selfie.initialScene.instantiate()
        viewController.viewModel = {
            let selfieService = LocalSelfieService(
                coreDataManager: coreDataManager,
                documentManager: DocumentManager()
            )
            let viewModel = SelfieViewModel(
                planter: planter,
                selfieService: selfieService
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }
}

// MARK: - SignInViewControllerDelegate
extension SignInCoordinator: SignInViewModelCoordinatorDelegate {

    func signInViewModel(_ signInViewModel: SignInViewModel, didLoginPlanter planter: Planter) {
        // Unhide nav bar is a bit of a hack here - should be handled better
        configuration.navigationController.setNavigationBarHidden(false, animated: false)
        signUpComplete(planter: planter)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithExpiredSession planter: Planter) {
        showSelfie(planter: planter)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithUnknownUser username: Username) {
        showSignUp(username: username)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithRequiredTerms planter: Planter) {
        showTerms(planter: planter)
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didFailLoginWithSelfieRequired planter: Planter) {
        showSelfie(planter: planter)
    }
}

// MARK: - SignUpViewControllerDelegate
extension SignInCoordinator: SignUpViewModelCoordinatorDelegate {

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didSignUpWithusername planter: Planter) {
        showTerms(planter: planter)
    }
}

// MARK: - TermsViewControllerDelegate
extension SignInCoordinator: TermsViewModelCoordinatorDelegate {

    func termsViewModel(_ termsViewModel: TermsViewModel, didAcceptTermsForPlanter planter: Planter) {
        showSelfie(planter: planter)
    }
}

// MARK: - SelfieViewControllerDelegate
extension SignInCoordinator: SelfieViewModelCoordinatorDelegate {

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didTakeSelfieForPlanter planter: Planter) {
        signUpComplete(planter: planter)
    }
}
