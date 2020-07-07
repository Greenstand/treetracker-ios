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
    let configuration: CoordinatorConfigurable
    let planter: Planter

    required init(configuration: CoordinatorConfigurable, planter: Planter) {
        self.configuration = configuration
        self.planter = planter
    }

    func start() {
        showHome(planter: planter)
    }
}

// MARK: - Navigation
private extension HomeCoordinator {

    func showHome(planter: Planter) {
        configuration.navigationController.viewControllers = [
            homeViewController(planter: planter)
        ]
    }

    func showUploadList(planter: Planter) {
        configuration.navigationController.pushViewController(
            uploadListViewController,
            animated: true
        )
    }

    func showAddTree(planter: Planter) {
        configuration.navigationController.pushViewController(
            addTreeViewController,
            animated: true
        )
    }
}

// MARK: - View Controllers
private extension HomeCoordinator {

    func homeViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Home.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = HomeViewModel(planter: planter)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    var uploadListViewController: UIViewController {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .white
        viewcontroller.title = "Uploads"
        return viewcontroller
    }

    var addTreeViewController: UIViewController {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .white
        viewcontroller.title = "Add Tree"
        return viewcontroller
    }
}

// MARK: - HomeViewModelCoordinatorDelegate
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectAddTreeForPlanter planter: Planter) {
        showAddTree(planter: planter)
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectUploadListForPlanter planter: Planter) {
        showUploadList(planter: planter)
    }
}
