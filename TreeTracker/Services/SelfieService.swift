//
//  SelfieService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

struct SelfieData {
    let jpegData: Data
}

protocol SelfieService {
    func storeSelfie(selfieData data: SelfieData, forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void)

    func fetchSelfie(forPlanter planter: Planter, completion: (Result<Data, Error>) -> Void)
}

// MARK: - Errors
enum SelfieServiceError: Swift.Error {
    case planterError
    case documentStorageError
}

class LocalSelfieService: SelfieService {

    private let coreDataManager: CoreDataManaging
    private let documentManager: DocumentManaging

    init(coreDataManager: CoreDataManaging, documentManager: DocumentManaging) {
        self.coreDataManager = coreDataManager
        self.documentManager = documentManager
    }

    func storeSelfie(selfieData data: SelfieData, forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void) {

        guard let planter = planter as? PlanterDetail else {
            completion(.failure(SelfieServiceError.planterError))
            return
        }

        let identificationID = UUID().uuidString

        guard let photoPath = try? documentManager.store(data: data.jpegData, withFileName: identificationID).get() else {
            completion(.failure(SelfieServiceError.documentStorageError))
            return
        }

        let identification = PlanterIdentification(context: coreDataManager.viewContext)
        identification.createdAt = Date()
        identification.localPhotoPath = photoPath
        identification.identifier = identificationID

        planter.addToIdentification(identification)

        do {
            try coreDataManager.viewContext.save()
            completion(.success(planter))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchSelfie(forPlanter planter: Planter, completion: (Result<Data, Error>) -> Void) {
        guard let planter = planter as? PlanterDetail else {
            completion(.failure(SelfieServiceError.planterError))
            return
        }

        if let identifier = planter.latestIdentification?.identifier {
            guard let selfieData = try? documentManager.retrieveData(forFileName: identifier).get() else {
                completion(.failure(SelfieServiceError.documentStorageError))
                return
            }

            completion(.success(selfieData))
        }
    }
}
