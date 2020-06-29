//
//  Organization.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct Organization {
    let name: String
}

// MARK: - Validation
extension Organization {

    var isValid: Validation.Result {
        return Validation.validate(name, type: .organization)
    }
}
