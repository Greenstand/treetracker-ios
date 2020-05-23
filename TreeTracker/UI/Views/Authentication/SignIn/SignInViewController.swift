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
            phoneNumberTextField.placeholder = L10n.TextInput.PhoneNumber.placeholder
        }
    }
    @IBOutlet private var emailTextField: SignInTextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.keyboardType = .emailAddress
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

// MARK: - TextField Delegate
extension SignInViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}

// MARK: - ViewModel Extension
private extension SignInViewModel {
    func updateView(view: SignInViewController) {
        view.title = title
    }
}
