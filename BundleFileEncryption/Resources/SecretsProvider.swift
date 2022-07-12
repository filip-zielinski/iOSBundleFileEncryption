//
//  SecretsProvider.swift
//  BundleFileEncryption
//

import Keys

protocol SecretsProvider {

    /// Symmetric encryption key.
    var key: String { get }

    /// initialization vector.
    var iv: String { get }
}

final class AppSecretsProvider: SecretsProvider {

    private let keys: BundleFileEncryptionKeys

    init(keys: BundleFileEncryptionKeys) {
        self.keys = keys
    }

    var key: String {
        keys.appCryptor_key
    }

    /// initialization vector
    var iv: String {
        keys.myFile_iv
    }
}
