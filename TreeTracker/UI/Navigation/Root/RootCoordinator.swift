//
//  RootCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {

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
        let signInCoordinator = SignInCoordinator(
            configuration: configuration
        )
        signInCoordinator.start()
    }

    func showMap() {

    }
}

// MARK: - View Controllers
private extension RootCoordinator {

    var loadingViewController: UIViewController {
        return StoryboardScene.Loading.initialScene.instantiate()
    }
}
