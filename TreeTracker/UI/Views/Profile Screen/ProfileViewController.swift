//
//  ProfileViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
   
    @IBOutlet private var profilePictureImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
        }
    }
    @IBOutlet private var usernameLabel: UILabel! {
           didSet {
               usernameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
           }
    }
    @IBOutlet private var organizationLabel: UILabel! {
        didSet {
            organizationLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
        }
    }

    var viewModel: ProfileViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchDetails()
    }
}

// MARK: - Button Actions
private extension ProfileViewController {

    @IBAction func changeUserButtonPressed() {
        viewModel?.changeUser()
    }
}

// MARK: - ProfileViewModelViewDelegate
extension ProfileViewController: ProfileViewModelViewDelegate {

    func profileViewModel(_ profileViewModel: ProfileViewModel, didFetchDetails details: ProfileViewModel.ProfileDetails) {
        profilePictureImageView.image = details.image
        nameLabel.text = details.name
        organizationLabel.text = details.organization
        usernameLabel.text = details.username
    }
}
