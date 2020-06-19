//
//  SignInViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: class {
    func signInViewControllerDidSelectLogin(_ signInViewController: SignInViewController)
}

class SignInViewController: UIViewController, KeyboardDismissing {

    @IBOutlet fileprivate var phoneNumberTextField: SignInTextField! {
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.keyboardType = .numberPad
            phoneNumberTextField.returnKeyType = .done
            phoneNumberTextField.placeholder = L10n.TextInput.PhoneNumber.placeholder
        }
    }
    @IBOutlet fileprivate var emailTextField: SignInTextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .done
            emailTextField.placeholder = L10n.TextInput.Email.placeholder
        }
    }
    @IBOutlet fileprivate var loginButton: PrimaryButton!

    weak var delegate: SignInViewControllerDelegate?
    var viewModel: SignInViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
        viewModel?.updateView(view: self)
    }
}

// MARK: - Button Actions
private extension SignInViewController {

    @IBAction func logInButtonPressed() {
        delegate?.signInViewControllerDidSelectLogin(self)
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

        switch textField {
        case phoneNumberTextField:
            viewModel?.phoneNumber = newText
        case emailTextField:
            viewModel?.email = newText
        default:
            break
        }

        viewModel?.updateView(view: self)
        return true
    }
}

// MARK: - ViewModel Extension
private extension SignInViewModel {
    func updateView(view: SignInViewController) {
        view.title = title
        view.loginButton.isEnabled = loginButtonEnabled
        view.emailTextField.validationState = emailValid.textFieldValidationState
        view.phoneNumberTextField.validationState = phoneNumberValid.textFieldValidationState
    }
}
