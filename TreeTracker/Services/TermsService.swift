//
//  TermsService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

class TermsService {

    enum FetchTermsError: Swift.Error {
        case invalidTermsURL
    }

    func fetchTerms(completion: (Result<Terms, Error>) -> Void) {

        guard let url = Bundle.main.url(forResource: "Terms", withExtension: "html") else {
            completion(.failure(FetchTermsError.invalidTermsURL))
            return
        }

        do {
            let htmlString = try String(contentsOf: url, encoding: .utf8)
            let terms = Terms(htmlString: htmlString)
            completion(.success(terms))
        } catch {
            completion(.failure(error))
        }
    }

    func acceptTerms(username: Username, completion: (Result<Username, Error>) -> Void) {
        completion(.success(username))
    }
}
