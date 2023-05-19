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
            messagesTableView.delegate = self
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
    private var lastContentOffsetY: CGFloat = 0

    var viewModel: MessagesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addKeyboardObservers()
        viewModel?.loadMoreMessages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Asset.Colors.backgroundGreen.color
        navigationController?.navigationBar.setupNavigationAppearance(
            backgroundColor: Asset.Colors.backgroundGreen.color
        )
        scrollToBottom()
    }

    private func scrollToBottom() {
        guard let row = viewModel?.numberOfRowsInSection else { return }
        let bottomIndexPath = IndexPath(row: row - 1, section: 0)
        messagesTableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: false)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }

        guard let message = viewModel?.getMessageForRowAt(indexPath: indexPath),
              let planterIdentifier = viewModel?.getPlanterIdentifier() else {
            return UITableViewCell()
        }

        cell.setupCell(planterId: planterIdentifier, message: message)
        cell.selectionStyle = .none
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - UIScrollViewDelegate
extension MessagesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffsetY > scrollView.contentOffset.y && scrollView.contentOffset.y < 100 {
            viewModel?.loadMoreMessages()
        }
        lastContentOffsetY = scrollView.contentOffset.y
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

        self.bottomContraint.constant = keyboardSize.height - bottomSafeAreaHeight
        self.messagesTableView.contentOffset.y += keyboardSize.height - bottomSafeAreaHeight
        self.view.layoutIfNeeded()
    }

    func keyboardWillHide(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardSize = (keyboardFrame as? NSValue)?.cgRectValue else {
            return
        }

        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0

        self.bottomContraint.constant = 0
        self.messagesTableView.contentOffset.y -= keyboardSize.height - bottomSafeAreaHeight
        self.view.layoutIfNeeded()
    }
}

// MARK: - KeyboardDismissing
extension MessagesViewController: UIGestureRecognizerDelegate {

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }

}

// MARK: - MessagesViewModelViewDelegate
extension MessagesViewController: MessagesViewModelViewDelegate {

    func messagesViewModel(didFetchMessages messages: [MessageEntity], newMessages: [MessageEntity]) {
        guard !newMessages.isEmpty else { return }

        var currentMessage: MessageEntity?
        var offsetFromTopOfMessage: CGFloat = 0
        if let topIndexPath = messagesTableView.indexPathsForVisibleRows?.first {
            var topMessageRect = messagesTableView.rectForRow(at: topIndexPath)
            topMessageRect = topMessageRect.offsetBy(dx: -messagesTableView.contentOffset.x, dy: -messagesTableView.contentOffset.y)
            offsetFromTopOfMessage = topMessageRect.minY

            let indexPath = IndexPath(row: (topIndexPath.row + newMessages.count), section: 0)
            currentMessage = viewModel?.getMessageForRowAt(indexPath: indexPath)
        }

        messagesTableView.reloadData()
        if let targetMessage = currentMessage,
           let targetIndex = messages.firstIndex(where: { $0.messageId == targetMessage.messageId }) {
            let targetIndexPath = IndexPath(row: targetIndex, section: 0)
            messagesTableView.scrollToRow(at: targetIndexPath, at: .top, animated: false)
            messagesTableView.contentOffset.y -= offsetFromTopOfMessage
        }
    }

}
