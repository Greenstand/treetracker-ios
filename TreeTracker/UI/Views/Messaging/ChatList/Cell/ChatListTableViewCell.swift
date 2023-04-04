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

    @IBOutlet private var chatAlert: UIImageView! {
        didSet {
            chatAlert.image = Asset.Assets.bell.image.withRenderingMode(.alwaysTemplate)
            chatAlert.tintColor = .white
            chatAlert.backgroundColor = Asset.Colors.secondaryRed.color
            chatAlert.layer.cornerRadius = 10
            chatAlert.layer.masksToBounds = true
        }
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
    }
}
