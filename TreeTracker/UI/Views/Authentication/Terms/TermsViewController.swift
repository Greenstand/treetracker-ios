//
//  TermsViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, AlertPresenting {

    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    @IBOutlet var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.style = .whiteLarge
            activityIndicator.color = .darkGray
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet var acceptTermsButton: PrimaryButton! {
        didSet {
            acceptTermsButton.setTitle(L10n.Terms.AcceptTermsButton.title, for: .normal)
            acceptTermsButton.isEnabled = false
        }
    }

    var viewModel: TermsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchTerms()
    }
}

// MARK: - Button Actions
private extension TermsViewController {

    @IBAction func acceptTermsButtonPressed() {
        viewModel?.acceptTerms()
    }
}

// MARK: - WKNavigationDelegate
extension TermsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel?.termsLoaded = true
    }
}

// MARK: - TermsViewModelViewDelegate
extension TermsViewController: TermsViewModelViewDelegate {

    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateAcceptTermsEnabled enabled: Bool) {
        acceptTermsButton.isEnabled = enabled
    }

    func termsViewModel(_ termsViewModel: TermsViewModel, didUpdateLoadingStatus loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func termsViewModel(_ termsViewModel: TermsViewModel, didFetchTerms string: String) {
        webView.loadHTMLString(string, baseURL: nil)
    }

    func termsViewModel(_ termsViewModel: TermsViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}
