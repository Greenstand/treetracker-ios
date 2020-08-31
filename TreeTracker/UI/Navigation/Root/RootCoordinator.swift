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
    let configuration: CoordinatorConfigurable
    let coreDataManager: CoreDataManaging

    required init(configuration: CoordinatorConfigurable, coreDataManager: CoreDataManaging) {
        self.configuration = configuration
        self.coreDataManager = coreDataManager
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

    func showHome(planter: Planter) {
        startCoordinator(coordinator: homeCoordinator(planter: planter))
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
        let signInCoordinator = SignInCoordinator(
            configuration: configuration,
            coreDataManager: coreDataManager
        )
        signInCoordinator.delegate = self
        return signInCoordinator
    }

    func homeCoordinator(planter: Planter) -> Coordinator {
        let homeCoordinator = HomeCoordinator(
            configuration: configuration,
            coreDataManager: coreDataManager,
            planter: planter
        )
        homeCoordinator.delegate = self
        return homeCoordinator
    }
}

// MARK: - SignInCoordinatorDelegate
extension RootCoordinator: SignInCoordinatorDelegate {

    func signInCoordinator(_ signInCoordinator: SignInCoordinator, didSignInPlanter planter: Planter) {
        childCoordinators.removeAll()
        showHome(planter: planter)
    }
}

// MARK: - HomeCoordinatorDelegate
extension RootCoordinator: HomeCoordinatorDelegate {

    func homeCoordinatorDidLogout(_ homeCoordinator: HomeCoordinator) {
        childCoordinators.removeAll()
        showSignIn()
    }
}
