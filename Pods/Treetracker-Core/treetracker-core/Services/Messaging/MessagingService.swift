//
//  MessagingService.swift
//  Pods
//
//  Created by Alex Cornforth on 03/04/2023.
//

import Foundation

public protocol MessagingService {
    func getMessages(planter: Planter, completion: @escaping (Result<[Message], Error>) -> Void)
}

// MARK: - Errors
public enum MessagingServiceError: Swift.Error {
    case missingPlanterIdentifier
}

class RemoteMessagesService: MessagingService {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func getMessages(planter: Planter, completion: @escaping (Result<[Message], Error>) -> Void) {

        guard let walletHandle = planter.identifier else {
            completion(.failure(MessagingServiceError.missingPlanterIdentifier))
            return
        }

        let request = GetMessagesRequest(
            walletHandle: walletHandle,
            lastSyncTime: .distantPast
        )

        apiService.performAPIRequest(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success([]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
