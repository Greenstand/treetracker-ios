//
//  AnnounceViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 31/05/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class AnnounceViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = FontFamily.Montserrat.bold.font(size: 28)
            titleLabel.numberOfLines = 0
            titleLabel.textColor = Asset.Colors.grayDark.color
        }
    }

    @IBOutlet private var bodyLabel: UILabel! {
        didSet {
            bodyLabel.font = FontFamily.Montserrat.semiBold.font(size: 18)
            bodyLabel.numberOfLines = 0
            bodyLabel.textAlignment = .justified
            bodyLabel.textColor = Asset.Colors.grayMedium.color
        }
    }

    var viewModel: AnnounceViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setupNavigationAppearance(
            prefersLargeTitles: true,
            backgroundColor: Asset.Colors.backgroundGreen.color
        )
    }
}

// MARK: - AnnounceViewModelViewDelegate
extension AnnounceViewController: AnnounceViewModelViewDelegate {

    func announceViewModel(_ announceViewModel: AnnounceViewModel, updateView chat: ChatListViewModel.Chat) {
        titleLabel.text = chat.title
        bodyLabel.text = chat.messages.first?.body
    }

}
