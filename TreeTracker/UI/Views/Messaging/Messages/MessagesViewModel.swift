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

    init(planter: Planter, messagingService: MessagingService) {
        self.planter = planter
        self.messagingService = messagingService
    }
    
    private var messages: [MessageEntity] = []

    var title: String {
        L10n.Messages.title
    }

    var numberOfRowsInSection: Int {
        messages.count
    }

    func getMessageForRowAt(indexPath: IndexPath) -> MessageEntity {
        messages[indexPath.row]
    }

    func getPlanterIdentifier() -> String? {
        planter.identifier
    }

    func sendMessage(text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)

        do {
            let newMessage = try messagingService.createMessage(planter: planter, text: trimmedText)
            messages.append(newMessage)
        } catch {
            print(error.localizedDescription)
        }
    }

    func getMessages() {
        messages = messagingService.getMessagesToPresent(planter: planter)
    }
}
