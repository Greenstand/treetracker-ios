//
//  ChatListViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {

    @IBOutlet private var chatListTableView: UITableView! {
        didSet {
            chatListTableView.delegate = self
            chatListTableView.dataSource = self
            chatListTableView.register(ChatListTableViewCell.nib(), forCellReuseIdentifier: ChatListTableViewCell.identifier)
        }
    }

    var viewModel: ChatListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell

        // TODO: setup
        cell?.setupCell()

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // TODO: work on type of message
        viewModel?.messagesSelectet()

    }

}

// MARK: - ChatListViewModelViewDelegate
extension ChatListViewController: ChatListViewModelViewDelegate {

}
