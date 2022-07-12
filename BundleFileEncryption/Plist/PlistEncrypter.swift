//
//  PlistEncrypter.swift
//  BundleFileEncryption
//

import Foundation

final class PlistEncrypter {

    let encrypter: Encrypter
    let propertyListEncoder: PropertyListEncoder

    init(encrypter: Encrypter, propertyListEncoder: PropertyListEncoder = PropertyListEncoder()) {
        self.encrypter = encrypter
        self.propertyListEncoder = propertyListEncoder
    }

    func encodeAndEncrypt<T: Encodable>(_ model: T) throws -> Data {
        let data = try propertyListEncoder.encode(model)
        let encrypted = try encrypter.encrypt(data: data)
        return encrypted
    }
}
