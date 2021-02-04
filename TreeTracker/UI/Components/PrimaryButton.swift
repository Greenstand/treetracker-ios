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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = backgroundColor(forState: state)
        }
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = backgroundColor(forState: state)
        }
    }
}

// MARK: - Private
private extension PrimaryButton {

    func commonInit() {

        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        clipsToBounds = true

        setTitleColor(.white, for: .normal)
        setTitleColor(Asset.Colors.grayDark.color, for: .disabled)
        titleLabel?.font = FontFamily.Lato.regular.font(size: 20.0)

        backgroundColor = Asset.Colors.primaryGreen.color
    }

    func backgroundColor(forState state: State) -> UIColor {
        switch state {
        case .highlighted:
            return Asset.Colors.primaryGreen.color.withAlphaComponent(0.5)
        case .disabled:
            return Asset.Colors.grayLight.color.withAlphaComponent(0.2)
        default:
            return Asset.Colors.primaryGreen.color
        }
    }
}
