//
//  MyTreesButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 21/11/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class MyTreesButton: UIButton {

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
private extension MyTreesButton {

    func commonInit() {
        backgroundColor = Asset.Colors.primaryGreen.color
        tintColor = .white
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setAttributedTitle(attributedTitle, for: .normal)
    }

    var attributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: title, attributes: textAttributes))
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(attachment: iconTextAttachment))
        return attributedString
    }

    var textAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0)
        ]
    }

    var title: String {
        return L10n.Home.MyTreesButton.title
    }

    var iconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.arrow.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -3.0), size: CGSize(width: 20.0, height: 20))
        return textAttachment
    }
}
