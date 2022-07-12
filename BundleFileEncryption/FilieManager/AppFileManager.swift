//
//  AppFileManager.swift
//  BundleFileEncryption
//

import Foundation

final class AppFileManager {

    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    func readFromBundle(fileName: String, fileType: FileType) throws -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType.fileExtension) else {
            throw Error.resourceIsMissing
        }
        let data = try Data(contentsOf: url)

        return data
    }

    func readFromDocuments(fileName: String, fileType: FileType) throws -> Data {
        guard let documents = documentDirectory else {
            throw Error.resourceIsMissing
        }
        let url = documents.appendingPathComponent("\(fileName).\(fileType.fileExtension)")
        let data = try Data(contentsOf: url)

        return data
    }


    func writeToDocuments(_ data: Data, fileName: String, fileType: FileType) throws {
        guard let destination = documentDirectory?.appendingPathComponent("\(fileName).\(fileType.fileExtension)") else {
            throw Error.invalidDestination
        }

        try data.write(to: destination)
    }
}

extension AppFileManager {

    enum FileType {
        case encryptedPlist

        var fileExtension: String {
            switch self {
            case .encryptedPlist:
                return "plist.enc"
            }
        }
    }

    enum Error: Swift.Error {
        case resourceIsMissing
        case invalidDestination
    }
}
