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

    var planter: Planter

    init(planter: Planter) {
        self.planter = planter
    }

    var title: String {
        return planter.firstName ?? ""
    }
}

// MARK: - Navigation
extension ChatListViewModel {

    func messagesSelectet() {
        coordinatorDelegate?.chatListViewModel(self, didSelectMessagesForPlanter: planter)
    }

}
