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
    @IBOutlet private var usernameTextField: SignInTextField! {
        didSet {
            usernameTextField.delegate = self
            usernameTextField.textContentType = .telephoneNumber
            usernameTextField.keyboardType = .phonePad
            usernameTextField.returnKeyType = .done
            usernameTextField.placeholder = L10n.SignIn.TextInput.PhoneNumber.placeholder
            usernameTextField.validationState = .normal
        }
    }
    @IBOutlet private var usernameSegmentedControl: UISegmentedControl! {
        didSet {
            usernameSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
            usernameSegmentedControl.setImage(Asset.Assets.phone.image, forSegmentAt: 0)
            usernameSegmentedControl.setImage(Asset.Assets.mail.image, forSegmentAt: 1)
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

    @IBAction func usernameSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel?.updateLoginType(loginType: .phoneNumber)
        case 1:
            viewModel?.updateLoginType(loginType: .email)
        default:
            break
        }
    }
}

// MARK: - TextField Delegate
extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text as NSString? else {
            return true
        }

        let newText = text.replacingCharacters(in: range, with: string)
        viewModel?.updateUsername(username: newText)
        return true
    }
}

// MARK: - SignInViewModelViewDelegate
extension SignInViewController: SignInViewModelViewDelegate {

    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginEnabled enabled: Bool) {
        loginButton.isEnabled = enabled
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateValidationState result: Validation.Result) {
        usernameTextField.validationState = result.textFieldValidationState
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateLoginType loginType: SignInViewModel.LoginType) {

        switch loginType {
        case .phoneNumber:
            usernameTextField.keyboardType = .phonePad
            usernameTextField.textContentType = .telephoneNumber
            usernameTextField.placeholder = L10n.SignIn.TextInput.PhoneNumber.placeholder
            usernameTextField.iconImageView?.image = Asset.Assets.phone.image
        case .email:
            usernameTextField.keyboardType = .emailAddress
            usernameTextField.textContentType = .emailAddress
            usernameTextField.placeholder = L10n.SignIn.TextInput.Email.placeholder
            usernameTextField.iconImageView?.image = Asset.Assets.mail.image
        }

        usernameTextField.refreshKeyboard()
    }
}
