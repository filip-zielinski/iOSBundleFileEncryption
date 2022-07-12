//
//  BundleFileEncryptionApp.swift
//  BundleFileEncryption
//

import SwiftUI
import Keys

@main
struct BundleFileEncryptionApp: App {

    let viewModel: ContentViewModel

    init() {
        let appCrypter = AppCrypter(
            secretsProvider: AppSecretsProvider(
                keys: BundleFileEncryptionKeys()
            )
        )

        viewModel = ContentViewModel(
            plistDecrypter: PlistDecrypter(decrypter: appCrypter),
            plistEncrypter: PlistEncrypter(encrypter: appCrypter),
            fileManager: AppFileManager()
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
