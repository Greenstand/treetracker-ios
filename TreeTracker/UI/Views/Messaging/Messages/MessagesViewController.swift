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
            messagesTableView.separatorStyle = .none
            messagesTableView.dataSource = self
            messagesTableView.register(MessageTableViewCell.nib(), forCellReuseIdentifier: MessageTableViewCell.identifier)
        }
    }

    @IBOutlet private var inputTextView: UITextView! {
        didSet {
            inputTextView.layer.masksToBounds = true
            inputTextView.layer.cornerRadius = 10
            inputTextView.layer.borderWidth = 1
            inputTextView.layer.borderColor = Asset.Colors.primaryGreen.color.cgColor
            inputTextView.font = FontFamily.Lato.regular.font(size: 16)
            inputTextView.textColor = Asset.Colors.grayDark.color
            inputTextView.delegate = self

            inputTextView.isScrollEnabled = false
            inputTextView.sizeToFit()
        }
    }

    @IBOutlet private var sendMessageButton: UIButton! {
        didSet {
            // TODO: Change the button icon
            sendMessageButton.titleLabel?.font = FontFamily.Montserrat.bold.font(size: 30)
            sendMessageButton.backgroundColor = Asset.Colors.primaryGreen.color
            sendMessageButton.setTitle(">", for: .normal)
            sendMessageButton.tintColor = Asset.Colors.grayDark.color
            sendMessageButton.layer.cornerRadius = 15
            sendMessageButton.clipsToBounds = true
        }
    }

    var viewModel: MessagesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.backgroundGreen.color
        viewModel?.fetchMessages()
    }

}

// MARK: - Button Actions
private extension MessagesViewController {

    @IBAction func sendMessageButtonPressed() {

        guard
            let messageText = inputTextView.text,
            !messageText.isEmpty
        else { return }

        print(messageText)
        viewModel?.sendMessage(text: messageText)
        let row = viewModel?.numberOfRowsInSection ?? 0

        messagesTableView.beginUpdates()
        messagesTableView.insertRows(at: [IndexPath(row: row - 1, section: 0)], with: .fade)
        messagesTableView.endUpdates()
        messagesTableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .top, animated: true)
        inputTextView.text = ""

    }

}

// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell

        let message = viewModel?.getMessageForRowAt(indexPath: indexPath)
        let planterName = viewModel?.getPlanterName() ?? ""
        cell?.setupCell(message: message, planterName: planterName)
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - UITextViewDelegate
extension MessagesViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // TODO: Let it grow as the text grows
//        let size = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))
//        textView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}

// MARK: - MessagesViewModelViewDelegate
extension MessagesViewController: MessagesViewModelViewDelegate {

    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didFetchMessages messages: [Message]) {
        messagesTableView.reloadData()
    }

    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didReceiveError error: Error) {
        // TODO: show some alert?
    }

}
