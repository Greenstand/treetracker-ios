//
//  SelfieViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SelfieViewController: UIViewController, AlertPresenting {

    @IBOutlet private var selfiePreviewImageView: UIImageView! {
        didSet {
            selfiePreviewImageView.layer.cornerRadius = 20.0
            selfiePreviewImageView.layer.masksToBounds = true
            selfiePreviewImageView.layer.borderColor = Asset.Colors.grayDark.color.cgColor
            selfiePreviewImageView.layer.borderWidth = 5.0
            selfiePreviewImageView.clipsToBounds = true
            selfiePreviewImageView.contentMode = .scaleAspectFit
            selfiePreviewImageView.image = Asset.Assets.selfie.image
        }
    }
    @IBOutlet private var takeSelfieButton: PrimaryButton! {
        didSet {
            takeSelfieButton.setTitle(L10n.Selfie.PhotoButton.Title.takePhoto, for: .normal)
        }
    }
    @IBOutlet private var fromLibraryButton: PrimaryButton! {
        didSet {
            fromLibraryButton.setTitle(L10n.Selfie.LibraryButton.Title.libraryPhoto, for: .normal)
            fromLibraryButton.isHidden = true
            #if DEBUG
            fromLibraryButton.isHidden = false
            #endif
        }
    }
    @IBOutlet private var doneButton: PrimaryButton! {
        didSet {
            doneButton.setTitle(L10n.Selfie.SaveButton.title, for: .normal)
            doneButton.isEnabled = false
        }
    }

    var viewModel: SelfieViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.image = nil
    }
}

// MARK: - Button Actions
private extension SelfieViewController {
#if DEBUG
    @IBAction func fromLibraryButtonPressed() {
        displayImagePicker(mode: .photoLibrary)
    }
#endif
    @IBAction func takeSelfieButtonPressed() {
        displayImagePicker(mode: .camera)
    }

    @IBAction func doneButtonPressed() {
        viewModel?.storeSelfie()
    }
}

// MARK: - Private
private extension SelfieViewController {

    func displayImagePicker(mode: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = mode
        if mode == .camera {
            imagePicker.cameraDevice = .front
        }
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SelfieViewController: UIImagePickerControllerDelegate {

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
extension SelfieViewController: UINavigationControllerDelegate { }

// MARK: - SelfieViewModelViewDelegate
extension SelfieViewController: SelfieViewModelViewDelegate {

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdateSelfieActionTitle title: String) {
        takeSelfieButton.setTitle(title, for: .normal)
    }

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdatePreviewContentMode contentMode: UIView.ContentMode) {
        selfiePreviewImageView.contentMode = contentMode
    }

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdateSaveSelfieEnabled enabled: Bool) {
        doneButton.isEnabled = enabled
    }

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func selfieViewModel(_ selfieViewModel: SelfieViewModel, didUpdatePreviewImage image: UIImage) {
        selfiePreviewImageView.image = image
    }
}
