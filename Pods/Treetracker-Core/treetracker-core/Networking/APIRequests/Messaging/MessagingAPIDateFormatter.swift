//
//  MessagingAPIDateFormatter.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 17/09/2023.
//

import Foundation

class MessagingAPIDateFormatter: ISO8601DateFormatter {

    override init() {
        super.init()
        formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
