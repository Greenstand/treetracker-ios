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

    private(set) var messages: [Message] = []

    init(planter: Planter, messagingService: MessagingService) {
        self.planter = planter
        self.messagingService = messagingService
    }

    var numberOfRowsInSection: Int {
        messages.count
    }

    func getMessageForRowAt(indexPath: IndexPath) -> Message {
        messages[indexPath.row]
    }

    func getPlanterName() -> String {
        planter.firstName ?? ""
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

    func sendMessage(text: String) {
        let newMessage = messages[3]
        messages.append(newMessage)
//        let newMessage = Message

        // TODO: Cache new message. Send new message. - Needs a variable to know if it was uploaded or not?

//        messages.append(newMessage)
    }
}
