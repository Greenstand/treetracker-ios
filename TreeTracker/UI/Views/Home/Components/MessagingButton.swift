//
//  MessagingButton.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class MessagingButton: UIButton {

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
}

private extension MessagingButton {

    func commonInit() {
        backgroundColor = Asset.Colors.primaryGreen.color
        tintColor = .white
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setAttributedTitle(attributedTitle, for: .normal)
    }

    func updateState() {
        if isHighlighted {
            backgroundColor = Asset.Colors.secondaryGreen.color
        } else {
            backgroundColor = Asset.Colors.primaryGreen.color
        }
    }

    var attributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: messageIconTextAttachment))
        attributedString.append(NSAttributedString(string: "   "))
        attributedString.append(NSAttributedString(string: title, attributes: textAttributes))
        return attributedString
    }

    var messageIconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.mail.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -15.0), size: CGSize(width: 50.0, height: 40.0))
        return textAttachment
    }

    var title: String {
        return L10n.Home.MessagingButton.title
    }

    var textAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0)
        ]
    }

}
