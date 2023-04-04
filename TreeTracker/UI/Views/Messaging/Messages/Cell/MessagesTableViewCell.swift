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

    @IBOutlet private var messageLabel: UILabel!

    static let identifier: String = "MessagesTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

}

// MARK: - Public func
extension MessagesTableViewCell {

    func setupCell(message: Message?) {
        messageLabel.text = message?.body
    }

}
