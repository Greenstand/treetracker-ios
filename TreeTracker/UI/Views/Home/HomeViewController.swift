//
//  HomeViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AlertPresenting {

    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
            profileImageView.layer.borderWidth = 2.0
            profileImageView.layer.borderColor = Asset.Colors.grayLight.color.withAlphaComponent(0.5).cgColor
            profileImageView.image = Asset.Assets.profile.image
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private var nameButton: UIButton! {
        didSet {
            nameButton.setTitle("", for: .normal)
            nameButton.titleLabel?.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            nameButton.setTitleColor(Asset.Colors.grayDark.color, for: .normal)
        }
    }
    @IBOutlet private var logoutButton: UIButton! {
        didSet {

            let imageAttachment = NSTextAttachment()
            imageAttachment.image = Asset.Assets.logout.image
            imageAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -3.0), size: CGSize(width: 16.0, height: 16.0))

            let attributedTitle = NSMutableAttributedString()
            attributedTitle.append(NSAttributedString(string: L10n.Home.LogoutButton.title))
            attributedTitle.append(NSAttributedString(string: "  "))
            attributedTitle.append(NSAttributedString(attachment: imageAttachment))

            logoutButton.setAttributedTitle(attributedTitle, for: .normal)
            logoutButton.setTitleColor(Asset.Colors.grayLight.color, for: .normal)
            logoutButton.titleLabel?.font = FontFamily.Lato.regular.font(size: 16)
        }
    }

    @IBOutlet private var treesPlantedView: UIView! {
        didSet {
            treesPlantedView.layer.cornerRadius = 5.0
            treesPlantedView.layer.masksToBounds = true
            treesPlantedView.backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.2)
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
            treesUploadedView.backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.2)
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
    @IBOutlet private var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.2)
        }
    }
    @IBOutlet private var uploadTreesButton: UploadsButton! {
        didSet {
            uploadTreesButton.isEnabled = false
        }
    }
    @IBOutlet private var uploadsCountView: UIView! {
        didSet {
            uploadsCountView.backgroundColor = .white
            uploadsCountView.layer.cornerRadius = uploadsCountLabel.frame.size.height / 2
            uploadsCountView.layer.masksToBounds = true
            uploadsCountView.isHidden = true
        }
    }
    @IBOutlet private var uploadsCountLabel: UILabel! {
        didSet {
            uploadsCountLabel.textColor = Asset.Colors.secondaryOrangeLight.color
            uploadsCountLabel.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            uploadsCountLabel.text = "0"
        }
    }
    @IBOutlet private var addTreeButton: AddTreeButton!

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
        viewModel?.fetchProfileData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0

    }
}

// MARK: - Private
private extension HomeViewController {

    func configureNameButton(name: String) {

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = Asset.Assets.arrow.image
        imageAttachment.bounds = CGRect(origin: .zero, size: CGSize(width: 13.0, height: 13.0))

        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(NSAttributedString(string: name))
        attributedTitle.append(NSAttributedString(string: " "))
        attributedTitle.append(NSAttributedString(attachment: imageAttachment))
        nameButton.setAttributedTitle(attributedTitle, for: .normal)
    }
}

// MARK: - Button Actions
private extension HomeViewController {

    @IBAction func nameButtonPressed() {
        viewModel?.viewProfileSelected()
    }

    @IBAction func addTreeButtonPressed() {
        viewModel?.addTreeSelected()
    }

    @IBAction func uploadTreesButtonPressed() {
        viewModel?.toggleTreeUploads()
    }

    @IBAction func logoutButtonPressed() {
        viewModel?.logoutPlanter()
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
        profileImageView.image = profile.image
        configureNameButton(name: profile.name)
    }

    func homeViewModelDidStartUploadingTrees(_ homeViewModel: HomeViewModel) {
        uploadTreesButton.uploadState = .stop
    }

    func homeViewModelDidStopUploadingTrees(_ homeViewModel: HomeViewModel) {
        uploadTreesButton.uploadState = .start
    }
}
