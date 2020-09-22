//
//  HomeViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol HomeViewModelCoordinatorDelegate: class {
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectAddTreeForPlanter planter: Planter)
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectUploadListForPlanter planter: Planter)
    func homeViewModel(_ homeViewModel: HomeViewModel, didLogoutPlanter planter: Planter)
}

protocol HomeViewModelViewDelegate: class {
    func homeViewModel(_ homeViewModel: HomeViewModel, didReceiveError error: Error)
    func homeViewModel(_ homeViewModel: HomeViewModel, didUpdateTreeCount data: HomeViewModel.TreeCountData)
}

class HomeViewModel {

    struct TreeCountData {
        let planted: Int
        let uploaded: Int

        var pendingUpload: Int {
            return planted - uploaded
        }

        var hasPendingUploads: Bool {
            return pendingUpload > 0
        }
    }

    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?

    private let treeMonitoringService: TreeMonitoringService
    private let planter: Planter

    init(planter: Planter, treeMonitoringService: TreeMonitoringService) {
        self.planter = planter
        self.treeMonitoringService = treeMonitoringService
        treeMonitoringService.delegate = self
    }

    let title = L10n.Home.title

    func fetchTrees() {
        treeMonitoringService.startMonitoringTrees(forPlanter: planter)
    }

    func uploadListSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectUploadListForPlanter: planter)
    }

    func addTreeSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectAddTreeForPlanter: planter)
    }

    func logoutPlanter() {
// TODO: Sync & Clear session before logout
        coordinatorDelegate?.homeViewModel(self, didLogoutPlanter: planter)
    }
}

// MARK: - TreeServiceDelegate
extension HomeViewModel: TreeMonitoringServiceDelegate {

    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didUpdateTrees trees: [Tree]) {

        let uploadedCount = trees.filter({
            $0.uploaded == true
        }).count

        let data = TreeCountData(
            planted: trees.count,
            uploaded: uploadedCount
        )
        viewDelegate?.homeViewModel(self, didUpdateTreeCount: data)
    }

    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didError error: Error) {
        viewDelegate?.homeViewModel(self, didReceiveError: error)
    }
}
