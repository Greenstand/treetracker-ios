//
//  ChatListViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, AlertPresenting {

    @IBOutlet private var chatListTableView: UITableView! {
        didSet {
            chatListTableView.delegate = self
            chatListTableView.dataSource = self
            chatListTableView.register(ChatListTableViewCell.nib(), forCellReuseIdentifier: ChatListTableViewCell.identifier)
        }
    }

    @IBOutlet private var noMessagesView: UIView! {
        didSet {
            noMessagesView.isHidden = true
        }
    }

    @IBOutlet weak var noMessagesImageView: UIImageView! {
        didSet {
            noMessagesImageView.image = Asset.Assets.mail.image
            noMessagesImageView.tintColor = Asset.Colors.primaryGreen.color
        }
    }

    @IBOutlet private var noMessagesLabel: UILabel! {
        didSet {
            noMessagesLabel.font = FontFamily.Montserrat.semiBold.font(size: 20)
            noMessagesLabel.numberOfLines = 0
            noMessagesLabel.textColor = Asset.Colors.grayDark.color
            noMessagesLabel.text = L10n.ChatList.NoMessagesLabel.text
        }
    }

    @IBOutlet private var syncMessagesButton: SyncMessagesButton!

    @IBOutlet private var lastSyncLabel: UILabel! {
        didSet {
            lastSyncLabel.text = L10n.ChatList.LastSyncLabel.WithouDate.text
            lastSyncLabel.font = FontFamily.Lato.regular.font(size: 14.0)
            lastSyncLabel.textColor = Asset.Colors.grayLight.color
            lastSyncLabel.numberOfLines = 0
        }
    }

    var viewModel: ChatListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchMessages()
        viewModel?.getLastSyncTime()
    }

}

// MARK: - Button Action
private extension ChatListViewController {

    @IBAction func syncMessagesButtonPressed() {
        viewModel?.syncMessages()
    }

}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell
        if let chat = viewModel?.cellForRowAt(indexPath: indexPath) {
            cell?.setupCell(data: chat)
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.chatSelected(indexPath: indexPath)
    }

}

// MARK: - ChatListViewModelViewDelegate
extension ChatListViewController: ChatListViewModelViewDelegate {

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didUpdateChatList chatList: [ChatListViewModel.Chat]) {
        if chatList.isEmpty {
            noMessagesView.isHidden = false
        } else {
            noMessagesView.isHidden = true
            chatListTableView.reloadData()
        }
    }

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didUpdateLastSyncTime lastSyncTime: String) {
        lastSyncLabel.text = lastSyncTime
    }

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, showErrorAlert error: Error) {
        present(alert: Alert.error(error))
    }

    func chatListViewModelDidStartSyncingMessages(_ chatListViewModel: ChatListViewModel) {
        syncMessagesButton.isLoading = true
    }

    func chatListViewModelDidStopSyncingMessages(_ chatListViewModel: ChatListViewModel) {
        syncMessagesButton.isLoading = false
    }

}
