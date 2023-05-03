//
//  MessageTableViewCell.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 04/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

class MessageTableViewCell: UITableViewCell {

    @IBOutlet private var messageBackgroundView: UIView! {
        didSet {
            messageBackgroundView.layer.cornerRadius = 16
            messageBackgroundView.clipsToBounds = true
        }
    }

    @IBOutlet private var messageLabel: UILabel! {
        didSet {
            messageLabel.font = FontFamily.Lato.regular.font(size: 16)
            messageLabel.numberOfLines = 0
            messageLabel.textColor = UIColor.white
            messageLabel.textAlignment = .left
        }
    }

    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!

    static let identifier: String = "MessageTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        trailingConstraint.isActive = false
        leadingConstraint.isActive = false
    }

}

// MARK: - Public func
extension MessageTableViewCell {

    func setupCell(message: MessageEntity) {
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)

        messageLabel.text = message.body

        if message.from == "admin" {
            messageBackgroundView.backgroundColor = .systemGreen
            leadingConstraint.isActive = true
        } else {
            messageBackgroundView.backgroundColor = .systemBlue
            trailingConstraint.isActive = true
        }
    }

}
