//
//  SignInViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Button Actions
private extension SignInViewController {

    @IBAction func logInButtonPressed() {

    }
}

// MARK: - TextField Delegate
extension SignInViewController: UITextFieldDelegate {

}
