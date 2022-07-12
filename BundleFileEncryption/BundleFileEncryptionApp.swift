//
//  BundleFileEncryptionApp.swift
//  BundleFileEncryption
//

import SwiftUI
import Keys

@main
struct BundleFileEncryptionApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(
                plistDecryptor: EncryptedPlistDecoder(
                    decryptor: AppCryptor(
                        secretsProvider: AppSecretsProvider(
                            keys: BundleFileEncryptionKeys()
                        )
                    )
                )
            )
        }
    }
}
