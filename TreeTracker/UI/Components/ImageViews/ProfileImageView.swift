//
//  ProfileimageView.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/04/2022.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = Asset.Colors.grayLight.color.withAlphaComponent(0.5).cgColor
        self.image = Asset.Assets.profile.image
        self.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2.0
    }
}
