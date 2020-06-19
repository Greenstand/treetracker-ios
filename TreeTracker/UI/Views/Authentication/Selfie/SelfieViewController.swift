//
//  SelfieViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SelfieViewControllerDelegate: class {
    func selfieViewControllerDidStoreSelfie(_ selfieViewController: SelfieViewController)
}

class SelfieViewController: UIViewController {

    @IBOutlet fileprivate var selfiePreviewImageView: UIImageView! {
        didSet {
            selfiePreviewImageView.layer.cornerRadius = 20.0
            selfiePreviewImageView.layer.masksToBounds = true
            selfiePreviewImageView.layer.borderColor = Asset.Colors.grayDark.color.cgColor
            selfiePreviewImageView.layer.borderWidth = 5.0
            selfiePreviewImageView.clipsToBounds = true
        }
    }
    @IBOutlet fileprivate var takeSelfieButton: PrimaryButton!
    @IBOutlet fileprivate var doneButton: PrimaryButton!

    var viewModel: SelfieViewModel?
    weak var delegate: SelfieViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updateView(self)
    }
}

// MARK: - Button Actions

private extension SelfieViewController {

    @IBAction func takeSelfieButtonPressed() {
        displayImagePicker()
    }

    @IBAction func doneButtonPressed() {
        delegate?.selfieViewControllerDidStoreSelfie(self)
    }
}

// MARK: - Private Functions

private extension SelfieViewController {

    func displayImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        present(imagePicker, animated: true)
    }
}

extension SelfieViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let editedImage: UIImage? = info[.editedImage] as? UIImage

        guard let originalImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        picker.dismiss(animated: true) {
            self.viewModel?.updateImage(image: editedImage ?? originalImage)
            self.viewModel?.updateView(self)
        }
    }
}

extension SelfieViewModel {

    func updateView(_ view: SelfieViewController) {
        view.takeSelfieButton.setTitle(selfieButtonTitle, for: .normal)
        view.title = title
        view.selfiePreviewImageView.image = selfiePreviewImage
        view.selfiePreviewImageView.contentMode = selfiePreviewContentMode
        view.doneButton.isEnabled = doneButtonEnabled
    }
}
