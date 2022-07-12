//
//  PlistDecrypter.swift
//  BundleFileEncryption
//

import Foundation

final class PlistDecrypter {

    let decrypter: Decrypter
    let propertyListDecoder: PropertyListDecoder

    init(decrypter: Decrypter, propertyListDecoder: PropertyListDecoder = PropertyListDecoder()) {
        self.decrypter = decrypter
        self.propertyListDecoder = propertyListDecoder
    }

    func decryptAndDecode<T: Decodable>(_ data: Data) throws -> T {
        let decrypted = try decrypter.decrypt(data: data)
        let model = try propertyListDecoder.decode(T.self, from: decrypted)

        return model
    }
}
