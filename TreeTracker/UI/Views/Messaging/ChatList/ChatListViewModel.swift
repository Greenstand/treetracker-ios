//
//  ChatListViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core
import UIKit

protocol ChatListViewModelCoordinatorDelegate: AnyObject {
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectMessagesForPlanter planter: Planter)
}

protocol ChatListViewModelViewDelegate: AnyObject {
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didFetchProfile image: UIImage)
}

class ChatListViewModel {

    weak var coordinatorDelegate: ChatListViewModelCoordinatorDelegate?
    weak var viewDelegate: ChatListViewModelViewDelegate?

    private let selfieService: SelfieService
    private var planter: Planter

    // TODO: Change to a message model that has messageType
    private var chatType: [ChatType] = [.chat, .chat, .quiz]

    init(planter: Planter, selfieService: SelfieService) {
        self.planter = planter
        self.selfieService = selfieService
    }

    var title: String {
        return planter.firstName ?? ""
    }

    var numberOfRowsInSection: Int {
        chatType.count
    }

    func cellForRowAt(indexPath: IndexPath) -> ChatType {
        chatType[indexPath.row]
    }
}

// MARK: - Profile
extension ChatListViewModel {

    func fetchProfileImage() {

        selfieService.fetchSelfie(forPlanter: planter) { (result) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    fallthrough
                }
                viewDelegate?.chatListViewModel(self, didFetchProfile: image)
            case .failure:
                viewDelegate?.chatListViewModel(self, didFetchProfile: Asset.Assets.profile.image)
            }
        }
    }

}

// MARK: - Navigation
extension ChatListViewModel {

    func messagesSelected(indexPath: IndexPath) {
        coordinatorDelegate?.chatListViewModel(self, didSelectMessagesForPlanter: planter)
    }

}

enum ChatType {
    case chat
    case quiz
}
