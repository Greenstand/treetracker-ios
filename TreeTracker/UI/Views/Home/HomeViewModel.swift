//
//  HomeViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol HomeViewModelCoordinatorDelegate: class {
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectAddTreeForUser username: Username)
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectUploadListForUser username: Username)
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
    private let username: Username

    init(username: Username, treeService: TreeService = TreeService()) {
        self.username = username
        self.treeService = treeService
        treeService.delegate = self
    }

    let title = L10n.Home.title

    func fetchTrees() {
        treeService.startMonitoringTrees(forUser: username)
    }

    func uploadListSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectUploadListForUser: username)
    }

    func addTreeSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectAddTreeForUser: username)
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
