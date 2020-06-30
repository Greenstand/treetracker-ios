//
//  UploadsButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class UploadsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var isEnabled: Bool {
        didSet {
            updateState()
        }
    }
}

// MARK: - Private
private extension UploadsButton {

    func commonInit() {
        layer.borderWidth = 1.0
        layer.borderColor = Asset.Colors.grayLight.color.cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = true

        setAttributedTitle(normalAttributedTitle, for: .normal)
        setAttributedTitle(disabledAttributedTitle, for: .disabled)

        updateState()
    }

    func updateState() {
        if isEnabled {
            backgroundColor = Asset.Colors.primaryGreen.color
            tintColor = .white
        } else {
            backgroundColor = Asset.Colors.grayLight.color
            tintColor = Asset.Colors.grayDark.color
        }
    }

    var normalAttributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: L10n.Home.UploadButton.title, attributes: normalTextAttributes))
        return attributedString
    }

    var disabledAttributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: L10n.Home.UploadButton.title, attributes: normalTextAttributes))
        return attributedString
    }

    var normalTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: UIColor.white
        ]
    }

    var disabledTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: Asset.Colors.grayDark.color

        ]
    }

    var iconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.forward.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -20.0), size: CGSize(width: 50.0, height: 50))
        return textAttachment
    }
}
