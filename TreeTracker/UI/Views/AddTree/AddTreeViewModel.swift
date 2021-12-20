//
//  AddTreeViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 12/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

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

    private let locationProvider: LocationProvider
    private let treeService: TreeService
    private let locationDataCapturer: LocationDataCapturing
    private let planter: Planter
    private let treeUUID: String

    init(
        locationProvider: LocationProvider,
        treeService: TreeService,
        locationDataCapturer: LocationDataCapturing,
        planter: Planter
    ) {
        self.treeUUID = UUID().uuidString

        self.treeService = treeService
        self.locationDataCapturer = locationDataCapturer
        self.planter = planter
        self.locationProvider = locationProvider

        locationDataCapturer.delegate = self
        locationProvider.delegate = self
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
        location = locationProvider.location
    }

    func startMonitoringLocation() {
        locationProvider.startMonitoringLocation()
    }

    func stopMonitoringLocation() {
        locationProvider.stopMonitoringLocation()
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
                let image = image,
                let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: 500.0, height: 500.0)),
                let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }

        return TreeServiceData(
            jpegData: imageData,
            location: location,
            uuid: self.treeUUID
        )
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
       let size = image.size

       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height

       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if widthRatio > heightRatio {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
       }

       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage
   }
}

// MARK: - LocationServiceDelegate
extension AddTreeViewModel: LocationProviderDelegate {
    func locationProvider(_ locationProvider: LocationProvider, didUpdateLocation location: Location?) {
        if let location = location {
            self.locationDataCapturer.addLocation(location: location, forTree: self.treeUUID, planter: self.planter)
        }
    }
}

// MARK: - LocationServiceDelegate
extension AddTreeViewModel: LocationDataCapturerDelegate {
    func locationDataCapturer(_ locationDataCapturer: LocationDataCapturing, didUpdateConvergenceStatus convergenceStatus: ConvergenceStatus) {
        switch convergenceStatus {
        case .notConverged:
            viewDelegate?.addTreeViewModel(self, didUpdateGPSAccuracy: .bad)
        case .converged:
            viewDelegate?.addTreeViewModel(self, didUpdateGPSAccuracy: .good)
            viewDelegate?.addTreeViewModel(self, didUpdateTakePhotoEnabled: true)
        case .timedOut:
            viewDelegate?.addTreeViewModel(self, didUpdateTakePhotoEnabled: false)
            viewDelegate?.addTreeViewModel(self, didUpdateGPSAccuracy: .bad)
            viewDelegate?.addTreeViewModel(self, didReceiveError: AddTreeViewModel.Error.gpsTimeout)
        }
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
        case gpsTimeout
    }
}
