//
//  NewMessage.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 17/09/2023.
//

import Foundation

struct NewMessage {
    
    let messageId: String
    let parentMessageId: String
    let authorHandle: String
    let recipientHandle: String?
    let subject: String
    let body: String
    let composedAt: Date
    let surveyResponse: [String]?
    let surveyId: String?

    init(
        parentMessageId: String,
        authorHandle: String,
        recipientHandle: String? = nil,
        subject: String,
        body: String,
        composedAt: Date,
        surveyResponse: [String]? = nil,
        surveyId: String? = nil
    ) {
        self.messageId = UUID().uuidString
        self.parentMessageId = parentMessageId
        self.authorHandle = authorHandle
        self.recipientHandle = recipientHandle
        self.subject = subject
        self.body = body
        self.composedAt = composedAt
        self.surveyResponse = surveyResponse
        self.surveyId = surveyId
    }
}
