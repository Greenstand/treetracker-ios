//
//  LoginService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CoreData

public protocol LoginService {
    func login(withUsername username: Username, completion: (Result<Planter, Error>) -> Void)
}

// MARK: - Errors
public enum LoginServiceError: Error {
    case unknownUser(Username)
    case sessionTimedOut(Planter)
    case acceptTermsRequired(Planter)
    case selfieRequired(Planter)
}

class LocalLoginService: LoginService {

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func login(withUsername username: Username, completion: (Result<Planter, Error>) -> Void) {

        let managedObjectContext = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<PlanterDetail> = PlanterDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", username.value)

        do {
            let planters = try managedObjectContext.fetch(fetchRequest)

            guard let planter = planters.first else {
                completion(.failure(LoginServiceError.unknownUser(username)))
                return
            }

            guard planter.acceptedTerms == true else {
                completion(.failure(LoginServiceError.acceptTermsRequired(planter)))
                return
            }

            guard let identifications = planter.identification as? Set<PlanterIdentification>,
                identifications.count > 0 else {
                    completion(.failure(LoginServiceError.selfieRequired(planter)))
                    return
            }

            completion(.success(planter))
        } catch {
            completion(.failure(error))
        }
    }
}
