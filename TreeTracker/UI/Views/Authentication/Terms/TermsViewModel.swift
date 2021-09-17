//
//  TermsViewModel.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol TermsViewModelCoordinatorDelegate: AnyObject {
    func termsViewModel(_ termsViewModel: TermsViewModel, didAcceptTermsForPlanter planter: Planter)
}

protocol TermsViewModelViewDelegate: AnyObject {
    func termsViewModel(_ termsViewModel: TermsViewModel, didReceiveError error: Error)
    func termsViewModel(_ termsViewModel: TermsViewModel, didFetchTerms string: String)
    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateAcceptTermsEnabled enabled: Bool)
    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateLoadingStatus loading: Bool)
}

class TermsViewModel {

    weak var coordinatorDelegate: TermsViewModelCoordinatorDelegate?
    weak var viewDelegate: TermsViewModelViewDelegate?

    private let termsService: TermsService
    private let planter: Planter

    init(planter: Planter, termsService: TermsService) {
        self.planter = planter
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

        termsService.acceptTerms(forPlanter: planter) { (result) in
            switch result {
            case .success(let planter):
                coordinatorDelegate?.termsViewModel(self, didAcceptTermsForPlanter: planter)
            case .failure(let error):
                viewDelegate?.termsViewModel(self, didReceiveError: error)
                viewDelegate?.termsViewModel(self, didUpdateAcceptTermsEnabled: true)
                viewDelegate?.termsViewModel(self, didUpdateLoadingStatus: false)
            }
        }
    }
}
