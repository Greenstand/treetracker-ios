//
//  ProfileViewModel.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileViewModelCoordinatorDelegate: class {
    func profileViewModel(_ profileViewModel: ProfileViewModel, changeUser planter: Planter)
}

protocol ProfileViewModelViewDelegate: class {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didFetchDetails details: ProfileViewModel.ProfileDetails)
    func profileViewModel(_ profileViewModel: ProfileViewModel, didUpdateTrees trees: [Tree])
    func profileViewModel(_ profileViewModel: ProfileViewModel, didReceiveError error: Error)
}

class ProfileViewModel {
    weak var viewDelegate: ProfileViewModelViewDelegate?
    weak var coordinatorDelegate: ProfileViewModelCoordinatorDelegate?
    private let planter: Planter
    private let treeMonitoringService: TreeMonitoringService
    private let selfieService: SelfieService
    private let uploadManager: UploadManaging
    
    init(planter: Planter, treeMonitoringService: TreeMonitoringService, selfieService: SelfieService, uploadManager: UploadManaging) {
        self.planter = planter
        self.treeMonitoringService = treeMonitoringService
        self.selfieService = selfieService
        self.uploadManager = uploadManager
        self.treeMonitoringService.delegate = self
    }
    struct ProfileDetails {
        let name: String
        let image: UIImage
        let emailPhone: String
        let organization: String
    }
}

extension ProfileViewModel: TreeMonitoringServiceDelegate {
    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didUpdateTrees trees: [Tree]) {
        viewDelegate?.profileViewModel(self, didUpdateTrees: trees)
    }
    func treeMonitoringService(_ treeMonitoringService: TreeMonitoringService, didError error: Error) {
        viewDelegate?.profileViewModel(self, didReceiveError: error)
    }
}

// MARK: - Profile
extension ProfileViewModel {
    var planterName: String {
        guard let firstName = planter.firstName else {
            return ""
        }
        return "\(firstName) \(planter.lastName ?? "")"
    }
    var planterEmailPhone: String {
        guard planter.email == nil else {
            return planter.email ?? ""
        }
        return planter.phoneNumber!
    }
    var planterOrganization: String {
        return planter.organization!
    }
    func fetchDetails() {
       selfieService.fetchSelfie(forPlanter: planter) { (result) in
            switch result {
            case .success(let data):
                guard let localPhotoPathImage = UIImage(data: data) else {
                    fallthrough
                }
                let profiledetails = ProfileDetails(name: planterName, image: localPhotoPathImage, emailPhone: planterEmailPhone, organization: planterOrganization)
                viewDelegate?.profileViewModel(self, didFetchDetails: profiledetails)
            case .failure:
                let profiledetails = ProfileDetails(name: planterName, image: Asset.Assets.person.image, emailPhone: planterEmailPhone, organization: planterOrganization)
                viewDelegate?.profileViewModel(self, didFetchDetails: profiledetails)
            }
        }
    }
    func changeUser() {
        if uploadManager.isUploading {
            uploadManager.stopUploading()
        }
        coordinatorDelegate?.profileViewModel(self, changeUser: planter)
    }
}
