//
//  SignUpViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: class {
    func signUpViewControllerDidSignUp(_ signUpViewController: SignUpViewController)
}

class SignUpViewController: UIViewController, KeyboardDismissing {

    @IBOutlet fileprivate var userNameLabel: UILabel! {
        didSet {
            userNameLabel.textColor = Asset.Colors.grayDark.color
            userNameLabel.textAlignment = .center
        }
    }
    @IBOutlet fileprivate var firstNameTextField: SignInTextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.keyboardType = .default
            firstNameTextField.returnKeyType = .next
            firstNameTextField.placeholder = L10n.SignUp.TextInput.FirstName.placeholder
        }
    }
    @IBOutlet fileprivate var lastNameTextField: SignInTextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.keyboardType = .default
            lastNameTextField.returnKeyType = .next
            lastNameTextField.placeholder = L10n.SignUp.TextInput.LastName.placeholder
        }
    }
    @IBOutlet fileprivate var organizationTextField: SignInTextField! {
        didSet {
            organizationTextField.delegate = self
            organizationTextField.keyboardType = .default
            organizationTextField.returnKeyType = .done
            organizationTextField.placeholder = L10n.SignUp.TextInput.Organization.placeholder
        }
    }
    @IBOutlet fileprivate var signUpButton: UIButton! {
        didSet {
            signUpButton.setTitle(L10n.SignUp.SignUpButton.title, for: .normal)
        }
    }

    weak var delegate: SignUpViewControllerDelegate?
    var viewModel: SignUpViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
        viewModel?.updateView(view: self)
    }
}

// MARK: - Button Actions
private extension SignUpViewController {

    @IBAction func signUpButtonPressed() {
        delegate?.signUpViewControllerDidSignUp(self)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            organizationTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text as NSString? else {
            return true
        }

        let newText = text.replacingCharacters(in: range, with: string)

        switch textField {
        case firstNameTextField:
            viewModel?.firstName = newText
        case lastNameTextField:
            viewModel?.lastName = newText
        case organizationTextField:
            viewModel?.organisation = newText
        default:
            break
        }

        viewModel?.updateView(view: self)
        return true
    }
}

// MARK: - ViewModel Extension
private extension SignUpViewModel {
    func updateView(view: SignUpViewController) {
        view.signUpButton.isEnabled = signUpEnabled
        view.firstNameTextField.validationState = firstNameValid.textFieldValidationState
        view.lastNameTextField.validationState = lastNameValid.textFieldValidationState
        view.organizationTextField.validationState = organisationValid.textFieldValidationState
    }
}
