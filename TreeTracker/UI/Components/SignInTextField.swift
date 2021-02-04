//
//  SignInTextField.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInTextField: UITextField {

    @IBOutlet var iconImageView: UIImageView? {
        didSet {
            iconImageView?.tintColor = Asset.Colors.grayLight.color
        }
    }
    @IBOutlet private var underlineView: UIView? {
        didSet {
            underlineView?.backgroundColor = Asset.Colors.grayLight.color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    var validationState: ValidationState = .normal {
        didSet {
            updateTextField(forValidationState: validationState)
        }
    }
}

extension SignInTextField {

    enum ValidationState {
        case normal
        case valid
        case invalid
    }
}

// MARK: - Private
private extension SignInTextField {

    func commonInit() {
        borderStyle = .none
        font = FontFamily.Lato.regular.font(size: 20.0)
    }

    func updateTextField(forValidationState validationState: ValidationState) {
        switch validationState {
        case .normal:
            iconImageView?.tintColor = Asset.Colors.grayLight.color
            underlineView?.backgroundColor = Asset.Colors.grayLight.color
        case .valid:
            iconImageView?.tintColor = Asset.Colors.primaryGreen.color
            underlineView?.backgroundColor = Asset.Colors.primaryGreen.color
        case .invalid:
            iconImageView?.tintColor = Asset.Colors.secondaryRed.color
            underlineView?.backgroundColor = Asset.Colors.secondaryRed.color
        }
    }
}

// MARK: - Validation.Result extension
extension Validation.Result {

    var textFieldValidationState: SignInTextField.ValidationState {
        switch self {
        case .valid:
            return .valid
        case .invalid:
            return .invalid
        case .empty:
            return .normal
        }
    }
}
