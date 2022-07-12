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

    /// Symmetric encryption key.
    var key: String {
        keys.appCrypter_key
    }

    /// Initialization vector.
    var iv: String {
        keys.myFile_iv
    }
}
