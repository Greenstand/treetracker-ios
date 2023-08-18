//
//  SyncMessagesButton.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 17/08/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class SyncMessagesButton: UIButton {

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var isHighlighted: Bool {
        didSet {
            updateState()
        }
    }

    var isLoading: Bool = false {
        didSet {
            updateUploadState()
        }
    }
}

// MARK: - Private
private extension SyncMessagesButton {

    func commonInit() {
        backgroundColor = Asset.Colors.primaryGreen.color
        tintColor = .white
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setAttributedTitle(normalAttributedTitle, for: .normal)

        addSubview(loadingSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 25.0).isActive = true

        updateState()
        updateUploadState()
    }

    func updateState() {
        if isHighlighted {
            backgroundColor = Asset.Colors.secondaryGreen.color
        } else {
            backgroundColor = Asset.Colors.primaryGreen.color
        }
    }

    func updateUploadState() {
        if isLoading {
            loadingSpinner.startAnimating()
            setAttributedTitle(loadingAttributedTitle, for: .normal)
        } else {
            loadingSpinner.stopAnimating()
            setAttributedTitle(normalAttributedTitle, for: .normal)
        }
    }

    var normalAttributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: L10n.ChatList.SyncMessages.Normal.title, attributes: textAttributes))
        return attributedString
    }

    var loadingAttributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: L10n.ChatList.SyncMessages.Loading.title, attributes: textAttributes))
        return attributedString
    }

    var textAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0)
        ]
    }
}
