//
//  SignInCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInCoordinator: Coordinator {

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
            initialSignInViewController
        ]
    }

    func showSignUp() {

    }

    func showLogIn() {

    }

    func showTerms() {

    }
}

// MARK: - View Controllers
private extension SignInCoordinator {

    var initialSignInViewController: UIViewController {
        let viewController = StoryboardScene.SignIn.initialScene.instantiate()
        return viewController
    }
}
