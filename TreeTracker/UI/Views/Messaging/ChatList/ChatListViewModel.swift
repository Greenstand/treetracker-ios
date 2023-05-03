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
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didUpdateChats chats: [ChatListViewModel.Chat])
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

    var numberOfRowsInSection: Int {
        chats.count
    }

    func cellForRowAt(indexPath: IndexPath) -> ChatListViewModel.Chat {
        chats[indexPath.row]
    }

    private var chats: [Chat] = [] {
        didSet {
            viewDelegate?.chatListViewModel(self, didUpdateChats: chats)
        }
    }
}

// MARK: = Messaging
extension ChatListViewModel {

    func fetchMessages() {
        var chatList: [Chat] = []
        let allMessages = messagingService.getSavedMessages(planter: planter)

        for message in allMessages {
            let messageType = messageType(type: message.type)

            let messageDetail = MessageDetail(
                messageId: message.messageId ?? "",
                from: message.from ?? "",
                to: message.to ?? "",
                body: message.body,
                composedAt: message.composedAt ?? "",
                videoLink: message.videoLink,
                unread: message.unread
            )

            switch messageType {
            case .message:

                if let index = chatList.firstIndex(where: { $0.type == .message }) {
                    chatList[index].messages.append(messageDetail)

                } else {
                    let newChat = Chat(
                        title: message.subject ?? "Admin",
                        type: messageType,
                        messages: [messageDetail]
                    )
                    chatList.insert(newChat, at: 0)
                }

            case .announce, .survey, .surveyResponse:
                let newChat = Chat(
                    title: message.subject ?? "Announce!",
                    type: messageType,
                    messages: [messageDetail]
                )
                chatList.append(newChat)
            }
        }

        self.chats = chatList
    }

    func updateUnreadMessagesCount(indexPath: IndexPath) {
        var messagesId: [String] = []

        var updatedMessages = chats[indexPath.row].messages.map { messageDetail -> MessageDetail in
            messagesId.append(messageDetail.messageId)
            var message = messageDetail
            message.unread = false
            return message
        }

        self.chats[indexPath.row].messages = updatedMessages

        messagingService.updateUnreadMessages(planter: planter, messageId: messagesId)
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
        let selectedChat = chats[indexPath.row]
        coordinatorDelegate?.chatListViewModel(self, didSelectChat: selectedChat, forPlanter: planter)
    }

}

// MARK: - Nested Types
extension ChatListViewModel {

    struct Chat {
        let title: String
        let type: MessageType
        var messages: [MessageDetail]

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

    struct MessageDetail {
        let messageId: String
        let from: String
        let to: String
        let body: String?
        let composedAt: String
        let videoLink: String?
//        let survey: SurveyResponse?
//        let surveyResponse: [String]?

        var unread: Bool
        var isFromAdmin: Bool {
            from == "admin"
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
