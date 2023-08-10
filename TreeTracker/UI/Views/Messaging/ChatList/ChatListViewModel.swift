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
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectMessages planter: Planter)
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectAnnounce chat: ChatListViewModel.Chat)
    func chatListViewModel(_ chatListViewModel: ChatListViewModel, didSelectSurvey survey: SurveyViewModel.Survey, planter: Planter)
}

protocol ChatListViewModelViewDelegate: AnyObject {
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
        let allMessages = messagingService.getChatListMessages(planter: planter)

        for message in allMessages {
            let messageType = messageType(type: message.type)

            switch messageType {
            case .message:
                if let index = chatList.firstIndex(where: { $0.type == .message }) {
                    chatList[index].messages.append(message)

                } else {
                    let newChat = Chat(
                        title: message.subject ?? L10n.ChatList.MessageChatCell.fallbackTitle,
                        type: messageType,
                        messages: [message]
                    )
                    chatList.insert(newChat, at: 0)
                }

            default:
                let newChat = Chat(
                    title: message.subject ?? L10n.ChatList.DefaultCell.fallbackTitle,
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
        messagingService.updateUnreadMessages(messages: messagesToUpdate)
    }

}

// MARK: - Navigation
extension ChatListViewModel {

    func chatSelected(indexPath: IndexPath) {
        let selectedChat = chatList[indexPath.row]
        updateUnreadMessagesCount(indexPath: indexPath)

        switch selectedChat.type {
        case .message:
            coordinatorDelegate?.chatListViewModel(self, didSelectMessages: planter)
        case .announce:
            coordinatorDelegate?.chatListViewModel(self, didSelectAnnounce: selectedChat)
        case .survey, .survey_response:

            guard let message = selectedChat.messages.first,
                  let questions = message.survey?.questions?.array as? [SurveyQuestion] else {
                return
            }

            let survey = SurveyViewModel.Survey(
                surveyId: message.survey?.uuid ?? "",
                title: message.survey?.title ?? "",
                questions: questions.map({ question in
                    return SurveyViewModel.Question(
                        prompt: question.prompt ?? "",
                        choices: question.choices ?? [])
                }),
                surveyResponse: message.surveyResponse ?? [],
                response: message.survey?.response ?? false
            )

            coordinatorDelegate?.chatListViewModel(self, didSelectSurvey: survey, planter: planter)
        }
    }

}

// MARK: - Nested Types
extension ChatListViewModel {

    struct Chat {
        let title: String
        let type: Message.MessageType
        var messages: [MessageEntity]

        var image: UIImage {
            switch type {
            case .message:
                return Asset.Assets.forest.image
            case .announce:
                return Asset.Assets.gardening.image
            case .survey:
                return Asset.Assets.logo.image
            case .survey_response:
                return Asset.Assets.people.image
            }
        }

        var unreadCount: Int {
            messages.reduce(0) { $0 + ($1.unread ? 1 : 0) }
        }
    }

    func messageType(type: String?) -> Message.MessageType {
        switch type {
        case "message": return .message
        case "announce": return .announce
        case "survey": return .survey
        case "survey_response": return .survey_response
        default: return .message
        }
    }

}
