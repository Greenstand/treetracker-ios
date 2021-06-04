//
//  ProfileViewModel.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

protocol ProfileViewModelCoordinatorDelegate: class {
    func profileViewModel(_ profileViewModel: ProfileViewModel, changeUser planter: Planter)
}

protocol ProfileViewModelViewDelegate: class {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didFetchDetails details: ProfileViewModel.ProfileDetails)
}

class ProfileViewModel {
    weak var viewDelegate: ProfileViewModelViewDelegate?
    weak var coordinatorDelegate: ProfileViewModelCoordinatorDelegate?
    private let planter: Planter
    private let selfieService: SelfieService
    private let uploadManager: UploadManaging
    
    init(planter: Planter, selfieService: SelfieService, uploadManager: UploadManaging) {
        self.planter = planter
        self.selfieService = selfieService
        self.uploadManager = uploadManager
    }
    struct ProfileDetails {
        let name: String
        let image: UIImage
        let username: String
        let organization: String
    }
    var title: String {
        return "\(planter.firstName ?? "") \(planter.lastName ?? "")"
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
    var planterUsername: String {
        guard planter.email == nil else {
            return planter.email ?? ""
        }
        return planter.phoneNumber!
    }
    var planterOrganization: String? {
        return planter.organization
    }
    func fetchDetails() {
       selfieService.fetchSelfie(forPlanter: planter) { (result) in
            switch result {
            case .success(let data):
                guard let localPhotoPathImage = UIImage(data: data) else {
                    fallthrough
                }
                let profiledetails = ProfileDetails(name: planterName, image: localPhotoPathImage, username: planterUsername, organization: planterOrganization!)
                viewDelegate?.profileViewModel(self, didFetchDetails: profiledetails)
            case .failure:
                let profiledetails = ProfileDetails(name: planterName, image: Asset.Assets.person.image, username: planterUsername, organization: planterOrganization!)
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
