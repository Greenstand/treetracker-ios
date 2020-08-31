//
//  DocumentManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 18/08/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol DocumentManaging {
    func store(data: Data, withFileName fileName: String) -> Result<String, Error>
    func retrieveData(forFileName fileName: String) -> Result<Data, Error>
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
            return .success(fileURL.absoluteString)
        } catch {
            return .failure(error)
        }
    }

    func retrieveData(forFileName fileName: String) -> Result<Data, Error> {
        do {
            let fileURL = try documentsDirectoryPath(forFileName: fileName)
            let data = try Data(contentsOf: fileURL)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Private
extension DocumentManager {

    func documentsDirectoryPath(forFileName fileName: String) throws -> URL {
        return try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(fileName)
    }
}
