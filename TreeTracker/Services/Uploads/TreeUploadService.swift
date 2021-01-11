//
//  TreeUploadService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 19/09/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation
import CoreData

protocol TreeUploadService {
    var treesToUpload: [Tree]? { get }
    func uploadImage(forTree tree: Tree) throws
    func uploadDataBundle(forTrees trees: [Tree]) throws
    func deleteLocalImages(forTrees trees: [Tree]) throws
    func uploadTreeLocations()
}

enum TreeUploadServiceError: Error {
    case fetchTreesError
    case invalidTreeData
    case bundleCreationError
}

class LocalTreeUploadService: TreeUploadService {

    private let coreDataManager: CoreDataManaging
    private let bundleUploadService: BundleUploadService
    private let imageUploadService: ImageUploadService
    private let documentManager: DocumentManaging

    init(
        coreDataManager: CoreDataManaging,
        bundleUploadService: BundleUploadService,
        imageUploadService: ImageUploadService,
        documentManager: DocumentManaging
    ) {
        self.coreDataManager = coreDataManager
        self.bundleUploadService = bundleUploadService
        self.imageUploadService = imageUploadService
        self.documentManager = documentManager
    }

    var treesToUpload: [Tree]? {
        let fetchRequest: NSFetchRequest<TreeCapture> = TreeCapture.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uploaded == false")
        return coreDataManager.perform(
            fetchRequest: fetchRequest
        )
    }
}

// MARK: - Upload Tree Image
extension LocalTreeUploadService {

    func uploadImage(forTree tree: Tree) throws {
        Logger.log("TREE UPLOAD: LocalTreeUploadService.uploadImage")

        guard let request = tree.imageUploadRequest(documentManager: self.documentManager) else {
            throw TreeUploadServiceError.invalidTreeData
        }

        let semaphore = DispatchSemaphore(value: 0)
        var uploadError: Error?

        self.imageUploadService.uploadImage(request: request) { (result) in
            switch result {
            case .success(let url):
                Logger.log("TREE UPLOAD: Did Upload Tree Image \(tree.uuid ?? "")")
                tree.photoURL = url
                self.coreDataManager.saveContext()
            case .failure(let error):
                Logger.log("TREE UPLOAD: Error Uploading Tree Image \(tree.uuid ?? "")")
                uploadError = error
            }
            semaphore.signal()
        }
        semaphore.wait()

        if let uploadError = uploadError {
            throw uploadError
        }
    }
}

// MARK: - Upload Tree Data Bundle
extension LocalTreeUploadService {

    func uploadDataBundle(forTrees trees: [Tree]) throws {

        Logger.log("TREE UPLOAD: LocalTreeUploadService.uploadTrees")

        let newTreeRequests = trees.compactMap(\.newTreeRequest)

        guard newTreeRequests.count > 0 else {
            return
        }
        Logger.log("TREE UPLOAD: Will upload \(newTreeRequests.count) / \(trees.count) Trees")
        let uploadBundle = UploadBundle(trees: newTreeRequests, registrations: nil)
        guard let uploadRequest = uploadBundle.treeBundleUploadRequest else {
            throw TreeUploadServiceError.bundleCreationError
        }

        let semaphore = DispatchSemaphore(value: 0)
        var uploadError: Error?

        bundleUploadService.upload(withRequest: uploadRequest) { (result) in
            switch result {
            case .success:
                Logger.log("TREE UPLOAD: Did upload \(newTreeRequests.count) / \(trees.count) Trees")
                trees
                    .filter({ $0.newTreeRequest != nil })
                    .forEach { (tree) in
                        Logger.log("TREE UPLOAD: Updating Tree upload status \(tree.uuid ?? "")")
                        tree.uploaded = true
                        self.coreDataManager.saveContext()
                    }
            case .failure(let error):
                Logger.log("TREE UPLOAD: Error uploading Tree Bundle")
                uploadError = error
            }
            semaphore.signal()
        }
        semaphore.wait()

        if let error = uploadError {
            throw error
        }
        Logger.log("TREE UPLOAD: Uploaded \(trees.count) Tree Captures")
    }
}

// MARK: - Tree Delete Tree Images
extension LocalTreeUploadService {

    func deleteLocalImages(forTrees trees: [Tree]) throws {
        Logger.log("TREE UPLOAD: LocalTreeUploadService.deleteLocalImages: Will remove \(trees.count) local tree photos")
        try trees
            .filter({ $0.localPhotoPath != nil })
            .filter({ $0.photoURL != nil })
            .forEach { (tree) in
                guard let localPhotoPath = tree.localPhotoPath,
                      try documentManager.fileExists(withFileName: localPhotoPath) else {
                    return
                }
                Logger.log("TREE UPLOAD: LocalTreeUploadService.deleteLocalImages: Removing local photo for tree \(tree.uuid ?? "")")
                try documentManager.removeFile(withFileName: localPhotoPath)
                tree.localPhotoPath = nil
                coreDataManager.saveContext()
            }
    }
}

// MARK: - Tree Locations Upload
extension LocalTreeUploadService {
    func uploadTreeLocations() {
        Logger.log("TREE UPLOAD: LocalTreeUploadService.uploadTreeLocations")
    }
}

// MARK: - Tree Extension
private extension Tree {

    var newTreeRequest: NewTreeRequest? {

        guard let uuid = uuid,
              let imageURL = photoURL,
              let timeStamp = createdAt?.timeIntervalSince1970,
              let planterPhotoUrl = planterCheckIn?.photoURL,
              let planterIdentifier = planterCheckIn?.planterDetail?.identifier else {
            return nil
        }

        return NewTreeRequest(
            userId: 0,
            uuid: uuid,
            latitude: latitude,
            longitude: longitude,
            gpsAccuracy: horizontalAccuracy,
            note: noteContent ?? "",
            timestamp: timeStamp,
            imgeURL: imageURL,
            sequenceId: 0,
            deviceIdentifier: DeviceInfoProvider().deviceId, //Should really inject this
            planterPhotoUrl: planterPhotoUrl,
            planterIdentifier: planterIdentifier,
            attributes: []
        )
    }

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
