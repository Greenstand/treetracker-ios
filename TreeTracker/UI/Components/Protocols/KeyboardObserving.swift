//
//  KeyboardObserving.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 31/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

import UIKit

@objc protocol KeyboardObserving {
    @objc func keyboardWillShow(notification: Notification)
    @objc func keyboardWillHide(notification: Notification)
}

extension KeyboardObserving where Self: UIViewController {

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
