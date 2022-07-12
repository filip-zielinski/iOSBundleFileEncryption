//
//  ContentView.swift
//  BundleFileEncryption
//

import SwiftUI

struct ContentView: View {

    @State var bodyText: String = "-"
    let plistDecryptor: EncryptedPlistDecoder

    var body: some View {
        Text(bodyText)
            .padding()
            .onAppear {
                bodyText = makeBodyText()
            }
    }
}

private extension ContentView {

    func makeBodyText() -> String {
        do {
            let model: MyFileModel = try plistDecryptor.decryptAndDecode(fileName: "MyFile")
            let message = model.message

            return "File successfully decrypted.\nSecret message is:\n\n\"\(message)\""
        } catch {
            return error.localizedDescription
        }
    }
}

import Keys

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
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
