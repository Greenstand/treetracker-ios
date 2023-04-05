//
//  MessagesTableViewCell.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 04/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet private var messageBackgroundView: UIView! {
        didSet {
            messageBackgroundView.layer.cornerRadius = 16
            messageBackgroundView.clipsToBounds = true
            messageBackgroundView.backgroundColor = .systemBlue
        }
    }

    @IBOutlet private var messageLabel: UILabel! {
        didSet {
            messageLabel.font = FontFamily.Lato.regular.font(size: 16)
            messageLabel.numberOfLines = 0
            messageLabel.textColor = UIColor.white
        }
    }

    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!

    static let identifier: String = "MessagesTableViewCell"
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
extension MessagesTableViewCell {

    func setupCell(message: Message?) {
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)

        messageLabel.text = message?.body

        // TODO: if messsage.from == planter.name?
        if message?.from == "admin" {

            messageBackgroundView.backgroundColor = .systemGreen
            leadingConstraint.isActive = true
            messageLabel.textAlignment = .left

        } else {

            messageBackgroundView.backgroundColor = .systemBlue
            trailingConstraint.isActive = true
            messageLabel.textAlignment = .right

        }

    }

}
