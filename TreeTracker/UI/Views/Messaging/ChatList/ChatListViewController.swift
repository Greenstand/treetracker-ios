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

    private var planterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        return image
    }()

    var viewModel: ChatListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchProfileImage()
        viewModel?.fetchMessages()
        setupNavBarImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Asset.Colors.backgroundGreen.color
        navigationController?.navigationBar.setupNavigationAppearance(
            prefersLargeTitles: true,
            backgroundColor: Asset.Colors.backgroundGreen.color
        )
        showImage(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }

}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell
        let chat = viewModel?.cellForRowAt(indexPath: indexPath)
        cell?.setupCell(data: chat!) // remove force unwrap
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

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didFetchProfile image: UIImage) {
        planterImage.image = image
    }

    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didUpdateChatList chatList: [ChatListViewModel.Chat]) {
        if chatList.isEmpty {
            noMessagesView.isHidden = false
        } else {
            noMessagesView.isHidden = true
            chatListTableView.reloadData()
        }
    }

}

// MARK: - ImageOnNavigationBar
extension ChatListViewController {

    private func setupNavBarImage() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(planterImage)

        NSLayoutConstraint.activate([
            planterImage.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            planterImage.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            planterImage.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            planterImage.widthAnchor.constraint(equalTo: planterImage.heightAnchor)
        ])
    }

    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        planterImage.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }

    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.planterImage.alpha = show ? 1.0 : 0.0
        }
    }

    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 65
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 15
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }

}

// MARK: -
extension ChatListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }

}
