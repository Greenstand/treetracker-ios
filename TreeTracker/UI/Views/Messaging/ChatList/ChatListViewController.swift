//
//  ChatListViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {

    var viewModel: ChatListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

// MARK: - ChatListViewModelViewDelegate
extension ChatListViewController: ChatListViewModelViewDelegate {

}
