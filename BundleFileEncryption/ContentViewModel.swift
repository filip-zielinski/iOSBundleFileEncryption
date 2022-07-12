//
//  ContentViewModel.swift
//  BundleFileEncryption
//

import Foundation

final class ContentViewModel {

    private let plistDecrypter: PlistDecrypter
    private let plistEncrypter: PlistEncrypter
    private let fileManager: AppFileManager

    private static let bundleFileName = "MyFile"
    private static let userFileName = "UserCustomFile"

    init(plistDecrypter: PlistDecrypter, plistEncrypter: PlistEncrypter, fileManager: AppFileManager) {
        self.plistDecrypter = plistDecrypter
        self.plistEncrypter = plistEncrypter
        self.fileManager = fileManager
    }

    func readBundleFileMessage() throws -> String {
        let file = try fileManager.readFromBundle(fileName: Self.bundleFileName, fileType: .encryptedPlist)
        let decrypted: MyFileModel = try plistDecrypter.decryptAndDecode(file)
        let message = decrypted.message

        return message
    }

    func readUserMessage() throws -> String {
        let file = try fileManager.readFromDocuments(fileName: Self.userFileName, fileType: .encryptedPlist)
        let decrypted: MyFileModel = try plistDecrypter.decryptAndDecode(file)
        let message = decrypted.message

        return message
    }

    func addUserMessage(_ message: String) throws {
        let model = MyFileModel(message: message)

        let data = try plistEncrypter.encodeAndEncrypt(model)

        try fileManager.writeToDocuments(data, fileName: Self.userFileName, fileType: .encryptedPlist)
    }
}

