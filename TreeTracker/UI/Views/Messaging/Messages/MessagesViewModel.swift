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
    private var chat: ChatListViewModel.Chat

    private(set) var messages: [Message] = []

    init(planter: Planter, messagingService: MessagingService, chat: ChatListViewModel.Chat) {
        self.planter = planter
        self.messagingService = messagingService
        self.chat = chat
    }

    var title: String {
        return chat.title
    }

    var numberOfRowsInSection: Int {
        chat.messages.count
    }

    func getMessageForRowAt(indexPath: IndexPath) -> MessageEntity {
        chat.messages[indexPath.row]
    }

    func getPlanterName() -> String {
        chat.title
    }

    func sendMessage(text: String) {
        let newMessage = chat.messages[3]
        chat.messages.append(newMessage)
//        let newMessage = Message

        // TODO: Cache new message. Send new message. - Needs a variable to know if it was uploaded or not?

//        messages.append(newMessage)
    }
}
