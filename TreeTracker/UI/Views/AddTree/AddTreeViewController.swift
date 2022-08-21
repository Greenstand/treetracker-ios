//
//  AddTreeViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 12/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController, AlertPresenting {

    @IBOutlet private var viewfinderGuidenceImageView: UIImageView! {
        didSet {
            viewfinderGuidenceImageView.contentMode = .scaleAspectFit
            viewfinderGuidenceImageView.image = Asset.Assets.phoneViewfinder.image
            viewfinderGuidenceImageView.isHidden = false
        }
    }
    @IBOutlet private var treeGuidenceImageView: UIImageView! {
        didSet {
            treeGuidenceImageView.contentMode = .scaleAspectFit
            treeGuidenceImageView.image = Asset.Assets.planting.image
            treeGuidenceImageView.isHidden = false
        }
    }
    @IBOutlet private var treeImageView: UIImageView! {
        didSet {
            treeImageView.layer.cornerRadius = 5.0
            treeImageView.layer.masksToBounds = true
            treeImageView.clipsToBounds = true

            treeImageView.contentMode = .scaleAspectFill
            treeImageView.image = nil
            treeImageView.isHidden = true
        }
    }
    @IBOutlet private var gpsAccuracyLabel: GPSAccuracyLabel! {
        didSet {
            gpsAccuracyLabel.accuracy = .unknown
        }
    }
    @IBOutlet private var choosePhotoButton: PrimaryButton! {
        didSet {
            choosePhotoButton.setTitle(L10n.AddTree.PhotoLibraryButton.title, for: .normal)
            choosePhotoButton.isHidden = true
            #if DEBUG
            choosePhotoButton.isHidden = false
            #endif
        }
    }
    @IBOutlet private var takePhotoButton: PrimaryButton! {
        didSet {
            takePhotoButton.setTitle(L10n.AddTree.PhotoButton.Title.takePhoto, for: .normal)
                takePhotoButton.isEnabled = false
                takePhotoButton.isHidden = true
        }
    }
    @IBOutlet private var saveTreeButton: PrimaryButton! {
        didSet {
            saveTreeButton.setTitle(L10n.AddTree.SaveButton.title, for: .normal)
            saveTreeButton.isEnabled = false
        }
    }
    @IBOutlet weak var searchGPSSignalImageView: UIImageView! {
        didSet {
            searchGPSSignalImageView.animationImages = [
                Asset.Assets.GpsSearchAnimation.gpsLoad0,
                Asset.Assets.GpsSearchAnimation.gpsLoad1,
                Asset.Assets.GpsSearchAnimation.gpsLoad2
            ].map({$0.image})
                searchGPSSignalImageView.animationDuration = 0.9
                searchGPSSignalImageView.animationRepeatCount = 0
                searchGPSSignalImageView.image = Asset.Assets.GpsSearchAnimation.gpsLoad0.image
                searchGPSSignalImageView.startAnimating()
        }
    }
    var viewModel: AddTreeViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.startMonitoringLocation()
    }
}

// MARK: - Button Actions
private extension AddTreeViewController {

#if DEBUG
    @IBAction func choosePhotoButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
#endif

    @IBAction func takePhotoButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        present(imagePicker, animated: true)
    }

    @IBAction func saveTreeButtonPressed() {
        viewModel?.saveTree()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddTreeViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let editedImage: UIImage? = info[.editedImage] as? UIImage

        guard let originalImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        picker.dismiss(animated: true) {
            self.viewModel?.updateTreeImage(treeImage: editedImage ?? originalImage)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension AddTreeViewController: UINavigationControllerDelegate { }

// MARK: - HomeViewModelViewDelegate
extension AddTreeViewController: AddTreeViewModelViewDelegate {

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTakePhotoEnabled enabled: Bool) {
        takePhotoButton.isEnabled = enabled
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateAddTreeEnabled enabled: Bool) {
        saveTreeButton.isEnabled = enabled
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateGPSAccuracy accuracy: AddTreeViewModel.GPSAccuracy) {
        gpsAccuracyLabel.accuracy = accuracy.gpsLabelAccuracy
        switch accuracy {
        case .good:
            searchGPSSignalImageView.stopAnimating()
            searchGPSSignalImageView.isHidden = true
            takePhotoButton.isEnabled = true
            takePhotoButton.isHidden = false
        case .bad, .unknown:
            searchGPSSignalImageView.startAnimating()
            searchGPSSignalImageView.isHidden = false
            takePhotoButton.isEnabled = false
            takePhotoButton.isHidden = true
        }
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTreeImage image: UIImage?) {
        treeGuidenceImageView.isHidden = image != nil
        viewfinderGuidenceImageView.isHidden = image != nil
        treeImageView.isHidden = image == nil
        treeImageView.image = image
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}

// MARK: - AddTreeViewModel.GPSAccuracy Extension
private extension AddTreeViewModel.GPSAccuracy {

    var gpsLabelAccuracy: GPSAccuracyLabel.Accuracy {
        switch self {
        case .bad:
            return .bad
        case .good:
            return .good
        case .unknown:
            return .unknown
        }
    }
}
