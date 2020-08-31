//
//  AddTreeViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 12/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class AddTreeViewController: UIViewController, AlertPresenting {

    @IBOutlet private var treeImageView: UIImageView! {
        didSet {

            treeImageView.layer.cornerRadius = 20.0
            treeImageView.layer.masksToBounds = true
            treeImageView.layer.borderColor = Asset.Colors.grayDark.color.cgColor
            treeImageView.layer.borderWidth = 5.0
            treeImageView.clipsToBounds = true
            treeImageView.contentMode = .scaleAspectFill
            treeImageView.image = Asset.Assets.saplingIcon.image
        }
    }
    @IBOutlet private var gpsAccuracyLabel: GPSAccuracyLabel! {
        didSet {
            gpsAccuracyLabel.accuracy = .unknown
        }
    }
    @IBOutlet private var takePhotoButton: PrimaryButton! {
        didSet {
            takePhotoButton.setTitle(L10n.AddTree.PhotoButton.Title.takePhoto, for: .normal)
        }
    }
    @IBOutlet private var saveTreeButton: PrimaryButton! {
        didSet {
            saveTreeButton.setTitle(L10n.AddTree.SaveButton.title, for: .normal)
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
            self.viewModel?.image = editedImage ?? originalImage
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
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTreeImage image: UIImage) {
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
