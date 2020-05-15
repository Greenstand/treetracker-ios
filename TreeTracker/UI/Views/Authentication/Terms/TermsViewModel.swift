//
//  TermsViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct TermsViewModel {

    var termsURL: URL? {
        return Bundle.main.url(forResource: "Terms", withExtension: "html")

    }
}
