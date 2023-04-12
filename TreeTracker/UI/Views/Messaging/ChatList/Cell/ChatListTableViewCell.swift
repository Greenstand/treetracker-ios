//
//  ChatListTableViewCell.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet private var chatImage: UIImageView! {
        didSet {
            chatImage.contentMode = .scaleAspectFill
            chatImage.layer.cornerRadius = 20
            chatImage.backgroundColor = Asset.Colors.secondaryGreen.color
        }
    }

    @IBOutlet private var chatTitle: UILabel! {
        didSet {
            chatTitle.font = FontFamily.Montserrat.semiBold.font(size: 19)
            chatTitle.textColor = Asset.Colors.grayDark.color
        }
    }

    @IBOutlet private var chatAlertCountView: UIView! {
        didSet {
            chatAlertCountView.backgroundColor = Asset.Colors.secondaryRed.color
            chatAlertCountView.layer.cornerRadius = 15
            chatAlertCountView.isHidden = true
        }
    }

    @IBOutlet private var chatAlertCountLabel: UILabel! {
        didSet {
            chatAlertCountLabel.textColor = .white
            chatAlertCountLabel.font = FontFamily.Montserrat.semiBold.font(size: 20.0)
            chatAlertCountLabel.textAlignment = .center
            chatAlertCountLabel.isHidden = true
        }
    }

    override func prepareForReuse() {
        chatAlertCountView.isHidden = true
        chatAlertCountLabel.isHidden = true
    }

    static let identifier = "ChatListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

}

// MARK: - Public Actions
extension ChatListTableViewCell {

    func setupCell() {
        chatImage.image = Asset.Assets.trees.image
        chatTitle.text = "Admin"

        chatAlertCountView.isHidden = false
        chatAlertCountLabel.isHidden = false
        chatAlertCountLabel.text = "7"
    }
}
