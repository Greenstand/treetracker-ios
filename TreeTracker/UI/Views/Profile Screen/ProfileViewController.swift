//
//  ProfileViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private var profileImageView: ProfileImageView!
    @IBOutlet private var nameHeaderLabel: UILabel! {
        didSet {
            nameHeaderLabel.text = L10n.Profile.HeaderLabel.name
            nameHeaderLabel.font = FontFamily.Montserrat.bold.font(size: 16.0)
            nameHeaderLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.text = ""
            nameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            nameLabel.textColor = Asset.Colors.grayMedium.color
        }
    }
    @IBOutlet private var usernameHeaderLabel: UILabel! {
        didSet {
            usernameHeaderLabel.text = ""
            usernameHeaderLabel.font = FontFamily.Montserrat.bold.font(size: 16.0)
            usernameHeaderLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var usernameLabel: UILabel! {
        didSet {
            usernameLabel.text = ""
            usernameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            usernameLabel.textColor = Asset.Colors.grayMedium.color
        }
    }
    @IBOutlet private var organizationHeaderLabel: UILabel! {
        didSet {
            organizationHeaderLabel.isHidden = true
            organizationHeaderLabel.text = L10n.Profile.HeaderLabel.organization
            organizationHeaderLabel.font = FontFamily.Montserrat.bold.font(size: 16.0)
            organizationHeaderLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var organizationLabel: UILabel! {
        didSet {
            organizationLabel.isHidden = true
            organizationLabel.text = ""
            organizationLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            organizationLabel.textColor = Asset.Colors.grayMedium.color
        }
    }
    @IBOutlet private var changeUserButton: DestructiveButton! {
        didSet {
            changeUserButton.setTitle(L10n.Profile.ChangeUserButton.title, for: .normal)
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

        //Title
        title = viewModel?.title

        //Profile Image
        profileImageView.image = details.image

        //Name
        nameLabel.text = details.name

        // Username (Phone/Email)
        usernameLabel.text = details.username
        usernameHeaderLabel.text = profileViewModel.usernameHeaderTitle

        // Organization
        let hasOrganization = details.organization != nil
        organizationHeaderLabel.isHidden = !hasOrganization
        organizationLabel.isHidden = !hasOrganization
        organizationLabel.text = details.organization
    }
}
