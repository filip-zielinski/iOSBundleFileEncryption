//
//  AppCrypter.swift
//  BundleFileEncryption
//

import Foundation
import CryptoSwift

protocol Decrypter {

    func decrypt(data: Data) throws -> Data
}

protocol Encrypter {

    func encrypt(data: Data) throws -> Data
}

final class AppCrypter {

    let secretsProvider: SecretsProvider

    init(secretsProvider: SecretsProvider) {
        self.secretsProvider = secretsProvider
    }
}

extension AppCrypter: Decrypter {

    func decrypt(data: Data) throws -> Data {
        let key = secretsProvider.key
        let iv = secretsProvider.iv

        let keyBytes = [UInt8](hex: key)
        let ivBytes = [UInt8](hex: iv)

        return try decrypt(data: data, key: keyBytes, iv: ivBytes)
    }
}

extension AppCrypter: Encrypter {

    func encrypt(data: Data) throws -> Data {
        let key = secretsProvider.key
        let iv = secretsProvider.iv

        let keyBytes = [UInt8](hex: key)
        let ivBytes = [UInt8](hex: iv)

        return try encrypt(data: data, key: keyBytes, iv: ivBytes)
    }
}

private extension AppCrypter {

    func decrypt(data: Data, key: Array<UInt8>, iv: Array<UInt8>) throws -> Data {
        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

        let decryptedBytes = try aes.decrypt(data.bytes)
        let decryptedData = Data(decryptedBytes)

        return decryptedData
    }

    func encrypt(data: Data, key: Array<UInt8>, iv: Array<UInt8>) throws -> Data {
        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

        let encryptedBytes = try aes.encrypt(data.bytes)
        let encryptedData = Data(encryptedBytes)

        return encryptedData
    }
}
