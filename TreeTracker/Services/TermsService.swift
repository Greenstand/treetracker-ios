//
//  TermsService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol TermsService {
    func fetchTerms(completion: (Result<Terms, Error>) -> Void)
    func acceptTerms(forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void)
}

// MARK: - Errors
enum TermsServiceError: Swift.Error {
    case planterError
    case invalidTermsURL
}

class LocalTermsService: TermsService {

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func fetchTerms(completion: (Result<Terms, Error>) -> Void) {

        guard let url = Bundle.main.url(forResource: "Terms", withExtension: "html") else {
            completion(.failure(TermsServiceError.invalidTermsURL))
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

    func acceptTerms(forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void) {

        guard let planter = planter as? PlanterDetail else {
            completion(.failure(TermsServiceError.planterError))
            return
        }

        planter.acceptedTerms = true

        do {
            try coreDataManager.viewContext.save()
            completion(.success(planter))
        } catch {
            completion(.failure(error))
        }
    }
}
