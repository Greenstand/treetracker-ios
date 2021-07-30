//
//  DestructiveButton.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/07/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import UIKit

class DestructiveButton: RoundedButton {

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
private extension DestructiveButton {

    func backgroundColor(forState state: State) -> UIColor {
        switch state {
        case .highlighted:
            return Asset.Colors.secondaryRed.color.withAlphaComponent(0.5)
        case .disabled:
            return Asset.Colors.grayLight.color.withAlphaComponent(0.2)
        default:
            return Asset.Colors.secondaryRed.color
        }
    }
}
