//
//  Message.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 03/04/2023.
//

import Foundation

public struct Message: Decodable {

    let messageId: String
    let parentMessageId: String?
    let from: String
    let to: String
    let subject: String?
    let body: String?
    let type: MessageType
    let composedAt: String
    let videoLink: String?
    let survey: SurveyResponse?
    let surveyResponse: [String]?

    private enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case parentMessageId = "parent_message_id"
        case from
        case to
        case subject
        case body
        case type
        case composedAt = "composed_at"
        case videoLink = "video_link"
        case survey
        case surveyResponse = "survey_response"
    }
}

// MARK: - Nested Types
public extension Message {

    enum MessageType: String, Decodable {
        case message
        case announce
        case survey
        case survey_response
    }

    struct SurveyResponse: Decodable {
        let surveyResponseId: String
        let title: String
        let questions: [QuestionResponse]

        private enum CodingKeys: String, CodingKey {
            case surveyResponseId = "id"
            case title
            case questions
        }
    }

    struct QuestionResponse: Decodable {
        let prompt: String
        let choices: [String]
    }
}
