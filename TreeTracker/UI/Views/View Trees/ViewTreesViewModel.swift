//
//  ViewTreesViewModel.swift
//  TreeTracker
//
//  Created by Remi Varghese on 11/7/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol ViewTreesViewModelViewDelegate: class {
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didReceiveError error: Error)
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didUpdateTrees trees: [Tree])
}

class ViewTreesViewModel {

    struct TreeCountData {
        let planted: Int
        let uploaded: Int }

        private let treeMonitoringService: TreeMonitoringService
        weak var viewDelegate: ViewTreesViewModelViewDelegate?
        private let planter: Planter

        init(planter: Planter, treeMonitoringService: TreeMonitoringService) {
        self.planter = planter
        self.treeMonitoringService = treeMonitoringService
        treeMonitoringService.delegate = self
        }

        let title = L10n.ViewTrees.title

        func fetchTrees() {
            treeMonitoringService.startMonitoringTrees(forPlanter: planter)
        }
}

// MARK: - TreeServiceDelegate
extension ViewTreesViewModel: TreeMonitoringServiceDelegate {

    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didUpdateTrees trees: [Tree]) {

        print(trees)
        viewDelegate?.viewTreesViewModel(self, didUpdateTrees: trees)
    }

    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didError error: Error) {
    }
}
