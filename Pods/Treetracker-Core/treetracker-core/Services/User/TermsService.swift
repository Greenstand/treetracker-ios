//
//  TermsService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public protocol TermsService {
    func fetchTerms(completion: (Result<Terms, Error>) -> Void)
    func acceptTerms(forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void)
}

// MARK: - Errors
public enum TermsServiceError: Swift.Error {
    case planterError
}

class LocalTermsService: TermsService {

    private let coreDataManager: CoreDataManaging
    private let terms: URL

    public init(
        coreDataManager: CoreDataManaging,
        terms: URL
    ) {
        self.coreDataManager = coreDataManager
        self.terms = terms
    }

    func fetchTerms(completion: (Result<Terms, Error>) -> Void) {

        do {
            let htmlString = try String(contentsOf: self.terms, encoding: .utf8)
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
