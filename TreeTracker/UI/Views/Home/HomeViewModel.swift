//
//  HomeViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol HomeViewModelCoordinatorDelegate: class {
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectAddTreeForPlanter planter: Planter)
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectUploadListForPlanter planter: Planter)
    func homeViewModel(_ homeViewModel: HomeViewModel, didSelectViewProfileForPlanter planter: Planter)
    func homeViewModel(_ homeViewModel: HomeViewModel, didLogoutPlanter planter: Planter)
}

protocol HomeViewModelViewDelegate: class {
    func homeViewModel(_ homeViewModel: HomeViewModel, didReceiveError error: Error)
    func homeViewModel(_ homeViewModel: HomeViewModel, didUpdateTreeCount data: HomeViewModel.TreeCountData)
    func homeViewModel(_ homeViewModel: HomeViewModel, didFetchProfile profile: HomeViewModel.ProfileData)
    func homeViewModelDidStartUploadingTrees(_ homeViewModel: HomeViewModel)
    func homeViewModelDidStopUploadingTrees(_ homeViewModel: HomeViewModel)
}

class HomeViewModel {

    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?

    private let treeMonitoringService: TreeMonitoringService
    private let selfieService: SelfieService
    private let uploadManager: UploadManaging
    private let planter: Planter

    init(planter: Planter, treeMonitoringService: TreeMonitoringService, selfieService: SelfieService, uploadManager: UploadManaging) {

        self.planter = planter
        self.treeMonitoringService = treeMonitoringService
        self.uploadManager = uploadManager
        self.selfieService = selfieService

        self.treeMonitoringService.delegate = self
        self.uploadManager.delegate = self
    }

    var title: String {
        return L10n.Home.title(planter.firstName ?? "")
    }
}

// MARK: - Profile
extension HomeViewModel {

    func fetchProfileData() {

        selfieService.fetchSelfie(forPlanter: planter) { (result) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    fallthrough
                }
                let profileData = ProfileData(name: planterName, image: image)
                viewDelegate?.homeViewModel(self, didFetchProfile: profileData)
            case .failure:
                let profileData = ProfileData(name: planterName, image: Asset.Assets.person.image)
                viewDelegate?.homeViewModel(self, didFetchProfile: profileData)
            }
        }
    }

    private var planterName: String {
        guard let firstName = planter.firstName else {
            return ""
        }
        return "\(firstName) \(planter.lastName ?? "")"
    }
}

// MARK: - Tree Monitoring
extension HomeViewModel {

    func startMonitoringTrees() {
        treeMonitoringService.startMonitoringTrees(forPlanter: planter)
    }
}

// MARK: - Uploads
extension HomeViewModel {

    func toggleTreeUploads() {
        if uploadManager.isUploading {
            uploadManager.stopUploading()
        } else {
            uploadManager.startUploading()
        }
    }
}

// MARK: - Navigation
extension HomeViewModel {

    func uploadListSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectUploadListForPlanter: planter)
    }

    func addTreeSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectAddTreeForPlanter: planter)
    }

    func viewProfileSelected() {
        coordinatorDelegate?.homeViewModel(self, didSelectViewProfileForPlanter: planter)
    }

    func logoutPlanter() {

        if uploadManager.isUploading {
            uploadManager.stopUploading()
        }
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

// MARK: - UploadManagerDelegate
extension HomeViewModel: UploadManagerDelegate {

    func uploadManagerDidStartUploadingTrees(_ uploadManager: UploadManager) {
        viewDelegate?.homeViewModelDidStartUploadingTrees(self)
    }

    func uploadManagerDidStopUploadingTrees(_ uploadManager: UploadManager) {
        viewDelegate?.homeViewModelDidStopUploadingTrees(self)
    }

    func uploadManager(_ uploadManager: UploadManager, didError error: Error) {
        viewDelegate?.homeViewModel(self, didReceiveError: error)
    }
}

// MARK: - TreeCountData
extension HomeViewModel {

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

    struct ProfileData {
        let name: String
        let image: UIImage
    }
}
