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
            messagesTableView.register(MessagesTableViewCell.nib(), forCellReuseIdentifier: MessagesTableViewCell.identifier)
        }
    }

    @IBOutlet private var inputTextView: UITextView! {
        didSet {
            inputTextView.layer.masksToBounds = true
            inputTextView.layer.cornerRadius = 10
            inputTextView.layer.borderWidth = 2
            inputTextView.layer.borderColor = Asset.Colors.secondaryGreen.color.cgColor
            inputTextView.font = FontFamily.Lato.regular.font(size: 16)
            inputTextView.textColor = Asset.Colors.grayDark.color
            inputTextView.textAlignment = .left
            inputTextView.dataDetectorTypes = .all
            inputTextView.layer.shadowOpacity = 0.5
            inputTextView.isEditable = true
            inputTextView.delegate = self

            // TODO: Let it grow as the text grows
            inputTextView.isScrollEnabled = false
            inputTextView.sizeToFit()
        }
    }

    @IBOutlet private var sendMessageButton: UIButton! {
        didSet {
            // TODO: Change the button icon
            
            sendMessageButton.titleLabel?.font = FontFamily.Lato.regular.font(size: 30)
            sendMessageButton.backgroundColor = Asset.Colors.secondaryOrangeDark.color
        }
    }

    var viewModel: MessagesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: change color
        view.backgroundColor = .systemGray
        viewModel?.fetchMessages()
    }

}

// MARK: - Button Actions
private extension MessagesViewController {

    @IBAction func sendMessageButtonPressed() {

        guard let messageText = inputTextView.text else { return }

        print(messageText)
        viewModel?.sendMessage(text: messageText)

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
