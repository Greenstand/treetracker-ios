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
    func uploadPlanterImage(planterIdentification: PlanterIdentification) throws
    func uploadPlanterInfo() throws
    func deleteLocalImagesThatWereUploaded() throws
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
    private let planter: Planter

    init(
        coreDataManager: CoreDataManaging,
        imageUploadService: ImageUploadService,
        bundleUploadService: BundleUploadService,
        documentManager: DocumentManaging,
        planter: Planter
    ) {
        self.coreDataManager = coreDataManager
        self.imageUploadService = imageUploadService
        self.bundleUploadService = bundleUploadService
        self.documentManager = documentManager
        self.planter = planter
    }

    var planterIdentificationsForUpload: [PlanterIdentification]? {
        return coreDataManager.perform(fetchRequest: identificationsToUpload)
    }
}

// MARK: - Planter Images
extension LocalPlanterUploadService {

    func uploadPlanterImage(planterIdentification: PlanterIdentification) throws {
        Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.uploadPlanterImage")

        let semaphore = DispatchSemaphore(value: 0)
        var uploadError: Error?

        guard let request = planterIdentification.imageUploadRequest(documentManager: documentManager) else {
            throw PlanterUploadServiceError.invalidPlanterData
        }

        Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.uploadPlanterImage: Will Upload Planter Image \(planterIdentification.uuid ?? "")")

        imageUploadService.uploadImage(request: request) { (result) in
            switch result {
            case .success(let url):
                Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.uploadPlanterImage: Did Upload Planter Image \(planterIdentification.uuid ?? "")")
                planterIdentification.photoURL = url
                self.coreDataManager.saveContext()
            case .failure(let error):
                Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.uploadPlanterImage: Error Uploading Planter Image \(planterIdentification.uuid ?? "")")
                uploadError = error
            }
            semaphore.signal()
        }
        semaphore.wait()

        if let error = uploadError {
            throw error
        }
    }
}

// MARK: - Planter Details
extension LocalPlanterUploadService {

    func uploadPlanterInfo() throws {
        Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.uploadPlanterInfo")
        guard let planters = coreDataManager.perform(fetchRequest: plantersToUpload) else {
            throw PlanterUploadServiceError.planterFetchError
        }

        let registrationRequests = planters.compactMap(\.registrationUploadRequest)

        guard registrationRequests.count > 0 else {
            return
        }

        let uploadBundle = UploadBundle(trees: nil, registrations: registrationRequests)
        guard let uploadRequest = uploadBundle.registrationBundleUploadRequest else {
            throw PlanterUploadServiceError.bundleCreationError
        }

        let semaphore = DispatchSemaphore(value: 0)
        var uploadError: Error?
        Logger.log("PLANTER UPLOAD: Will upload \(registrationRequests.count) / \(planters.count) planters")

        bundleUploadService.upload(withRequest: uploadRequest) { (result) in
            switch result {
            case .success:
                Logger.log("PLANTER UPLOAD: Did upload \(registrationRequests.count) / \(planters.count) planters")
                planters
                    .filter({ $0.registrationUploadRequest != nil })
                    .forEach { (planterDetail) in
                        Logger.log("PLANTER UPLOAD: Updating planter upload status \(planterDetail.identifier ?? "")")
                        planterDetail.uploaded = true
                        self.coreDataManager.saveContext()
                }

            case .failure(let error):
                uploadError = error
            }
            semaphore.signal()
        }
        semaphore.wait()

        if let error = uploadError {
            throw error
        }
        Logger.log("PLANTER UPLOAD: Uploaded all planter info")
    }
}

// MARK: - Delete Local Images
extension LocalPlanterUploadService {

    func deleteLocalImagesThatWereUploaded() throws {
        Logger.log("PLANTER UPLOAD: LocalPlanterUploadService.deleteLocalImagesThatWereUploaded")
        // Delete all local image files for registrations except for the currently logged in users photo...
        guard let planterIdentifications = coreDataManager.perform(fetchRequest: identificationsToDelete) else {
            throw PlanterUploadServiceError.planterIdentificationFetchError
        }

        Logger.log("PLANTER UPLOAD: Will remove \(planterIdentifications.count - 1) local planter photos")

        try planterIdentifications
            .filter({ $0.planter?.identifier != planter.identifier })
            .filter({ $0.localPhotoPath != nil })
            .filter({ $0.photoURL != nil })
            .forEach { (planterIdentification) in
                guard let localPhotoPath = planterIdentification.localPhotoPath else {
                    return
                }
                Logger.log("PLANTER UPLOAD: Removing local photo for planter \(planterIdentification.uuid ?? "")")
                if try documentManager.fileExists(withFileName: localPhotoPath) {
                    try documentManager.removeFile(withFileName: localPhotoPath)
                    planterIdentification.localPhotoPath = nil
                    coreDataManager.saveContext()
                }
            }
        Logger.log("PLANTER UPLOAD: Removed local planter images")
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
            latitude: 0.0,
            longitude: 0.0,
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
            latitude: nil,
            longitude: nil,
            deviceIdentifier: "",
            recordUUID: recordUUID,
            imageURL: imageURL
        )
    }
}
