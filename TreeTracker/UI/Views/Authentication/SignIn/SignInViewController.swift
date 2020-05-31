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
    func signInViewControllerDidSelectSignUp(_ signInViewController: SignInViewController)
}

class SignInViewController: UIViewController, KeyboardDismissing {

    @IBOutlet private var phoneNumberTextField: SignInTextField! {
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.keyboardType = .numberPad
            phoneNumberTextField.returnKeyType = .done
            phoneNumberTextField.placeholder = L10n.TextInput.PhoneNumber.placeholder
        }
    }
    @IBOutlet private var emailTextField: SignInTextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .done
            emailTextField.placeholder = L10n.TextInput.Email.placeholder
        }
    }

    weak var delegate: SignInViewControllerDelegate?
    var viewModel: SignInViewModel? {
        didSet {
            viewModel?.updateView(view: self)
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
        delegate?.signInViewControllerDidSelectLogin(self)
    }

    @IBAction func signUpButtonPressed() {
        delegate?.signInViewControllerDidSelectSignUp(self)
    }
}

// MARK: - Private Functions
private extension SignInViewController {

    func validateTextField(textField: UITextField) {

        guard let viewModel = viewModel else {
            return
        }

        switch textField {
        case phoneNumberTextField:
            phoneNumberTextField.validationState = viewModel.phoneNumberValid.textFieldValidationState
        case emailTextField:
            emailTextField.validationState = viewModel.emailValid.textFieldValidationState
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

        switch textField {
        case phoneNumberTextField:
            viewModel?.phoneNumber = newText
        case emailTextField:
            viewModel?.email = newText
        default:
            break
        }

        validateTextField(textField: textField)
        return true
    }
}

// MARK: - ViewModel Extension
private extension SignInViewModel {
    func updateView(view: SignInViewController) {
        view.title = title
    }
}
