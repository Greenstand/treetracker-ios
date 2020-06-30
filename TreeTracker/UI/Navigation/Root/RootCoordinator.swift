//
//  RootCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private let configuration: CoordinatorConfigurable

    required init(configuration: CoordinatorConfigurable) {
        self.configuration = configuration
    }

    func start() {
        showSignIn()
    }
}

// MARK: - Navigation
private extension RootCoordinator {

    func showLoadingViewController() {
        configuration.navigationController.viewControllers = [
            loadingViewController
        ]
    }

    func showSignIn() {
        startCoordinator(coordinator: signInCoordinator)
    }

    func showHome(username: Username) {
        startCoordinator(coordinator: homeCoordinator(username: username))
    }
}

// MARK: - View Controllers
private extension RootCoordinator {

    var loadingViewController: UIViewController {
        return StoryboardScene.Loading.initialScene.instantiate()
    }
}

// MARK: - Child Coordinators
private extension RootCoordinator {

    var signInCoordinator: Coordinator {
        let signInCoordinator = SignInCoordinator(configuration: configuration)
        signInCoordinator.delegate = self
        return signInCoordinator
    }

    func homeCoordinator(username: Username) -> Coordinator {
        let homeCoordinator = HomeCoordinator(configuration: configuration)
        homeCoordinator.delegate = self
        homeCoordinator.username = username
        return homeCoordinator
    }
}

// MARK: - SignInCoordinatorDelegate
extension RootCoordinator: SignInCoordinatorDelegate {

    func signInCoordinator(_ signInCoordinator: SignInCoordinator, didSignInUser username: Username) {
        childCoordinators.removeAll()
        showHome(username: username)
    }
}

// MARK: - HomeCoordinatorDelegate
extension RootCoordinator: HomeCoordinatorDelegate {

    func homeCoordinatorDidLogout(_ homeCoordinator: HomeCoordinator) {
        childCoordinators.removeAll()
        showSignIn()
    }
}
