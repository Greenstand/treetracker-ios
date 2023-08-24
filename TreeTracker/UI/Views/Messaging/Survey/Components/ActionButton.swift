//
//  ActionButton.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 02/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    enum ButtonStyle {
        case next
        case finish
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var isEnabled: Bool {
        didSet {
            updateState()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateState()
        }
    }

    var buttonStyle: ButtonStyle = .next {
        didSet {
            updateButtonStyle()
        }
    }
}

// MARK: - Private
private extension ActionButton {

    func commonInit() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true

        updateState()
        updateButtonStyle()
    }

    func updateState() {
        if !isEnabled {
            backgroundColor = Asset.Colors.grayLight.color.withAlphaComponent(0.2)
            tintColor = Asset.Colors.grayLight.color
        } else if isHighlighted {
            backgroundColor = Asset.Colors.secondaryGreen.color
            tintColor = .white
        } else {
            backgroundColor = Asset.Colors.primaryGreen.color
            tintColor = .white
        }
    }

    @objc private func handleTouchDown() {
        updateState()
    }

    @objc private func handleTouchUp() {
        updateState()
    }

    func updateButtonStyle() {
        switch buttonStyle {
        case .next:
            setAttributedTitle(nextQuestionAttributedTitle(withAtributes: normalTextAttributes), for: .normal)
            setAttributedTitle(nextQuestionAttributedTitle(withAtributes: disabledTextAttributes), for: .disabled)
        case .finish:
            setAttributedTitle(finishSurveyAttributedTitle(withAtributes: normalTextAttributes), for: .normal)
            setAttributedTitle(finishSurveyAttributedTitle(withAtributes: disabledTextAttributes), for: .disabled)
        }
    }

    func nextQuestionAttributedTitle(withAtributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: L10n.Survey.ActionButton.Title.next, attributes: attributes))
        return attributedString
    }

    func finishSurveyAttributedTitle(withAtributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: L10n.Survey.ActionButton.Title.finish, attributes: attributes))
        return attributedString
    }

    var normalTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0),
            .foregroundColor: UIColor.white
        ]
    }

    var disabledTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: FontFamily.Montserrat.semiBold.font(size: 20.0),
            .foregroundColor: Asset.Colors.grayLight.color.withAlphaComponent(0.5)
        ]
    }
}
