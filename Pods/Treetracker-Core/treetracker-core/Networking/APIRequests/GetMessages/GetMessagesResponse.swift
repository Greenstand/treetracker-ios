//
//  GetMessagesResponse.swift
//  Pods
//
//  Created by Alex Cornforth on 03/04/2023.
//

import Foundation

struct GetMessagesResponse: Decodable {
    let messages: [Message]
}
