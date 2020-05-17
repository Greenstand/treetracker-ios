//
//  TermsViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import WebKit

protocol TermsViewControllerDelegate: class {
    func termsViewControllerDidAcceptTerms(_ termsViewController: TermsViewController)
}

class TermsViewController: UIViewController {

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

    weak var delegate: TermsViewControllerDelegate?
    var viewModel: TermsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        loadURL(url: viewModel?.termsURL)
    }
}

// MARK: - Private Functions
fileprivate extension TermsViewController {

    func loadURL(url: URL?) {

        guard let url = url else {
            return
        }

        webView.loadFileURL(
            url,
            allowingReadAccessTo: url
        )
    }
}

// MARK: - Button Actions
private extension TermsViewController {

    @IBAction func acceptTermsButtonPressed() {
        delegate?.termsViewControllerDidAcceptTerms(self)
    }
}

// MARK: - WKNavigationDelegate
extension TermsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
