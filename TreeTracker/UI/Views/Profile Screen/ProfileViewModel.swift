//
//  ProfileViewModel.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

protocol ProfileViewModelCoordinatorDelegate: AnyObject {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didLogoutPlanter planter: Planter)
}

protocol ProfileViewModelViewDelegate: AnyObject {
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

    var title: String {
        guard let firstName = planter.firstName, 
              let lastName = planter.lastName else {
            return L10n.Profile.fallbackTitle
        }
        return "\(firstName) \(lastName)"
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
    
    var planterName: String {
        guard let firstName = planter.firstName else {
            return ""
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
            name: planterName, 
            image: image, 
            username: planterUsername, 
            organization: planterOrganization
        )
    }
}

// MARK: - Structs
extension ProfileViewModel {

    struct ProfileDetails {
        let name: String
        let image: UIImage
        let username: String
        let organization: String?
    }   
}
