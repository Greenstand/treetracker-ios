//
//  UITextField+Extensions.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 05/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit.UITextField

extension UITextField {

    func refreshKeyboard() {
        if isFirstResponder {
            resignFirstResponder()
            becomeFirstResponder()
        }
    }
}
