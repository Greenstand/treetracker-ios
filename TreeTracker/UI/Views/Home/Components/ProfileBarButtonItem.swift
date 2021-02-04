//
//  ProfileBarButtonItem.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/02/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

// This is a lot of code for a simple button...
// Should create a simpler one or use a tab bar.

class ProfileBarButtonItem: UIBarButtonItem {

    private var onSelection: (() -> Void)?

    convenience init(planterName: String, planterImage: UIImage, action: (() -> Void)?) {

        // UIBarButton requires the image to be a 1 color
        // We need a custom view to use our selfie image

        let stackView = UIStackView(arrangedSubviews: [
            Self.profileImageView(withImage: planterImage),
            Self.label(withText: planterName),
            Self.arrowImage
        ])
        stackView.spacing = 5.0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.init(customView: stackView)

        // UIBarButtonItem with custom view cant take an action
        // Add a tap gesture recognizer to the stackview instead
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        self.onSelection = action
    }
}

// MARK: - Private
private extension ProfileBarButtonItem {

    static func profileImageView(withImage image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Asset.Colors.grayDark.color.cgColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    static func label(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = FontFamily.Lato.regular.font(size: 20.0)
        label.textColor = Asset.Colors.grayDark.color
        return label
    }

    static var arrowImage: UIImageView {
        let arrowImage = UIImageView(image: Asset.Assets.arrow.image)
        arrowImage.tintColor = Asset.Colors.grayDark.color
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return arrowImage
    }

    @objc func buttonPressed() {
        onSelection?()
    }
}
