//
//  TermsViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TermsViewModel {

    var termsLoaded: Bool = false

    var title: String {
        return L10n.Terms.title
    }

    var termsURL: URL? {
        return Bundle.main.url(forResource: "Terms", withExtension: "html")
    }

    var acceptTermsEnabled: Bool {
        guard termsLoaded == true else {
            return false
        }
        return true
    }

    var isLoading: Bool {
        guard termsLoaded else {
            return true
        }
        return false
    }
}
