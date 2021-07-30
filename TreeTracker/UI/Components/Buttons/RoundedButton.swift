//
//  RoundedButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/07/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    func commonInit() {

        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        clipsToBounds = true

        setTitleColor(.white, for: .normal)
        setTitleColor(Asset.Colors.grayDark.color, for: .disabled)
        titleLabel?.font = FontFamily.Montserrat.semiBold.font(size: 16.0)
    }
}
