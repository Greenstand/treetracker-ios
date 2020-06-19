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
            updateColors()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
}

// MARK: - Private Functions
private extension PrimaryButton {

    func commonInit() {
        setBorder()
        setTextAttributes()
    }

    func setBorder() {
        layer.borderWidth = 1.0
        layer.borderColor = Asset.Colors.grayDark.color.cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        clipsToBounds = true
    }

    func setTextAttributes() {
        [.normal, .highlighted, .disabled].forEach({
            setTitleColor(buttonColor(forState: $0), for: $0)
        })
    }

    func updateColors() {
        layer.borderColor = buttonColor(forState: state).cgColor
    }

    func buttonColor(forState state: State) -> UIColor {
        switch state {
        case .highlighted:
            return Asset.Colors.grayMedium.color
        case .disabled:
            return Asset.Colors.grayLight.color
        default:
            return Asset.Colors.grayDark.color
        }
    }
}
