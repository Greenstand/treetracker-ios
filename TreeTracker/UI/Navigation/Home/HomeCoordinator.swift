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
    func homeCoordinatorDidDeleteAccount(_ homeCoordinator: HomeCoordinator)
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

    func showChatList(planter: Planter) {
        configuration.navigationController.pushViewController(
            chatListViewController(planter: planter),
            animated: true
        )
    }

    func showMessages(planter: Planter) {
        configuration.navigationController.pushViewController(
            messagesViewController(planter: planter),
            animated: true
        )
    }

    func showNotes(note: String?) {
        configuration.navigationController.pushViewController(
            notesViewController(note: note),
            animated: true)
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
                uploadManager: self.treetrackerSDK.uploadManager,
                messagingService: self.treetrackerSDK.messagingService
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

    func chatListViewController(planter: Planter) -> UIViewController {
        let viewcontroller = StoryboardScene.ChatList.initialScene.instantiate()
        viewcontroller.viewModel = {
            let viewModel = ChatListViewModel(
            planter: planter,
            selfieService: self.treetrackerSDK.selfieService
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewcontroller
    }

    func messagesViewController(planter: Planter) -> UIViewController {
        let viewcontroller = StoryboardScene.Messages.initialScene.instantiate()
        viewcontroller.viewModel = {
            let viewModel = MessagesViewModel(
            planter: planter,
            messagingService: treetrackerSDK.messagingService
            )
            return viewModel
        }()
        return viewcontroller
    }

    func notesViewController(note: String?) -> UIViewController {
        let viewController = StoryboardScene.Notes.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = NotesViewModel(note: note)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }
    func profileViewController(planter: Planter) -> UIViewController {
        let viewController = StoryboardScene.Profile.initialScene.instantiate()
        viewController.viewModel = {
            let viewModel = ProfileViewModel(
                planter: planter,
                selfieService: self.treetrackerSDK.selfieService,
                uploadManager: self.treetrackerSDK.uploadManager,
                userDeletionService: self.treetrackerSDK.userDeletionService,
                settingsService: self.treetrackerSDK.settingsService
            )
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        return viewController
    }

    var confirmLogoutViewController: UIViewController {

        let alertController = UIAlertController(
            title: L10n.LogOutConfirmation.title,
            message: L10n.LogOutConfirmation.message,
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: L10n.LogOutConfirmation.CancelButton.title, style: .cancel)
        let logoutAction = UIAlertAction(title: L10n.LogOutConfirmation.LogOutButton.title, style: .destructive) { _ in
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

    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectViewChatListForPlanter planter: Planter) {
        showChatList(planter: planter)
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

    func profileViewModelDidDeleteAccount(_ profileViewModel: ProfileViewModel) {
        delegate?.homeCoordinatorDidDeleteAccount(self)
    }
}

// MARK: - AddTreeViewModelCoordinatorDelegate
extension HomeCoordinator: AddTreeViewModelCoordinatorDelegate {

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didAddTree tree: Tree) {
        configuration.navigationController.popViewController(animated: true)
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didHaveSavedNote note: String?) {
        showNotes(note: note)
    }
}

// MARK: - NotesViewModelCoordinatorDelegate
extension HomeCoordinator: NotesViewModelCoordinatorDelegate {

    func notesViewModel(_ notesViewModel: NotesViewModel, didAddNote note: String) {
        configuration.navigationController.popViewController(animated: true)
        if let addTreeViewController = configuration.navigationController.topViewController as? AddTreeViewController {
            addTreeViewController.viewModel?.addNote(note)
        }
    }
}

// MARK: - ChatListViewModelCoordinatorDelegate
extension HomeCoordinator: ChatListViewModelCoordinatorDelegate {

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectMessagesForPlanter planter: Planter) {
        showMessages(planter: planter)
    }

}
