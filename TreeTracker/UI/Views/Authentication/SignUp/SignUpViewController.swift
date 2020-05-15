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

class SignUpViewController: UIViewController {

    weak var delegate: SignUpViewControllerDelegate?
    var viewModel: SignUpViewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Button Actions
private extension SignUpViewController {

    @IBAction func signUpButtonPressed() {
        delegate?.signUpViewControllerDidSignUp(self)
    }
}
