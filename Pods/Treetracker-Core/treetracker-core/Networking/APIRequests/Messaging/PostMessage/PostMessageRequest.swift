//
//  PostMessageRequest.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 17/09/2023.
//

import Foundation

struct PostMessageRequest: APIRequest {

    struct Parameters: Encodable {
        let messageId: String
        let parentMessageId: String
        let authorHandle: String
        let recipientHandle: String?
        let subject: String
        let body: String
        let composedAt: Date
        let surveyResponse: [String]?
        let surveyId: String?

        private enum CodingKeys: String, CodingKey {
            case messageId = "id"
            case parentMessageId = "parent_message_id"
            case authorHandle = "author_handle"
            case recipientHandle = "recipient_handle"
            case subject
            case body
            case composedAt = "composed_at"
            case surveyResponse = "survey_response"
            case surveyId = "survey_id"
        }
    }

    let endpoint: Endpoint = .messages
    let method: HTTPMethod = .POST
    typealias ResponseType = PostMessageResponse

    let parameters: Parameters

    init(message: NewMessage) {
        self.parameters = Parameters(
            messageId: message.messageId,
            parentMessageId: message.parentMessageId,
            authorHandle: message.authorHandle,
            recipientHandle: message.recipientHandle,
            subject: message.subject,
            body: message.body,
            composedAt: message.composedAt,
            surveyResponse: message.surveyResponse,
            surveyId: message.surveyId
        )
    }

    private var dateFormatter: ISO8601DateFormatter {
        return MessagingAPIDateFormatter()
    }

    var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = dateFormatter.string(from: date)
            try container.encode(dateString)
        })
        return encoder
    }

    var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        return jsonDecoder
    }
}
