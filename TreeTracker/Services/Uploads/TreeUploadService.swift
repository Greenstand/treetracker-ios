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
    func uploadImage(forTree tree: Tree, completion: @escaping (Result<String, Error>) -> Void)
    func uploadDataBundle(forTrees trees: [Tree], completion: @escaping (Result<String?, Error>) -> Void)
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

    func uploadImage(forTree tree: Tree, completion: @escaping (Result<String, Error>) -> Void) {

        Logger.log("TREE IMAGE UPLOAD: Uploading image")

        guard let request = tree.imageUploadRequest(documentManager: self.documentManager) else {
            Logger.log("TREE IMAGE UPLOAD ERROR: TreeUploadServiceError.invalidTreeData")
            completion(.failure(TreeUploadServiceError.invalidTreeData))
            return
        }

        self.imageUploadService.uploadImage(request: request) { (result) in
            switch result {
            case .success(let url):
                tree.photoURL = url
                self.coreDataManager.saveContext()
                Logger.log("TREE IMAGE UPLOAD: Image upload success")
                completion(.success(url))
            case .failure(let error):
                Logger.log("TREE IMAGE UPLOAD ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Upload Tree Data Bundle
extension LocalTreeUploadService {

    func uploadDataBundle(forTrees trees: [Tree], completion: @escaping (Result<String?, Error>) -> Void) {

        Logger.log("TREE DATA UPLOAD: Uploading data")

        let newTreeRequests = trees.compactMap(\.newTreeRequest)

        guard newTreeRequests.count > 0 else {
            Logger.log("TREE DATA UPLOAD: No data to upload")
            completion(.success(nil))
            return
        }

        let uploadBundle = TreeUploadBundle(trees: newTreeRequests)

        bundleUploadService.upload(bundle: uploadBundle) { (result) in
            switch result {
            case .success(let url):
                trees
                    .filter({ $0.newTreeRequest != nil })
                    .forEach { (tree) in
                        tree.uploaded = true
                        self.coreDataManager.saveContext()
                    }
                Logger.log("TREE DATA UPLOAD: Data upload success")
                completion(.success(url))
            case .failure(let error):
                Logger.log("TREE DATA UPLOAD ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Tree Delete Tree Images
extension LocalTreeUploadService {

    func deleteLocalImages(forTrees trees: [Tree]) throws {
        Logger.log("TREE IMAGE DELETION: Deleting images")
        try trees
            .filter({ $0.localPhotoPath != nil })
            .filter({ $0.photoURL != nil })
            .forEach { (tree) in
                guard let localPhotoPath = tree.localPhotoPath,
                      try documentManager.fileExists(withFileName: localPhotoPath) else {
                    return
                }
                try documentManager.removeFile(withFileName: localPhotoPath)
                tree.localPhotoPath = nil
                coreDataManager.saveContext()

            }
        Logger.log("TREE IMAGE DELETION: Deleted images successfully")
    }
}

// MARK: - Tree Locations Upload
extension LocalTreeUploadService {
    func uploadTreeLocations() {
        Logger.log("TREE LOCATION UPLOAD: Uploading locations")
        Logger.log("TREE LOCATION UPLOAD: Nothing to upload")
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
