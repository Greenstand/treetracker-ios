//
//  RootCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

class RootCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let configuration: CoordinatorConfigurable
    private let treetrackerSDK: Treetracker_Core.TreetrackerSDK
    private let currentPlanterService: Treetracker_Core.CurrentPlanterService

    required init(configuration: CoordinatorConfigurable, treetrackerSDK: Treetracker_Core.TreetrackerSDK) {
        self.configuration = configuration
        self.treetrackerSDK = treetrackerSDK
        self.currentPlanterService = treetrackerSDK.currentPlanterService
    }

    func start() {
        guard let currentPlanter = currentPlanterService.currentPlanter() else {
            showSignIn()
            return
        }
        showHome(planter: currentPlanter)
    }
}

// MARK: - Navigation
private extension RootCoordinator {

    func showLoadingViewController() {
        // Currently we don't use the loading view.
        // Lets keep it though for future use.
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
            treetrackerSDK: self.treetrackerSDK
        )
        signInCoordinator.delegate = self
        return signInCoordinator
    }

    func homeCoordinator(planter: Planter) -> Coordinator {

        let homeCoordinator = HomeCoordinator(
            configuration: configuration,
            treetrackerSDK: self.treetrackerSDK,
            planter: planter
        )

        homeCoordinator.delegate = self
        return homeCoordinator
    }
}

// MARK: - SignInCoordinatorDelegate
extension RootCoordinator: SignInCoordinatorDelegate {

    func signInCoordinator(_ signInCoordinator: SignInCoordinator, didSignInPlanter planter: Planter) {
        currentPlanterService.updateCurrentPlanter(planter: planter)
        childCoordinators.removeAll()
        showHome(planter: planter)
    }
}

// MARK: - HomeCoordinatorDelegate
extension RootCoordinator: HomeCoordinatorDelegate {

    func homeCoordinatorDidLogout(_ homeCoordinator: HomeCoordinator) {
        currentPlanterService.clearCurrentPlanter()
        childCoordinators.removeAll()
        showSignIn()
    }
}
