//
//  MessagesViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol MessagesViewModelViewDelegate: AnyObject {
    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didFetchMessages messages: [Message])
    func messagesViewModel(_ messagesViewModel: MessagesViewModel, didReceiveError error: Error)
}

class MessagesViewModel {

    weak var viewDelegate: MessagesViewModelViewDelegate?

    private let planter: Planter
    private let messagingService: MessagingService

    private var messages: [Message] = []

    init(planter: Planter, messagingService: MessagingService) {
        self.planter = planter
        self.messagingService = messagingService
    }

    func getNumberOfRowsInSection() -> Int {
        messages.count
    }

    func getMessageForRowAt(indexPath: IndexPath) -> Message {
        messages[indexPath.row]
    }

    func fetchMessages() {

        messagingService.getMessages(planter: planter) { result in

            switch result {
            case .success(let messages):
                self.messages = messages
                self.viewDelegate?.messagesViewModel(self, didFetchMessages: messages)
            case .failure(let error):
                self.viewDelegate?.messagesViewModel(self, didReceiveError: error)
            }
        }

    }
}
