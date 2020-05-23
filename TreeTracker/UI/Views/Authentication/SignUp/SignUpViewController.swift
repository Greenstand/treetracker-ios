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
    @IBOutlet private var firstNameTextField: SignInTextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.keyboardType = .default
            firstNameTextField.placeholder = L10n.TextInput.FirstName.placeholder
        }
    }
    @IBOutlet private var lastNameTextField: SignInTextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.keyboardType = .default
            lastNameTextField.placeholder = L10n.TextInput.LastName.placeholder
        }
    }
    @IBOutlet private var organizationTextField: SignInTextField! {
        didSet {
            organizationTextField.delegate = self
            organizationTextField.keyboardType = .default
            organizationTextField.placeholder = L10n.TextInput.Organization.placeholder
        }
    }

    weak var delegate: SignUpViewControllerDelegate?
    var viewModel: SignUpViewModel? {
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
private extension SignUpViewController {

    @IBAction func signUpButtonPressed() {
        delegate?.signUpViewControllerDidSignUp(self)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {

}

// MARK: - ViewModel Extension
private extension SignUpViewModel {
    func updateView(view: SignUpViewController) {

    }
}
