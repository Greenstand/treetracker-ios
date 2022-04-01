//
//  CustomCameraOverlayView.swift
//  TreeTracker
//
//  Created by Arwin Oblea on 8/9/21.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class CustomCameraOverlayView: UIView {
    weak var imagePicker: UIImagePickerController?
    lazy var gpsAccuracyLabel: GPSAccuracyLabel = {
        let gpsAccuracyLabel = GPSAccuracyLabel()
        gpsAccuracyLabel.accuracy = .unknown
        gpsAccuracyLabel.textAlignment = .center
        gpsAccuracyLabel.translatesAutoresizingMaskIntoConstraints = false
        return gpsAccuracyLabel
    }()
    lazy var searchGPSSignalImageView: UIImageView = {
        let searchGPSSignalImageView = UIImageView()
        searchGPSSignalImageView.contentMode = .scaleAspectFit
        searchGPSSignalImageView.animationImages = [
            Asset.Assets.GpsSearchAnimation.gpsLoad0,
            Asset.Assets.GpsSearchAnimation.gpsLoad1,
            Asset.Assets.GpsSearchAnimation.gpsLoad2
        ].map({$0.image})
        searchGPSSignalImageView.animationDuration = 0.9
        searchGPSSignalImageView.animationRepeatCount = 0
        searchGPSSignalImageView.image = Asset.Assets.GpsSearchAnimation.gpsLoad0.image
        searchGPSSignalImageView.startAnimating()
        searchGPSSignalImageView.translatesAutoresizingMaskIntoConstraints = false
        return searchGPSSignalImageView
    }()
    lazy var takePhotoButton: PrimaryButton = {
        let takePhotoButton = PrimaryButton()
        takePhotoButton.setTitle(L10n.AddTree.PhotoButton.Title.takePhoto, for: .normal)
        takePhotoButton.isEnabled = false
        takePhotoButton.isHidden = true
        return takePhotoButton
    }()
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private
    private func setupView() {
        addSubview(gpsAccuracyLabel)
        addSubview(searchGPSSignalImageView)
        addSubview(takePhotoButton)
        setupLayout()
        setupActions()
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            takePhotoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            takePhotoButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            takePhotoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 50),
            searchGPSSignalImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            searchGPSSignalImageView.bottomAnchor.constraint(equalTo: takePhotoButton.topAnchor, constant: -10),
            searchGPSSignalImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            searchGPSSignalImageView.heightAnchor.constraint(equalToConstant: 50),
            gpsAccuracyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            gpsAccuracyLabel.bottomAnchor.constraint(equalTo: searchGPSSignalImageView.topAnchor, constant: -10),
            gpsAccuracyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            gpsAccuracyLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
    }
    @objc private func takePhotoButtonTapped() {
        imagePicker?.takePicture()
    }
}

