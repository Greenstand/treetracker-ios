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
            treesPlantedView.backgroundColor = Asset.Colors.grayLightest.color
        }
    }
    @IBOutlet private var treesPlantedLabel: UILabel! {
        didSet {
            treesPlantedLabel.text = L10n.Home.InfoLabel.TreesPlantedLabel.text
            treesPlantedLabel.font = .systemFont(ofSize: 16.0)
        }
    }
    @IBOutlet private var treesPlantedCountLabel: UILabel! {
        didSet {
            treesPlantedCountLabel.font = .boldSystemFont(ofSize: 16.0)
        }
    }
    @IBOutlet private var treesPlantedImageview: UIImageView! {
        didSet {
            treesPlantedImageview.tintColor = Asset.Colors.primaryGreen.color
        }
    }
    @IBOutlet private var treesUploadedView: UIView! {
        didSet {
            treesUploadedView.layer.cornerRadius = 5.0
            treesUploadedView.layer.masksToBounds = true
            treesUploadedView.backgroundColor = Asset.Colors.grayLightest.color
        }
    }
    @IBOutlet private var treesUploadedLabel: UILabel! {
        didSet {
            treesUploadedLabel.text = L10n.Home.InfoLabel.TreesUploadedLabel.text
            treesUploadedLabel.font = .systemFont(ofSize: 16.0)
        }
    }
    @IBOutlet private var treesUploadedCountLabel: UILabel! {
        didSet {
            treesUploadedCountLabel.font = .boldSystemFont(ofSize: 16.0)
        }
    }
    @IBOutlet private var treesUploadedImageview: UIImageView! {
        didSet {
            treesUploadedImageview.tintColor = Asset.Colors.primaryGreen.color
        }
    }
    @IBOutlet private var addTreeButton: AddTreeButton!
    @IBOutlet private var uploadsButton: UploadsButton!
    @IBOutlet private var uploadsCountView: UIView! {
        didSet {
            uploadsCountView.backgroundColor = Asset.Colors.secondaryOrangeDark.color
            uploadsCountView.layer.cornerRadius = uploadsCountLabel.frame.size.height / 2
            uploadsCountView.layer.masksToBounds = true
            uploadsCountView.isHidden = true
        }
    }
    @IBOutlet private var uploadsCountLabel: UILabel! {
        didSet {
            uploadsCountLabel.textColor = .white
            uploadsCountLabel.font = .boldSystemFont(ofSize: 20.0)
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
        viewModel?.fetchTrees()
        self.showLogoutButton()
    }

    private func showLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutButtonPressed))
        self.navigationItem.rightBarButtonItem = logoutButton
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

    @objc func logoutButtonPressed() {
        self.viewModel?.logoutPlanter()
    }
}

// MARK: - HomeViewModelViewDelegate
extension HomeViewController: HomeViewModelViewDelegate {

    func homeViewModel(_ homeViewModel: HomeViewModel, didUpdateTreeCount data: HomeViewModel.TreeCountData) {
        treesPlantedCountLabel.text = "\(data.planted)"
        treesUploadedCountLabel.text = "\(data.uploaded) / \(data.planted)"
        uploadsButton.isEnabled = data.hasPendingUploads
        uploadsCountLabel.text = "\(data.pendingUpload)"
        uploadsCountView.isHidden = !data.hasPendingUploads
    }

    func homeViewModel(_ homeViewModel: HomeViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}
