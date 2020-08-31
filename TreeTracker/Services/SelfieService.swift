//
//  SelfieService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct SelfieData {
    let pngData: Data
}

protocol SelfieService {
    func storeSelfie(selfieData data: SelfieData, forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void)
}

// MARK: - Errors
enum SelfieServiceError: Swift.Error {
    case planterError
}

class LocalSelfieService: SelfieService {

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func storeSelfie(selfieData data: SelfieData, forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void) {

        let identification = PlanterIdentification(context: coreDataManager.viewContext)
        identification.createdAt = Date()
        identification.localPhotoPath = ""

        guard let planter = planter as? PlanterDetail else {
            completion(.failure(SelfieServiceError.planterError))
            return
        }

        planter.addToIdentification(identification)

        do {
            try coreDataManager.viewContext.save()
            completion(.success(planter))
        } catch {
            completion(.failure(error))
        }
    }
}
