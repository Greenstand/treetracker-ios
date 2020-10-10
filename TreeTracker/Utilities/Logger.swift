//
//  Logger.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 11/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

struct Logger {
    static func log(_ string: String) {
        #if DEBUG
            print(string)
        #endif
    }
}
