//
//  ProfileViewModel.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

protocol ProfileViewModelCoordinatorDelegate: AnyObject {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didLogoutPlanter planter: Planter)
}

protocol ProfileViewModelViewDelegate: AnyObject {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didFetchDetails details: ProfileViewModel.ProfileDetails)
}

class ProfileViewModel {

    weak var viewDelegate: ProfileViewModelViewDelegate?
    weak var coordinatorDelegate: ProfileViewModelCoordinatorDelegate?

    private let planter: Treetracker_Core.Planter
    private let selfieService: Treetracker_Core.SelfieService
    private let uploadManager: Treetracker_Core.UploadManaging

    init(
        planter: Treetracker_Core.Planter,
        selfieService: Treetracker_Core.SelfieService,
        uploadManager: Treetracker_Core.UploadManaging
    ) {
        self.planter = planter
        self.selfieService = selfieService
        self.uploadManager = uploadManager
    }

    var title: String {
        return self.planterName ?? L10n.Profile.fallbackTitle
    }

    var usernameHeaderTitle: String {
        if planter.email != nil {
            return L10n.Profile.HeaderLabel.email
        } else if planter.phoneNumber != nil {
            return L10n.Profile.HeaderLabel.phone
        } else {
            return ""
        }
    }


    func fetchDetails() {
        selfieService.fetchSelfie(forPlanter: planter) { (result) in
            switch result {
            case .success(let data):
                guard let localPhotoPathImage = UIImage(data: data) else {
                    fallthrough
                }
                viewDelegate?.profileViewModel(self, didFetchDetails: profileData(withImage: localPhotoPathImage))
            case .failure:
                viewDelegate?.profileViewModel(self, didFetchDetails: profileData(withImage: Asset.Assets.person.image))
            }
        }
    }

    func changeUser() {
        if uploadManager.isUploading {
            uploadManager.stopUploading()
        }
        coordinatorDelegate?.profileViewModel(self, didLogoutPlanter: planter)
    }
}

// MARK: - Private
private extension ProfileViewModel {

    var planterName: String? {
        guard let firstName = planter.firstName else {
            return nil
        }
        return "\(firstName) \(planter.lastName ?? "")"
    }

    var planterUsername: String {
        if let email = planter.email {
            return email
        } else if let phoneNumber = planter.phoneNumber {
            return phoneNumber
        } else {
            return ""
        }
    }

    var planterOrganization: String? {
        return planter.organization
    }

    func profileData(withImage image: UIImage) -> ProfileDetails {
        return ProfileDetails(
            name: planterName ?? "",
            image: image,
            username: planterUsername,
            organization: planterOrganization
        )
    }
}

// MARK: - Nested Types
extension ProfileViewModel {

    struct ProfileDetails {
        let name: String
        let image: UIImage
        let username: String
        let organization: String?
    }
}
