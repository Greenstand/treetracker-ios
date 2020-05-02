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
        showHomeViewController()
    }
}

// MARK: - Navigation
private extension RootCoordinator {

    func showHomeViewController() {
        configuration.navigationController.viewControllers = [
            viewController
        ]
    }
}

// MARK: - View Controllers
private extension RootCoordinator {

    var viewController: UIViewController {
        let viewController = StoryboardScene.Main.initialScene.instantiate()
        return viewController
    }
}
