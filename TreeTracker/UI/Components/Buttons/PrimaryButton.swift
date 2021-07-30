//
//  PrimaryButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class PrimaryButton: RoundedButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.commonInit()
        backgroundColor = backgroundColor(forState: state)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.commonInit()
        backgroundColor = backgroundColor(forState: state)
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
