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
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectChat chat: ChatListViewModel.Chat, forPlanter planter: Planter)
}

protocol ChatListViewModelViewDelegate: AnyObject {
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didFetchProfile image: UIImage)
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didUpdateChatList chatList: [ChatListViewModel.Chat])
}

class ChatListViewModel {

    weak var coordinatorDelegate: ChatListViewModelCoordinatorDelegate?
    weak var viewDelegate: ChatListViewModelViewDelegate?

    private let selfieService: SelfieService
    private let messagingService: MessagingService
    private var planter: Planter

    init(planter: Planter, selfieService: SelfieService, messagingService: MessagingService) {
        self.planter = planter
        self.selfieService = selfieService
        self.messagingService = messagingService
    }

    var title: String {
        return planter.firstName ?? ""
    }

    private var chatList: [Chat] = [] {
        didSet {
            viewDelegate?.chatListViewModel(self, didUpdateChatList: chatList)
        }
    }

    var numberOfRowsInSection: Int {
        chatList.count
    }

    func cellForRowAt(indexPath: IndexPath) -> ChatListViewModel.Chat {
        chatList[indexPath.row]
    }

}

// MARK: = Messaging
extension ChatListViewModel {

    func fetchMessages() {
        var chatList: [Chat] = []
        let allMessages = messagingService.getSavedMessages(planter: planter)

        for message in allMessages {
            let messageType = messageType(type: message.type)

            switch messageType {
            case .message:
                if let index = chatList.firstIndex(where: { $0.type == .message }) {
                    chatList[index].messages.append(message)

                } else {
                    let newChat = Chat(
                        title: message.subject ?? "Admin",
                        type: messageType,
                        messages: [message]
                    )
                    chatList.insert(newChat, at: 0)
                }

            case .announce, .survey, .surveyResponse:
                let newChat = Chat(
                    title: message.subject ?? "Announce!",
                    type: messageType,
                    messages: [message]
                )
                chatList.append(newChat)
            }
        }

        self.chatList = chatList
    }

    func updateUnreadMessagesCount(indexPath: IndexPath) {
        let messagesToUpdate = chatList[indexPath.row].messages

        let updatedMessages = messagingService.updateUnreadMessages(messages: messagesToUpdate)
        self.chatList[indexPath.row].messages = updatedMessages
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

    func chatSelected(indexPath: IndexPath) {
        updateUnreadMessagesCount(indexPath: indexPath)
        let selectedChat = chatList[indexPath.row]
        coordinatorDelegate?.chatListViewModel(self, didSelectChat: selectedChat, forPlanter: planter)
    }

}

// MARK: - Nested Types
extension ChatListViewModel {

    struct Chat {
        let title: String
        let type: MessageType
        var messages: [MessageEntity]

        var image: UIImage {
            switch type {
            case .message:
                return Asset.Assets.forest.image
            case .announce:
                return Asset.Assets.gardening.image
            case .survey:
                return Asset.Assets.logo.image
            case .surveyResponse:
                return Asset.Assets.people.image
            }
        }

        var unreadCount: Int {
            messages.reduce(0) { $0 + ($1.unread ? 1 : 0) }
        }
    }

    enum MessageType: String, Decodable {
        case message
        case announce
        case survey
        case surveyResponse
    }

    func messageType(type: String?) -> MessageType {
        switch type {
        case "message": return .message
        case "announce": return .announce
        case "survey": return .survey
        case "survey_response": return .surveyResponse
        default: return .message
        }
    }

}
