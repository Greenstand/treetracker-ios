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
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setAttributedTitle(attributedTitle, for: .normal)
    }

    var attributedTitle: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: treeIconTextAttachment))
        attributedString.append(NSAttributedString(string: "   "))
        attributedString.append(NSAttributedString(attachment: plusIconTextAttachment))
        return attributedString
    }

    var title: String {
        return L10n.Home.AddTreeButton.title
    }

    var plusIconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.add.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -20.0), size: CGSize(width: 40.0, height: 40.0))
        return textAttachment
    }
    var treeIconTextAttachment: NSTextAttachment {
        let textAttachment = NSTextAttachment()
        textAttachment.image = Asset.Assets.seed.image
        textAttachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: -30.0), size: CGSize(width: 60.0, height: 60.0))
        return textAttachment
    }
}
