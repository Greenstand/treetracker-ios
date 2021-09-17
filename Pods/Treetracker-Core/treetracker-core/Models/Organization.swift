//
//  Organization.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public struct Organization {
    let name: String

    public init(name: String) {
        self.name = name
    }
}

// MARK: - Validation
public extension Organization {

    var isValid: Validation.Result {
        return Validation.validate(name, type: .organization)
    }
}
