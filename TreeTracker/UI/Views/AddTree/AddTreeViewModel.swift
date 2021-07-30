//
//  AddTreeViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 12/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol AddTreeViewModelCoordinatorDelegate: AnyObject {
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didAddTree tree: Tree)
}

protocol AddTreeViewModelViewDelegate: AnyObject {
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTreeImage image: UIImage?)
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateGPSAccuracy accuracy: AddTreeViewModel.GPSAccuracy)
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTakePhotoEnabled enabled: Bool)
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateAddTreeEnabled enabled: Bool)
    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didReceiveError error: Error)
}

class AddTreeViewModel {

    weak var coordinatorDelegate: AddTreeViewModelCoordinatorDelegate?
    weak var viewDelegate: AddTreeViewModelViewDelegate?

    private let locationService: LocationService
    private let treeService: TreeService
    private let planter: Planter

    init(locationService: LocationService, treeService: TreeService, planter: Planter) {
        self.treeService = treeService
        self.planter = planter
        self.locationService = locationService
        locationService.delegate = self
    }

    let title: String = L10n.AddTree.title

    private var location: Location?

    private var image: UIImage? {
        didSet {
            viewDelegate?.addTreeViewModel(self, didUpdateTreeImage: image)
            viewDelegate?.addTreeViewModel(self, didUpdateAddTreeEnabled: addTreeEnabled)
        }
    }

    func saveTree() {

        guard let treeData = treeData else {
            viewDelegate?.addTreeViewModel(self, didReceiveError: AddTreeViewModel.Error.invalidTreeData)
            return
        }

        treeService.saveTree(treeData: treeData, forPlanter: planter) { (result) in
            switch result {
            case .success(let tree):
                coordinatorDelegate?.addTreeViewModel(self, didAddTree: tree)
            case .failure(let error):
                viewDelegate?.addTreeViewModel(self, didReceiveError: error)
            }
        }
    }

    func updateTreeImage(treeImage: UIImage) {
        image = treeImage
        location = locationService.location
    }

    func startMonitoringLocation() {
        locationService.startMonitoringLocation()
    }

    func stopMonitoringLocation() {
        locationService.stopMonitoringLocation()
    }
}

// MARK: - Private
private extension AddTreeViewModel {

    var addTreeEnabled: Bool {
        guard image != nil else {
            return false
        }
        return true
    }

    var takePhotoActionTitle: String {
        guard image != nil else {
            return L10n.AddTree.PhotoButton.Title.takePhoto
        }
        return L10n.AddTree.PhotoButton.Title.retake
    }

    var treeData: TreeServiceData? {

        guard let location = location,
              let imageData = image?.jpegData(compressionQuality: 1.0) else {
            return nil
        }

        return TreeServiceData(
            jpegData: imageData,
            location: location
        )
    }
}

// MARK: - LocationServiceDelegate
extension AddTreeViewModel: LocationServiceDelegate {

    func locationService(_ locationService: LocationService, didUpdateAccuracy accuracy: Double?) {

        var gpsAccuracy: GPSAccuracy {

            guard let accuracy = accuracy else {
                return .unknown
            }

            guard accuracy < 10 else {
                return .bad
            }

            return .good
        }

        viewDelegate?.addTreeViewModel(self, didUpdateGPSAccuracy: gpsAccuracy)
        viewDelegate?.addTreeViewModel(self, didUpdateTakePhotoEnabled: gpsAccuracy == .good)
    }
}

// MARK: - Data Structures
extension AddTreeViewModel {

    enum GPSAccuracy {
        case good
        case bad
        case unknown
    }
}

// MARK: - Error
extension AddTreeViewModel {

    enum Error: Swift.Error {
        case invalidTreeData
    }
}
