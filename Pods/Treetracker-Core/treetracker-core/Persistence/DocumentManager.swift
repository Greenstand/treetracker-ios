//
//  DocumentManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 18/08/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public protocol DocumentManaging {
    func store(data: Data, withFileName fileName: String) -> Result<String, Error>
    func retrieveData(withFileName fileName: String) -> Result<Data, Error>
    func removeFile(withFileName fileName: String) throws
    func fileExists(withFileName fileName: String) throws -> Bool
}

class DocumentManager: DocumentManaging {

    private let fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func store(data: Data, withFileName fileName: String) -> Result<String, Error> {
        do {
            let fileURL = try documentsDirectoryPath(forFileName: fileName)
            try data.write(to: fileURL)
            return .success(fileName)
        } catch {
            return .failure(error)
        }
    }

    func retrieveData(withFileName fileName: String) -> Result<Data, Error> {

        do {
            let fileURL = try documentsDirectoryPath(forFileName: fileName)
            let data = try Data(contentsOf: fileURL)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

    func removeFile(withFileName fileName: String) throws {
        let fileURL = try documentsDirectoryPath(forFileName: fileName)
        try fileManager.removeItem(at: fileURL)
    }

    func fileExists(withFileName fileName: String) throws -> Bool {
        let fileURL = try documentsDirectoryPath(forFileName: fileName)
        return fileManager.fileExists(atPath: fileURL.absoluteString)
    }
}

// MARK: - Private
private extension DocumentManager {

    func documentsDirectoryPath(forFileName fileName: String) throws -> URL {
        return try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(fileName)
    }
}
