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
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        return takePhotoButton
    }()
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        stackView.addArrangedSubview(gpsAccuracyLabel)
        stackView.addArrangedSubview(searchGPSSignalImageView)
        stackView.addArrangedSubview(takePhotoButton)
        setupLayout()
        setupActions()
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            gpsAccuracyLabel.heightAnchor.constraint(equalToConstant: 50),
            searchGPSSignalImageView.heightAnchor.constraint(equalToConstant: 50),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 50),
            backgroundView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 184),
            stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: -40),
            stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
    private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
    }
    @objc private func takePhotoButtonTapped() {
        imagePicker?.takePicture()
    }
}
