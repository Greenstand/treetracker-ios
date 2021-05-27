//
//  SignUpViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, KeyboardDismissing, AlertPresenting {

    @IBOutlet private var usernameIconImageView: UIImageView! {
        didSet {
            usernameIconImageView.contentMode = .left
            usernameIconImageView.tintColor = Asset.Colors.primaryGreen.color
        }
    }
    @IBOutlet private var usernameLabel: UILabel! {
        didSet {
            usernameLabel.font = FontFamily.Lato.regular.font(size: 20.0)
            usernameLabel.textColor = Asset.Colors.primaryGreen.color
            usernameLabel.textAlignment = .left
        }
    }
    @IBOutlet private var usernameUnderlineView: UIView! {
        didSet {
            usernameUnderlineView.backgroundColor = Asset.Colors.primaryGreen.color
        }
    }
    @IBOutlet private var firstNameTextField: SignInTextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.keyboardType = .default
            firstNameTextField.returnKeyType = .next
            firstNameTextField.autocapitalizationType = .words
            firstNameTextField.placeholder = L10n.SignUp.TextInput.FirstName.placeholder
            firstNameTextField.validationState = .normal
        }
    }
    @IBOutlet private var lastNameTextField: SignInTextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.keyboardType = .default
            lastNameTextField.returnKeyType = .next
            lastNameTextField.autocapitalizationType = .words
            lastNameTextField.placeholder = L10n.SignUp.TextInput.LastName.placeholder
            lastNameTextField.validationState = .normal
        }
    }
    @IBOutlet private var organizationTextField: SignInTextField! {
        didSet {
            organizationTextField.delegate = self
            organizationTextField.keyboardType = .default
            organizationTextField.returnKeyType = .done
            organizationTextField.autocapitalizationType = .words
            organizationTextField.placeholder = L10n.SignUp.TextInput.Organization.placeholder
            organizationTextField.validationState = .normal
        }
    }
    @IBOutlet private var signUpButton: UIButton! {
        didSet {
            signUpButton.setTitle(L10n.SignUp.SignUpButton.title, for: .normal)
            signUpButton.isEnabled = false
        }
    }

    var viewModel: SignUpViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
        addKeyboardObservers()
        usernameLabel.text = viewModel?.usernameText
        usernameIconImageView.image = viewModel?.usernameIcon

    }
}

// MARK: - Button Actions
private extension SignUpViewController {

    @IBAction func signUpButtonPressed() {
        viewModel?.signUp()
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
            viewModel?.organizationName = newText
        default:
            break
        }

        return true
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: SignUpViewModelViewDelegate {

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateFirstName result: Validation.Result) {
        firstNameTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateLastName result: Validation.Result) {
        lastNameTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateOrganizationName result: Validation.Result) {
        organizationTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didUpdateSignUpEnabled enabled: Bool) {
        signUpButton.isEnabled = enabled
    }
}

// MARK: - KeyboardObserving
extension SignUpViewController: KeyboardObserving {

    func keyboardWillShow(notification: Notification) {

    }

    func keyboardWillHide(notification: Notification) {

    }
}
