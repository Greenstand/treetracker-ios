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
    let coreDataManager: CoreDataManaging
    let planter: Planter
    let uploadManager: UploadManaging

    required init(configuration: CoordinatorConfigurable, coreDataManager: CoreDataManaging, planter: Planter, uploadManager: UploadManaging) {
        self.configuration = configuration
        self.coreDataManager = coreDataManager
        self.planter = planter
        self.uploadManager = uploadManager
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
            addTreeViewController(planter: planter),
            animated: true
        )
    }

    func showPlanterProfile(planter: Planter) {
        configuration.navigationController.pushViewController(
            profileViewController(planter: planter),
            animated: true
        )
    }
}

// MARK: - View Controllers
private extension HomeCoordinator {

    func homeViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Home.initialScene.instantiate()
        viewController.viewModel = {
            let treeMonitoringService = LocalTreeMonitoringService(
                coreDataManager: coreDataManager
            )

            let selfieService = LocalSelfieService(
                coreDataManager: coreDataManager,
                documentManager: DocumentManager()
            )
            let viewModel = HomeViewModel(
                planter: planter,
                treeMonitoringService: treeMonitoringService,
                selfieService: selfieService,
                uploadManager: uploadManager
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    var uploadListViewController: UIViewController {
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .white
        viewcontroller.title = "My Trees"
        return viewcontroller
    }

    func addTreeViewController(planter: Planter) -> UIViewController {
        let viewcontroller = StoryboardScene.AddTree.initialScene.instantiate()
        viewcontroller.viewModel = {
            let locationService = LocationService()
            let treeService = LocalTreeService(
                coreDataManager: coreDataManager,
                documentManager: DocumentManager()
            )
            let viewModel = AddTreeViewModel(
                locationService: locationService,
                treeService: treeService,
                planter: planter
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewcontroller
    }

    func profileViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Profile.initialScene.instantiate()
        viewController.viewModel = {
            let selfieService = LocalSelfieService(
                coreDataManager: coreDataManager,
                documentManager: DocumentManager()
            )
            let viewModel = ProfileViewModel(
                planter: planter,
                selfieService: selfieService,
                uploadManager: uploadManager
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
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

    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectViewProfileForPlanter planter: Planter) {
        showPlanterProfile(planter: planter)
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didLogoutPlanter planter: Planter) {
        delegate?.homeCoordinatorDidLogout(self)
    }
}

// MARK: - ProfileViewModelCoordinatorDelegate
extension HomeCoordinator: ProfileViewModelCoordinatorDelegate {

   func profileViewModel(_ profileViewModel: ProfileViewModel, didLogoutPlanter planter: Planter) {
        delegate?.homeCoordinatorDidLogout(self)
   }
}

// MARK: - AddTreeViewModelCoordinatorDelegate
extension HomeCoordinator: AddTreeViewModelCoordinatorDelegate {

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didAddTree tree: Tree) {
        configuration.navigationController.popViewController(animated: true)
    }
}
