//
//  HomeViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AlertPresenting {

    @IBOutlet private var treesPlantedView: UIView! {
        didSet {
            treesPlantedView.layer.cornerRadius = 5.0
            treesPlantedView.layer.masksToBounds = true
            treesPlantedView.backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.5)
        }
    }
    @IBOutlet private var treesPlantedLabel: UILabel! {
        didSet {
            treesPlantedLabel.text = L10n.Home.InfoLabel.TreesPlantedLabel.text
            treesPlantedLabel.font = FontFamily.Lato.regular.font(size: 16.0)
            treesPlantedLabel.textColor = Asset.Colors.grayMedium.color
        }
    }
    @IBOutlet private var treesPlantedCountLabel: UILabel! {
        didSet {
            treesPlantedCountLabel.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            treesPlantedCountLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var treesPlantedImageview: UIImageView! {
        didSet {
            treesPlantedImageview.tintColor = Asset.Colors.grayDark.color
            treesPlantedImageview.image = Asset.Assets.seed.image
            treesPlantedImageview.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet private var treesUploadedView: UIView! {
        didSet {
            treesUploadedView.layer.cornerRadius = 5.0
            treesUploadedView.layer.masksToBounds = true
            treesUploadedView.backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.5)
        }
    }
    @IBOutlet private var treesUploadedLabel: UILabel! {
        didSet {
            treesUploadedLabel.text = L10n.Home.InfoLabel.TreesUploadedLabel.text
            treesUploadedLabel.font = FontFamily.Lato.regular.font(size: 16.0)
            treesUploadedLabel.textColor = Asset.Colors.grayMedium.color

        }
    }
    @IBOutlet private var treesUploadedCountLabel: UILabel! {
        didSet {
            treesUploadedCountLabel.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            treesUploadedCountLabel.textColor = Asset.Colors.grayDark.color
        }
    }
    @IBOutlet private var treesUploadedImageview: UIImageView! {
        didSet {
            treesUploadedImageview.tintColor = Asset.Colors.grayDark.color
            treesUploadedImageview.image = Asset.Assets.upload.image
            treesUploadedImageview.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet private var addTreeButton: AddTreeButton!
    @IBOutlet private var uploadTreesButton: UploadsButton! {
        didSet {
            uploadTreesButton.setTitle(L10n.Home.UploadTreesButton.Title.start, for: .normal)
            uploadTreesButton.isEnabled = false
        }
    }
    @IBOutlet private var myTreesButton: UploadsButton!
    @IBOutlet private var uploadsCountView: UIView! {
        didSet {
            uploadsCountView.backgroundColor = Asset.Colors.secondaryRed.color
            uploadsCountView.layer.cornerRadius = uploadsCountLabel.frame.size.height / 2
            uploadsCountView.layer.masksToBounds = true
            uploadsCountView.isHidden = true
        }
    }
    @IBOutlet private var uploadsCountLabel: UILabel! {
        didSet {
            uploadsCountLabel.textColor = .white
            uploadsCountLabel.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            uploadsCountLabel.text = "0"
        }
    }

    var viewModel: HomeViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.startMonitoringTrees()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLogoutButton()
        viewModel?.fetchProfileData()
    }
}
// MARK: - Private
private extension HomeViewController {

    private func showLogoutButton() {
        let logoutButton = UIBarButtonItem(
            title: L10n.Home.LogoutButton.title,
            style: .plain,
            target: self,
            action: #selector(logoutButtonPressed)
        )
        logoutButton.tintColor = Asset.Colors.grayDark.color
        logoutButton.setTitleTextAttributes([
            .font: FontFamily.Lato.regular.font(size: 16),
            .foregroundColor: Asset.Colors.grayDark.color
        ], for: .normal)
        logoutButton.setTitleTextAttributes([
            .font: FontFamily.Lato.regular.font(size: 16),
            .foregroundColor: Asset.Colors.grayLight.color
        ], for: .highlighted)
        navigationItem.rightBarButtonItem = logoutButton
    }
}

// MARK: - Button Actions
private extension HomeViewController {

    @IBAction func addTreeButtonPressed() {
        viewModel?.addTreeSelected()
    }

    @IBAction func uploadsButtonPressed() {
        viewModel?.uploadListSelected()
    }

    @IBAction func uploadTreesButtonPressed() {
        viewModel?.toggleTreeUploads()
    }

    @objc func logoutButtonPressed() {
        viewModel?.logoutPlanter()
    }
}

// MARK: - Private
private extension HomeViewController {

    func updateProfileButton(withProfileData profile: HomeViewModel.ProfileData) {
        navigationItem.leftBarButtonItem = ProfileBarButtonItem(
            planterName: profile.name,
            planterImage: profile.image,
            action: {
                self.viewModel?.viewProfileSelected()
            }
        )
    }
}

// MARK: - HomeViewModelViewDelegate
extension HomeViewController: HomeViewModelViewDelegate {

    func homeViewModel(_ homeViewModel: HomeViewModel, didUpdateTreeCount data: HomeViewModel.TreeCountData) {
        treesPlantedCountLabel.text = "\(data.planted)"
        treesUploadedCountLabel.text = "\(data.uploaded) / \(data.planted)"
        uploadTreesButton.isEnabled = data.hasPendingUploads
        uploadsCountLabel.text = "\(data.pendingUpload)"
        uploadsCountView.isHidden = !data.hasPendingUploads
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didFetchProfile profile: HomeViewModel.ProfileData) {
        updateProfileButton(withProfileData: profile)
    }

    func homeViewModelDidStartUploadingTrees(_ homeViewModel: HomeViewModel) {
        uploadTreesButton.uploadState = .stop
    }

    func homeViewModelDidStopUploadingTrees(_ homeViewModel: HomeViewModel) {
        uploadTreesButton.uploadState = .start
    }
}
