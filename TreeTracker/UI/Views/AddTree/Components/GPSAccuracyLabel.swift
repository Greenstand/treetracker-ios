//
//  GPSAccuracyLabel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 19/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class GPSAccuracyLabel: UILabel {

    var accuracy: Accuracy = .unknown {
        didSet {
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: L10n.GPSAccuracyLabel.Text.base))
            attributedString.append(NSAttributedString(string: accuracy.text, attributes: [.foregroundColor: accuracy.color]))
            attributedText = attributedString
        }
    }
}

// MARK: - Accuracy Enum
extension GPSAccuracyLabel {

    enum Accuracy {
        case good
        case bad
        case unknown
    }
}

private extension GPSAccuracyLabel.Accuracy {

    var text: String {
        switch self {
        case .good:
            return L10n.GPSAccuracyLabel.Text.good
        case .bad:
            return L10n.GPSAccuracyLabel.Text.bad
        case .unknown:
            return L10n.GPSAccuracyLabel.Text.unknown
        }
    }

    var color: UIColor {
        switch self {
        case .good:
            return Asset.Colors.primaryGreen.color
        case .bad:
            return Asset.Colors.secondaryRed.color
        case .unknown:
            return Asset.Colors.grayMedium.color
        }
    }
}
