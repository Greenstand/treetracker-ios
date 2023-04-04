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
}
