//
//  SettingsViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/04/2022.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol SettingsViewModelViewDelegate: AnyObject {
    func settingViewModel(_ settingsViewModel: SettingsViewModel, didUpdatePhotoQuality photoQuality: PhotoQuality)
}

class SettingsViewModel {

    weak var viewDelegate: SettingsViewModelViewDelegate?

    private let settingsService: Treetracker_Core.SettingsService

    init(settingsService: Treetracker_Core.SettingsService) {
        self.settingsService = settingsService
    }

    let title: String = L10n.Settings.title

    func loadSettings() {
        viewDelegate?.settingViewModel(self, didUpdatePhotoQuality: currentPhotoQuality)
    }

    func selectPhotoQuality(atIndex index: Int) {
        let photoQuality = PhotoQuality.allCases[index]
        viewDelegate?.settingViewModel(self, didUpdatePhotoQuality: photoQuality)
        settingsService.update(value: photoQuality.photoSize, forSetting: .treePhotoSize)
        settingsService.update(value: photoQuality.compression, forSetting: .treePhotoCompression)
    }
}

// MARK: - Private

private extension SettingsViewModel {

    var currentPhotoQuality: PhotoQuality {
        guard let currentPhotoSize: Double = settingsService.value(forSetting: .treePhotoSize),
                let photoQuality = PhotoQuality.allCases.first(where: { $0.photoSize == currentPhotoSize }) else {
                    return defaultPhotoQuality
                }
        return photoQuality
    }

    var defaultPhotoQuality: PhotoQuality {
        return Configuration.DefaultTreePhotoImageQuality.defaultPhotoImageQuality
    }
}

// MARK: - PhotoQuality Extension
extension PhotoQuality {

    var title: String {
        switch self {
        case .low:
            return L10n.Settings.PhotoQuality.Option.Low.title
        case .medium:
            return L10n.Settings.PhotoQuality.Option.Medium.title
        case .high:
            return L10n.Settings.PhotoQuality.Option.High.title
        }
    }

    var info: String {
        switch self {
        case .low:
            return L10n.Settings.PhotoQuality.Option.Low.info
        case .medium:
            return L10n.Settings.PhotoQuality.Option.Medium.info
        case .high:
            return L10n.Settings.PhotoQuality.Option.High.info
        }
    }

    var index: Int {
        guard let index = PhotoQuality.allCases.firstIndex(of: self) else {
            fatalError("Index for PhotoQuality: \(self) not found in PhotoQuality.allCases")
        }
        return index
    }
}
