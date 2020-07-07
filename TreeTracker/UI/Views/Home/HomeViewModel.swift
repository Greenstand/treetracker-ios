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

    private let treeService: TreeService
    private let planter: Planter

    init(planter: Planter, treeService: TreeService = TreeService()) {
        self.planter = planter
        self.treeService = treeService
        treeService.delegate = self
    }

    let title = L10n.Home.title

    func fetchTrees() {
        treeService.startMonitoringTrees(forPlanter: planter)
    }

    func uploadListSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectUploadListForPlanter: planter)
    }

    func addTreeSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectAddTreeForPlanter: planter)
    }
}

// MARK: - TreeServiceDelegate
extension HomeViewModel: TreeServiceDelegate {

    func treeService(_ treeService: TreeService, didUpdateTrees trees: [Tree]) {
        let data = TreeCountData(planted: 200, uploaded: 150)
        viewDelegate?.homeViewModel(self, didUpdateTreeCount: data)
    }

    func treeService(_ treeService: TreeService, didError error: Error) {
        viewDelegate?.homeViewModel(self, didReceiveError: error)
    }
}
