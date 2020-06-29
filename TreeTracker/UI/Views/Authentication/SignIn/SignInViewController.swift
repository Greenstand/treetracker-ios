//
//  SignInViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, KeyboardDismissing, AlertPresenting {

    @IBOutlet private var logoImageView: UIImageView! {
        didSet {
            logoImageView.image = Asset.Assets.greenstandlogo.image
        }
    }
    @IBOutlet private var phoneNumberTextField: SignInTextField! {
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.keyboardType = .numberPad
            phoneNumberTextField.returnKeyType = .done
            phoneNumberTextField.placeholder = L10n.SignIn.TextInput.PhoneNumber.placeholder
            phoneNumberTextField.validationState = .normal
        }
    }
    @IBOutlet private var orLabel: UILabel! {
        didSet {
            orLabel.text = L10n.SignIn.OrLabel.text
            orLabel.textColor = Asset.Colors.grayDark.color
            orLabel.font = .systemFont(ofSize: 16.0)
        }
    }
    @IBOutlet private var emailTextField: SignInTextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .done
            emailTextField.placeholder = L10n.SignIn.TextInput.Email.placeholder
            emailTextField.validationState = .normal
        }
    }
    @IBOutlet private var loginButton: PrimaryButton! {
        didSet {
            loginButton.setTitle(L10n.SignIn.LoginButton.title, for: .normal)
            loginButton.isEnabled = false
        }
    }

    var viewModel: SignInViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
    }
}

// MARK: - Button Actions
private extension SignInViewController {

    @IBAction func logInButtonPressed() {
        viewModel?.login()
    }
}

// MARK: - TextField Delegate
extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        present(alert: .information(title: "test", message: "message"))
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text as NSString? else {
            return true
        }

        let newText = text.replacingCharacters(in: range, with: string)

        switch textField {
        case phoneNumberTextField:
            viewModel?.phoneNumber = newText
        case emailTextField:
            viewModel?.email = newText
        default:
            break
        }
        return true
    }
}

// MARK: - SignInViewModelViewDelegate
extension SignInViewController: SignInViewModelViewDelegate {

    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginEnabled enabled: Bool) {
        loginButton.isEnabled = enabled
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didValidateEmail result: Validation.Result) {
        emailTextField.validationState = result.textFieldValidationState
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didValidatePhoneNumber result: Validation.Result) {
        phoneNumberTextField.validationState = result.textFieldValidationState
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}
