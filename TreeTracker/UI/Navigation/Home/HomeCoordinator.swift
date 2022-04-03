//
//  HomeCoordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidLogout(_ homeCoordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator {

    weak var delegate: HomeCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []

    let configuration: CoordinatorConfigurable
    let treetrackerSDK: Treetracker_Core.TreetrackerSDK
    let planter: Treetracker_Core.Planter

    required init(
        configuration: CoordinatorConfigurable,
        treetrackerSDK: Treetracker_Core.TreetrackerSDK,
        planter: Treetracker_Core.Planter
    ) {
        self.configuration = configuration
        self.treetrackerSDK = treetrackerSDK
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

    func showLogoutConfirmation() {
        configuration.navigationController.viewControllers.first?.present(
            confirmLogoutViewController,
            animated: true
        )
    }

    func showSettings() {
        configuration.navigationController.pushViewController(
            settingsViewController,
            animated: true
        )
    }
}

// MARK: - View Controllers
private extension HomeCoordinator {

    func homeViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Home.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = HomeViewModel(
                planter: planter,
                treeMonitoringService: self.treetrackerSDK.treeMonitoringService,
                selfieService: self.treetrackerSDK.selfieService,
                uploadManager: self.treetrackerSDK.uploadManager
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
            let viewModel = AddTreeViewModel(
                locationProvider: self.treetrackerSDK.locationService,
                treeService: self.treetrackerSDK.treeService,
                settingsService: self.treetrackerSDK.settingsService,
                locationDataCapturer: self.treetrackerSDK.locationDataCapturer,
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
            let viewModel = ProfileViewModel(
                planter: planter,
                selfieService: self.treetrackerSDK.selfieService,
                uploadManager: self.treetrackerSDK.uploadManager
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    var confirmLogoutViewController: UIViewController {

        let alertController = UIAlertController(
            title: "Change user",
            message: "Are you sure you want to logout and change user?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.delegate?.homeCoordinatorDidLogout(self)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)

        return alertController

    }

    var settingsViewController: UIViewController {
        let viewController = StoryboardScene.Settings.initialScene.instantiate()
        viewController.viewModel = SettingsViewModel(
            settingsService: self.treetrackerSDK.settingsService
        )
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
        showLogoutConfirmation()
    }

    func homeViewModelDidSelectSettings(_ homeViewModel: HomeViewModel) {
        showSettings()
    }
}

// MARK: - ProfileViewModelCoordinatorDelegate
extension HomeCoordinator: ProfileViewModelCoordinatorDelegate {

   func profileViewModel(_ profileViewModel: ProfileViewModel, didLogoutPlanter planter: Planter) {
        showLogoutConfirmation()
   }
}

// MARK: - AddTreeViewModelCoordinatorDelegate
extension HomeCoordinator: AddTreeViewModelCoordinatorDelegate {

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didAddTree tree: Tree) {
        configuration.navigationController.popViewController(animated: true)
    }
}
