//
//  SettingsViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/04/2022.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private var photoQualityTitleLabel: UILabel! {
        didSet {
            photoQualityTitleLabel.text = L10n.Settings.PhotoQuality.title
            photoQualityTitleLabel.font = FontFamily.Montserrat.bold.font(size: 16.0)
            photoQualityTitleLabel.textColor = Asset.Colors.grayDark.color
        }
    }

    @IBOutlet private var photoQualitySegmentedControl: UISegmentedControl! {
        didSet {
            photoQualitySegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
            photoQualitySegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.Colors.grayDark.color], for: .selected)
            photoQualitySegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.Colors.grayLight.color], for: .normal)
        }
    }

    @IBOutlet private var photoQualityInfoLabel: UILabel! {
        didSet {
            photoQualityInfoLabel.text = ""
            photoQualityInfoLabel.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
            photoQualityInfoLabel.textColor = Asset.Colors.grayMedium.color
        }
    }

    var viewModel: SettingsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePhotoQualitySegmentedControl()
        viewModel?.loadSettings()
    }
}

// MARK: - Button Actions
private extension SettingsViewController {

    @IBAction func photoQualitySegmentedControlDidChange(sender: UISegmentedControl) {
        viewModel?.selectPhotoQuality(atIndex: sender.selectedSegmentIndex)
    }
}

// MARK: - Private
private extension SettingsViewController {

    func configurePhotoQualitySegmentedControl() {

        photoQualitySegmentedControl.removeAllSegments()

        PhotoQuality.allCases.forEach { photoQuality in
            photoQualitySegmentedControl.insertSegment(
                withTitle: photoQuality.title,
                at: photoQuality.index,
                animated: false
            )
        }
    }
}

// MARK: - SettingsViewModelViewDelegate
extension SettingsViewController: SettingsViewModelViewDelegate {

    func settingViewModel(_ settingsViewModel: SettingsViewModel, didUpdatePhotoQuality photoQuality: PhotoQuality) {
        photoQualitySegmentedControl.selectedSegmentIndex = photoQuality.index
        photoQualityInfoLabel.text = photoQuality.info
    }
}
