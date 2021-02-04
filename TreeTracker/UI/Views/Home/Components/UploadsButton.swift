//
//  UploadsButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class UploadsButton: UIButton {

    enum UploadState {
        case start
        case stop
    }

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

    var uploadState: UploadState = .start {
        didSet {
            updatUploadeState()
        }
    }
}

// MARK: - Private
private extension UploadsButton {

    func commonInit() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true

        updateState()
        updatUploadeState()
    }

    func updateState() {
        if isEnabled {
            backgroundColor = Asset.Colors.primaryGreen.color
            tintColor = .white
        } else {
            backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.2)
            tintColor = Asset.Colors.grayLight.color
        }
    }

    func updatUploadeState() {
        switch uploadState {
        case .start:
            setAttributedTitle(startUploadsAttributedTitle(withAtributes: normalTextAttributes), for: .normal)
            setAttributedTitle(startUploadsAttributedTitle(withAtributes: disabledTextAttributes), for: .disabled)
        case .stop:
            setAttributedTitle(stopUploadsAttributedTitle(withAtributes: normalTextAttributes), for: .normal)
            setAttributedTitle(stopUploadsAttributedTitle(withAtributes: disabledTextAttributes), for: .disabled)
        }
    }

    func startUploadsAttributedTitle(withAtributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: L10n.Home.UploadTreesButton.Title.start, attributes: attributes))
        return attributedString
    }

    func stopUploadsAttributedTitle(withAtributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: L10n.Home.UploadTreesButton.Title.stop, attributes: attributes))
        return attributedString
    }

    var normalTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0) ,
            .foregroundColor: UIColor.white
        ]
    }

    var disabledTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0),
            .foregroundColor: Asset.Colors.grayLight.color.withAlphaComponent(0.5)
        ]
    }

    var iconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.upload.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -20.0), size: CGSize(width: 50.0, height: 50))
        return textAttachment
    }
}
