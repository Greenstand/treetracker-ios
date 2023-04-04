//
//  MessagesViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

class MessagesViewController: UIViewController {

    @IBOutlet private var messagesTableView: UITableView! {
        didSet {
            messagesTableView.dataSource = self
            messagesTableView.delegate = self
            messagesTableView.register(MessagesTableViewCell.nib(), forCellReuseIdentifier: MessagesTableViewCell.identifier)
        }
    }

    var viewModel: MessagesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchMessages()
    }
}

// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRowsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.identifier, for: indexPath) as? MessagesTableViewCell

        let message = viewModel?.getMessageForRowAt(indexPath: indexPath)
        cell?.setupCell(message: message)

        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {

}

// MARK: - MessagesViewModelViewDelegate
extension MessagesViewController: MessagesViewModelViewDelegate {

    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didFetchMessages messages: [Message]) {
        messagesTableView.reloadData()
    }

    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didReceiveError error: Error) {
        // do something
    }

}
