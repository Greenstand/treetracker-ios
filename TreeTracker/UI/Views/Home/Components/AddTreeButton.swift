//
//  AddTreeButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class AddTreeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Private
private extension AddTreeButton {

    func commonInit() {
        backgroundColor = Asset.Colors.primaryGreen.color
        tintColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = Asset.Colors.grayLight.color.cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setAttributedTitle(attributedTitle, for: .normal)
    }

    var attributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "+", attributes: textAttributes))
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: title, attributes: textAttributes))
        return attributedString
    }

    var textAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.boldSystemFont(ofSize: 20.0)
        ]
    }

    var title: String {
        return L10n.Home.AddTreeButton.title
    }

    var icon: UIImage {
        return Asset.Assets.saplingIcon.image
    }

    var iconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = icon
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -50.0), size: CGSize(width: 50.0, height: 100.0))
        return textAttachment
    }
}
