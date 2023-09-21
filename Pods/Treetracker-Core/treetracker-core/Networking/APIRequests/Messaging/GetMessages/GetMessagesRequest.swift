//
//  GetMessagesRequest.swift
//  AWSCore
//
//  Created by Alex Cornforth on 03/04/2023.
//

import Foundation

struct GetMessagesRequest: APIRequest {

    struct Parameters: Encodable {
        let handle: String
        let since: Date
        let offset: Int
        let limit: Int
    }

    let endpoint: Endpoint = .messages
    let method: HTTPMethod = .GET
    typealias ResponseType = GetMessagesResponse

    let parameters: Parameters

    init(walletHandle: String, lastSyncTime: Date, offset: Int = 0, limit: Int = 10) {
        self.parameters = Parameters(
            handle: walletHandle,
            since: lastSyncTime,
            offset: offset,
            limit: limit
        )
    }

    private var dateFormatter: ISO8601DateFormatter {
        return MessagingAPIDateFormatter()
    }

    var queryItemsParameterDateFormatter: ISO8601DateFormatter {
        return dateFormatter
    }

    var responseDecoder: JSONDecoder {
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
