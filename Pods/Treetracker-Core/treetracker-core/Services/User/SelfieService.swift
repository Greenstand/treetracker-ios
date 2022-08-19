//
//  SelfieService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public struct SelfieData {

    let jpegData: Data
    let latitude: Double
    let longitude: Double

    public init(
        jpegData: Data,
        latitude: Double,
        longitude:  Double
    ) {
        self.jpegData = jpegData
        self.latitude = latitude
        self.longitude = longitude
    }
}

public protocol SelfieService {
    func storeSelfie(selfieData data: SelfieData, forPlanter planter: Planter, completion: (Result<Planter, Error>) -> Void)

    func fetchSelfie(forPlanter planter: Planter, completion: (Result<Data, Error>) -> Void)
}

// MARK: - Errors
public enum SelfieServiceError: Swift.Error {
    case planterError
    case documentStorageError
    case missingLocalPhotoPath
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

        let uuid = UUID().uuidString

        guard let photoPath = try? documentManager.store(data: data.jpegData, withFileName: uuid).get() else {
            completion(.failure(SelfieServiceError.documentStorageError))
            return
        }

        let identification = PlanterIdentification(context: coreDataManager.viewContext)
        identification.createdAt = Date()
        identification.localPhotoPath = photoPath
        identification.uuid = uuid
        identification.latitude = data.latitude
        identification.longitude = data.longitude

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

        guard let localPhotoPath = planter.latestIdentification?.localPhotoPath else {
            completion(.failure(SelfieServiceError.missingLocalPhotoPath))
            return
        }

        guard let selfieData = try? documentManager.retrieveData(withFileName: localPhotoPath).get() else {
            completion(.failure(SelfieServiceError.documentStorageError))
            return
        }

        completion(.success(selfieData))
    }
}
