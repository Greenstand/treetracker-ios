//
//  SelfieViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 18/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SelfieViewModelCoordinatorDelegate: class {
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didTakeSelfieForPlanter planter: Planter)
}

protocol SelfieViewModelViewDelegate: class {
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didReceiveError error: Error)
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdatePreviewImage image: UIImage)
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdateSaveSelfieEnabled enabled: Bool)
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdateSelfieActionTitle title: String)
    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdatePreviewContentMode contentMode: UIView.ContentMode)
}

class SelfieViewModel {

    weak var coordinatorDelegate: SelfieViewModelCoordinatorDelegate?
    weak var viewDelegate: SelfieViewModelViewDelegate?

    private let selfieService: SelfieService
    private let planter: Planter

    init(planter: Planter, selfieService: SelfieService) {
        self.planter = planter
        self.selfieService = selfieService
    }

    let title: String = L10n.Selfie.title

    var image: UIImage? {
        didSet {
            viewDelegate?.selfieViewModel(self, didUpdatePreviewImage: selfiePreviewImage)
            viewDelegate?.selfieViewModel(self, didUpdateSaveSelfieEnabled: saveSelfieEnabled)
            viewDelegate?.selfieViewModel(self, didUpdateSelfieActionTitle: selfieActionTitle)
            viewDelegate?.selfieViewModel(self, didUpdatePreviewContentMode: selfiePreviewContentMode)
        }
    }

    func storeSelfie() {

        guard let selfie = selfie else {
            viewDelegate?.selfieViewModel(self, didReceiveError: SelfieViewModel.Error.invalidSelfieData)
            return
        }

        selfieService.storeSelfie(selfieData: selfie, forPlanter: planter) { (result) in
            switch result {
            case .success(let planter):
                coordinatorDelegate?.selfieViewModel(self, didTakeSelfieForPlanter: planter)
            case .failure(let error):
                viewDelegate?.selfieViewModel(self, didReceiveError: error)
            }
        }
    }
}

// MARK: - Private
private extension SelfieViewModel {

    var selfiePreviewImage: UIImage {
        guard let image = image else {
            return Asset.Assets.selfie.image
        }
        return image
    }

    var selfiePreviewContentMode: UIView.ContentMode {
        guard image != nil else {
            return .scaleAspectFit
        }
        return .scaleAspectFill
    }

    var saveSelfieEnabled: Bool {
        return image != nil
    }

    var selfieActionTitle: String {
        guard image != nil else {
            return L10n.Selfie.PhotoButton.Title.takePhoto
        }
        return L10n.Selfie.PhotoButton.Title.retake
    }

    var selfie: SelfieData? {
        guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return SelfieData(jpegData: imageData)
    }
}

// MARK: - Error
extension SelfieViewModel {

    enum Error: Swift.Error {
        case invalidSelfieData
    }
}
