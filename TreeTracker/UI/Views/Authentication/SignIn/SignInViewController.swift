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

class SignInViewController: UIViewController {

    @IBOutlet private var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.delegate = self
        }
    }
    @IBOutlet private var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }

    weak var delegate: SignInViewControllerDelegate?
    var viewModel: SignInViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
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

}
