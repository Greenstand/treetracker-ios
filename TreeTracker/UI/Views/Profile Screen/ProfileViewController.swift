//
//  ProfileViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
            profileImageView.layer.borderWidth = 2.0
            profileImageView.layer.borderColor = Asset.Colors.grayLight.color.withAlphaComponent(0.5).cgColor
            profileImageView.image = Asset.Assets.profile.image
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.text = ""
            nameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            nameLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var usernameLabel: UILabel! {
        didSet {
            usernameLabel.text = ""
            usernameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            usernameLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var organizationLabel: UILabel! {
        didSet {
            organizationLabel.text = ""
            organizationLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            organizationLabel.textColor = Asset.Colors.grayDark.color
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
        profileImageView.image = details.image
        nameLabel.text = details.name
        organizationLabel.text = details.organization
        usernameLabel.text = details.username
    }
}
