//
//  TermsViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol TermsViewModelCoordinatorDelegate: class {
    func termsViewModel(_ termsViewModel: TermsViewModel, didAcceptTermsForUser username: Username)
}

protocol TermsViewModelViewDelegate: class {
    func termsViewModel(_ termsViewModel: TermsViewModel, didReceiveError error: Error)
    func termsViewModel(_ termsViewModel: TermsViewModel, didFetchTerms string: String)
    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateAcceptTermsEnabled enabled: Bool)
    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateLoadingStatus loading: Bool)
}

class TermsViewModel {

    weak var coordinatorDelegate: TermsViewModelCoordinatorDelegate?
    weak var viewDelegate: TermsViewModelViewDelegate?

    private let termsService: TermsService
    private let username: Username

    init(username: Username, termsService: TermsService = TermsService()) {
        self.username = username
        self.termsService = termsService
    }

    let title: String = L10n.Terms.title

    var termsLoaded: Bool = false {
        didSet {
            viewDelegate?.termsViewModel(self, didUpdateAcceptTermsEnabled: termsLoaded)
            viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: !termsLoaded)
        }
    }

    func fetchTerms() {

        viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: true)

        termsService.fetchTerms { (result) in
            switch result {
            case .success(let terms):
                viewDelegate?.termsViewModel(self, didFetchTerms: terms.htmlString)
            case .failure(let error):
                viewDelegate?.termsViewModel(self, didReceiveError: error)
                viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: false)
            }
        }
    }

    func acceptTerms() {

        viewDelegate?.termsViewModel(self, didUpdateAcceptTermsEnabled: false)
        viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: true)

        termsService.acceptTerms(forUser: username) { (result) in
            switch result {
            case .success(let username):
                coordinatorDelegate?.termsViewModel(self, didAcceptTermsForUser: username)
            case .failure(let error):
                viewDelegate?.termsViewModel(self, didReceiveError: error)
                viewDelegate?.termsViewModel(self, didUpdateAcceptTermsEnabled: true)
                viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: false)
            }
        }
    }
}
