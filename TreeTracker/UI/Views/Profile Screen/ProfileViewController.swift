//
//  ProfileViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 3/23/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var trees: [Tree] = []
    weak var rootcoordinator: RootCoordinator!
    var homecoordinator: HomeCoordinator!
    // MARK: - IBOutlets
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
        }
    }
    @IBOutlet private var emailphoneLabel: UILabel! {
           didSet {
               emailphoneLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
           }
    }
    @IBOutlet private var organizationLabel: UILabel! {
        didSet {
            organizationLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
        }
    }
    @IBAction func changeuserButton(_ sender: UIButton) {
        viewModel?.changeUser()
    }
    var viewModel: ProfileViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            //title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel?.fetchDetails()

}
}

extension ProfileViewController: ProfileViewModelViewDelegate, AlertPresenting {
    func profileViewModel(_ profileViewModel: ProfileViewModel, didFetchDetails details: ProfileViewModel.ProfileDetails) {
        profilepic.image = details.image
        nameLabel.text = details.name
        organizationLabel.text = details.organization
        emailphoneLabel.text = details.emailPhone
    }
    func profileViewModel(_ viewTreesViewModel: ProfileViewModel, didUpdateTrees trees: [Tree]) {
         self.trees = trees

    }
    func profileViewModel(_ viewTreesViewModel: ProfileViewModel, didReceiveError error: Error) {
         present(alert: .error(error))
    }
}
