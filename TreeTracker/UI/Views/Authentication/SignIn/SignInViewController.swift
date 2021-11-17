//
//  SignInViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, KeyboardDismissing, AlertPresenting {

    @IBOutlet private var textFieldContainer: UIView! {
        didSet {
            textFieldContainer.layer.borderWidth = 1
            textFieldContainer.layer.cornerRadius = 10
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
            usernameTextField.backgroundColor = .black
            usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
            usernameTextField.layer.cornerRadius = 10.0
            usernameTextField.layer.borderWidth = 1.0
            usernameTextField.clipsToBounds = true
        }
    }
    @IBOutlet private var usernameSegmentedControl: UISegmentedControl! {
        didSet {
             usernameSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
             usernameSegmentedControl.setImage(Asset.Assets.phone.image, forSegmentAt: 0)
             usernameSegmentedControl.setImage(Asset.Assets.mail.image, forSegmentAt: 1)
             usernameSegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.Colors.grayDark.color], for: .selected)
             usernameSegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.Colors.grayLight.color], for: .normal)
             usernameSegmentedControl.backgroundColor = Asset.Colors.secondaryGreen.color
             let attributes: [NSAttributedString.Key: Any] = [.font: FontFamily.Montserrat.bold.font(size: 16.0) ?? ""]
             usernameSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
             usernameSegmentedControl.setTitleTextAttributes([.foregroundColor: Asset.Colors.grayDark.color], for: .selected)
            if #available(iOS 13.0, *) {
                usernameSegmentedControl.selectedSegmentTintColor = Asset.Colors.primaryGreen.color
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBOutlet private var nextOnButton: UIButton! {
        didSet {
            nextOnButton.isEnabled = false
            nextOnButton.setBackgroundImage(Asset.Assets.nextup.image, for: .normal)
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
        self.view.backgroundColor = .black
        addEndEditingBackgroundTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
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
        nextOnButton.isEnabled = enabled
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func signInViewModel(_ signInViewModel: SignInViewModel, didUpdateValidationState result: SignInViewModel.ValidationResult) {
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

// MARK: - SignInViewModel.ValidationResult extension
extension SignInViewModel.ValidationResult {

    var textFieldValidationState: SignInTextField.ValidationState {
        switch self {
        case .valid:
            return .valid
        case .invalid:
            return .invalid
        case .empty:
            return .normal
        }
    }
}
