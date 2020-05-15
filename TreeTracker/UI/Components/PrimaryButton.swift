//
//  PrimaryButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Private Functions
private extension PrimaryButton {

    func commonInit() {
        layer.borderWidth = 1.0
        layer.borderColor = Asset.Colors.grayDark.color.cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
