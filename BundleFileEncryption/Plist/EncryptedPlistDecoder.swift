//
//  EncryptedPlistDecoder.swift
//  BundleFileEncryption
//

import Foundation

final class EncryptedPlistDecoder {

    enum Error: Swift.Error {
        case resourceIsMissing
        case failedToDecrypt
    }

    let decryptor: Decryptor

    init(decryptor: Decryptor) {
        self.decryptor = decryptor
    }

    func decryptAndDecode<T: Decodable>(fileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "encplist") else {
            throw Error.resourceIsMissing
        }

        let data = try Data(contentsOf: url)
        guard let decrypted = try decryptor.decrypt(data: data) else {
            throw Error.failedToDecrypt
        }
        let model = try PropertyListDecoder().decode(T.self, from: decrypted)
        return model
    }
}

