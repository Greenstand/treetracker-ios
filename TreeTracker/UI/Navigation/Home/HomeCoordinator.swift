//
//  HomeCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: class {
    func homeCoordinatorDidLogout(_ homeCoordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator {

    weak var delegate: HomeCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    private let configuration: CoordinatorConfigurable
    var username: Username?

    required init(configuration: CoordinatorConfigurable) {
        self.configuration = configuration
    }

    func start() {
        guard let username = username else {
            delegate?.homeCoordinatorDidLogout(self)
            return
        }
        showHome(username: username)
    }
}

// MARK: - Navigation
private extension HomeCoordinator {

    func showHome(username: Username) {
        configuration.navigationController.viewControllers = [
            homeViewController(username: username)
        ]
    }

    func showUploadList(username: Username) {
        configuration.navigationController.pushViewController(
            uploadListViewController(username: username),
            animated: true
        )
    }

    func showAddTree(username: Username) {
        configuration.navigationController.pushViewController(
            addTreeViewController(username: username),
            animated: true
        )
    }
}

// MARK: - View Controllers
private extension HomeCoordinator {

    func homeViewController(username: Username) -> UIViewController {
        let viewController = StoryboardScene.Home.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = HomeViewModel(username: username)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    func uploadListViewController(username: Username) -> UIViewController {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .white
        viewcontroller.title = "Uploads"
        return viewcontroller
    }

    func addTreeViewController(username: Username) -> UIViewController {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .white
        viewcontroller.title = "Add Tree"
        return viewcontroller
    }
}

// MARK: - HomeViewModelCoordinatorDelegate
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {

    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectAddTreeForUser username: Username) {
        showAddTree(username: username)
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectUploadListForUser username: Username) {
        showUploadList(username: username)
    }
}
