//
//  PlanterUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 01/12/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CoreData

protocol PlanterUploadService {
    var planterIdentificationsForUpload: [PlanterIdentification]? { get }
    func uploadPlanterImage(planterIdentification: PlanterIdentification, completion: @escaping (Result<String, Error>) -> Void)
    func uploadPlanterInfo(completion: @escaping (Result<String?, Error>) -> Void)
    func deleteLocalImagesThatWereUploaded(currentPlanter: Planter) throws
}

// MARK: - Errors
enum PlanterUploadServiceError: Error {
    case planterIdentificationFetchError
    case planterFetchError
    case bundleCreationError
    case invalidPlanterData
}

class LocalPlanterUploadService: PlanterUploadService {

    private let coreDataManager: CoreDataManaging
    private let imageUploadService: ImageUploadService
    private let bundleUploadService: BundleUploadService
    private let documentManager: DocumentManaging

    init(
        coreDataManager: CoreDataManaging,
        imageUploadService: ImageUploadService,
        bundleUploadService: BundleUploadService,
        documentManager: DocumentManaging
    ) {
        self.coreDataManager = coreDataManager
        self.imageUploadService = imageUploadService
        self.bundleUploadService = bundleUploadService
        self.documentManager = documentManager
    }

    var planterIdentificationsForUpload: [PlanterIdentification]? {
        return coreDataManager.perform(fetchRequest: identificationsToUpload)
    }
}

// MARK: - Planter Images
extension LocalPlanterUploadService {

    func uploadPlanterImage(planterIdentification: PlanterIdentification, completion: @escaping (Result<String, Error>) -> Void) {

        Logger.log("PLANTER IMAGE UPLOAD: Uploading image")

        guard let request = planterIdentification.imageUploadRequest(documentManager: documentManager) else {
            Logger.log("PLANTER IMAGE UPLOAD ERROR: PlanterUploadServiceError.invalidPlanterData")
            completion(.failure(PlanterUploadServiceError.invalidPlanterData))
            return
        }

        imageUploadService.uploadImage(request: request) { (result) in
            switch result {
            case .success(let url):
                planterIdentification.photoURL = url
                self.coreDataManager.saveContext()
                Logger.log("PLANTER IMAGE UPLOAD: Image upload success")
                completion(.success(url))
            case .failure(let error):
                Logger.log("PLANTER IMAGE UPLOAD ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Planter Details
extension LocalPlanterUploadService {

    func uploadPlanterInfo(completion: @escaping (Result<String?, Error>) -> Void) {
        Logger.log("PLANTER INFO UPLOAD: Uploading info")

        guard let planters = coreDataManager.perform(fetchRequest: plantersToUpload) else {
            Logger.log("PLANTER INFO UPLOAD ERROR: PlanterUploadServiceError.planterFetchError")
            completion(.failure(PlanterUploadServiceError.planterFetchError))
            return
        }

        let registrationRequests = planters.compactMap(\.registrationUploadRequest)

        guard registrationRequests.count > 0 else {
            Logger.log("PLANTER INFO UPLOAD: No info to upload")
            completion(.success(nil))
            return
        }

        let uploadBundle = RegistrationsUploadBundle(registrations: registrationRequests)

        bundleUploadService.upload(bundle: uploadBundle) { (result) in
            switch result {
            case .success(let url):
                planters
                    .filter({ $0.registrationUploadRequest != nil })
                    .forEach { (planterDetail) in
                        planterDetail.uploaded = true
                        self.coreDataManager.saveContext()
                }
                Logger.log("PLANTER INFO UPLOAD: Info upload success")
                completion(.success(url))
            case .failure(let error):
                Logger.log("PLANTER INFO UPLOAD ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }

}

// MARK: - Delete Local Images
extension LocalPlanterUploadService {

    func deleteLocalImagesThatWereUploaded(currentPlanter: Planter) throws {
        Logger.log("PLANTER IMAGE DELETION: Deleting local images")
        // Delete all local image files for registrations except for the currently logged in users photo...
        guard let planterIdentifications = coreDataManager.perform(fetchRequest: identificationsToDelete) else {
            throw PlanterUploadServiceError.planterIdentificationFetchError
        }

        try planterIdentifications
            .filter({ $0.planter?.identifier != currentPlanter.identifier })
            .filter({ $0.localPhotoPath != nil })
            .filter({ $0.photoURL != nil })
            .forEach { (planterIdentification) in
                guard let localPhotoPath = planterIdentification.localPhotoPath else {
                    return
                }
                if try documentManager.fileExists(withFileName: localPhotoPath) {
                    try documentManager.removeFile(withFileName: localPhotoPath)
                    planterIdentification.localPhotoPath = nil
                    coreDataManager.saveContext()
                }
            }
        Logger.log("PLANTER IMAGE DELETION: Deleted local images successfully")
    }
}

// MARK: - Fetch Requests
private extension LocalPlanterUploadService {

    var identificationsToUpload: NSFetchRequest<PlanterIdentification> {
        let fetchRequest: NSFetchRequest<PlanterIdentification> = PlanterIdentification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "photoURL == nil")
        return fetchRequest
    }

    var plantersToUpload: NSFetchRequest<PlanterDetail> {
        let fetchRequest: NSFetchRequest<PlanterDetail> = PlanterDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uploaded == false")
        return fetchRequest
    }

    var identificationsToDelete: NSFetchRequest<PlanterIdentification> {
        let fetchRequest: NSFetchRequest<PlanterIdentification> = PlanterIdentification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "localPhotoPath != nil")
        return fetchRequest
    }
}

// MARK: - PlanterIdentification Extension
private extension PlanterIdentification {

    func imageUploadRequest(documentManager: DocumentManaging) -> ImageUploadRequest? {
        guard let photoPath = localPhotoPath,
              let uuid = uuid,
              let data = try? documentManager.retrieveData(withFileName: photoPath).get() else {
            return nil
        }
        return ImageUploadRequest(
            jpegData: data,
            latitude: latitude,
            longitude: longitude,
            uuid: uuid
        )
    }
}

private extension PlanterDetail {

    var registrationUploadRequest: RegistrationRequest? {
        guard let planterIdentifier = identifier,
              let firstName = firstName,
              let lastName = lastName,
              let imageURL = firstIdentificationURL,
              let recordUUID = uuid else {
            return nil
        }
        return RegistrationRequest(
            planterIdentifier: planterIdentifier,
            firstName: firstName,
            lastName: lastName,
            organization: organization,
            phone: phoneNumber,
            email: email,
            latitude: latitude,
            longitude: longitude,
            deviceIdentifier: DeviceInfoProvider().deviceId, //Should really inject this
            recordUUID: recordUUID,
            imageURL: imageURL
        )
    }
}
