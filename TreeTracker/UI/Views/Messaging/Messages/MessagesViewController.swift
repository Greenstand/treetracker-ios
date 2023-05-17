//
//  MessagesViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

class MessagesViewController: UIViewController, KeyboardDismissing {

    @IBOutlet private var messagesTableView: UITableView! {
        didSet {
            messagesTableView.separatorStyle = .none
            messagesTableView.dataSource = self
            messagesTableView.register(MessageTableViewCell.nib(), forCellReuseIdentifier: MessageTableViewCell.identifier)
            messagesTableView.addTopBounceAreaView(color: Asset.Colors.backgroundGreen.color)
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

            inputTextView.textColor = Asset.Colors.grayLight.color
            inputTextView.text = L10n.Messages.InputTextView.placeHolder
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

    @IBOutlet private var bottomContraint: NSLayoutConstraint!

    var viewModel: MessagesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
        addKeyboardObservers()
        viewModel?.getMessages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Asset.Colors.backgroundGreen.color
        navigationController?.navigationBar.setupNavigationAppearance(
            backgroundColor: Asset.Colors.backgroundGreen.color
        )
    }

}

// MARK: - Button Actions
private extension MessagesViewController {

    @IBAction func sendMessageButtonPressed() {

        guard
            let messageText = inputTextView.text,
            !messageText.isEmpty,
            inputTextView.textColor != Asset.Colors.grayLight.color
        else { return }

        viewModel?.sendMessage(text: messageText)
        let row = viewModel?.numberOfRowsInSection ?? 0

        messagesTableView.beginUpdates()
        messagesTableView.insertRows(at: [IndexPath(row: row - 1, section: 0)], with: .fade)
        messagesTableView.endUpdates()
        messagesTableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .top, animated: true)

        inputTextView.text = ""
        textViewDidChange(inputTextView)
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
        let planterIdentifier = viewModel?.getPlanterIdentifier()
        cell?.setupCell(planterId: planterIdentifier!, message: message!) // remove force unwrap?
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - UITextViewDelegate
extension MessagesViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        // placeholder
        if textView.textColor == Asset.Colors.grayLight.color {
            textView.text = nil
            textView.textColor = Asset.Colors.grayDark.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // placeholder
        if textView.text.isEmpty {
            textView.text = L10n.Messages.InputTextView.placeHolder
            textView.textColor = Asset.Colors.grayLight.color
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        // autoresizing
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        guard textView.contentSize.height < 120.0 else { textView.isScrollEnabled = true; return }

        textView.isScrollEnabled = false

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

// MARK: - KeyboardObserving
extension MessagesViewController: KeyboardObserving {

    func keyboardWillShow(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardSize = (keyboardFrame as? NSValue)?.cgRectValue else {
            return
        }

        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0

        UIView.animate(withDuration: 0.30) {
            self.bottomContraint.constant = keyboardSize.height - bottomSafeAreaHeight
            self.view.layoutIfNeeded()
        }

        let row = viewModel?.numberOfRowsInSection ?? 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.messagesTableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .bottom, animated: true)
        }
    }

    func keyboardWillHide(notification: Notification) {
        bottomContraint.constant = 0
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
