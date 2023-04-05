//
//  ChatListViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol ChatListViewModelCoordinatorDelegate: AnyObject {
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectMessagesForPlanter planter: Planter)
}

protocol ChatListViewModelViewDelegate: AnyObject {

}

class ChatListViewModel {

    weak var coordinatorDelegate: ChatListViewModelCoordinatorDelegate?
    weak var viewDelegate: ChatListViewModelViewDelegate?

    private var planter: Planter

    // TODO: Change to a message model that has messageType
    private var chatType: [ChatType] = [.chat, .chat, .quiz]

    init(planter: Planter) {
        self.planter = planter
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
