//
//  SignInTextField.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInTextField: UITextField {

    @IBOutlet private var iconView: UIImageView? {
        didSet {
            iconView?.tintColor = Asset.Colors.grayMedium.color
        }
    }
    @IBOutlet private var underlineView: UIView? {
        didSet {
            underlineView?.backgroundColor = Asset.Colors.grayMedium.color
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

// MARK: - Private Functions
private extension SignInTextField {

    func commonInit() {
        borderStyle = .none
    }

    func updateTextField(forValidationState validationState: ValidationState) {
        switch validationState {
        case .normal:
            iconView?.tintColor = Asset.Colors.grayMedium.color
            underlineView?.backgroundColor = Asset.Colors.grayMedium.color
        case .valid:
            iconView?.tintColor = Asset.Colors.secondaryGreen.color
            underlineView?.backgroundColor = Asset.Colors.secondaryGreen.color
        case .invalid:
            iconView?.tintColor = Asset.Colors.secondaryOrangeDark.color
            underlineView?.backgroundColor = Asset.Colors.secondaryOrangeDark.color
        }
    }
}

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
