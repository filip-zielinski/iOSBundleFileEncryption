//
//  ContentView.swift
//  BundleFileEncryption
//

import SwiftUI

struct ContentView: View {

    @State var bundleFileViewStatusText: String = "Decrypting..."
    @State var bundleFileViewMessageText: String = ""

    @State var userFileViewStatusText: String = "Create a message in encrypted file"
    @State var userFileViewMessageText: String = ""

    let viewModel: ContentViewModel

    var body: some View {
        VStack {
            bundleFileView
            Spacer()
            userFileView
                .padding()
                .background(Color(white: 0.96))
        }
        .onAppear {
            readBundleFileMessage()
            readUserMessage()
        }
    }
}

private extension ContentView {

    var bundleFileView: some View {
        VStack {
            Text("App Bundle File")
                .font(.title)
                .padding()

            Text(bundleFileViewStatusText)
                .foregroundColor(bundleFileViewMessageText.isEmpty ? .red : .green)

            Text(bundleFileViewMessageText)
                .padding()
        }
    }

    var userFileView: some View {
        VStack {
            Text("User file")
                .font(.title)

            Text(userFileViewStatusText)
                .padding()

            TextField("", text: $userFileViewMessageText)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
                addUserMessage(userFileViewMessageText)
                readUserMessage()
            }) {
                Text("Add your message")
            }
            .padding()

            Button(action: readUserMessage) {
                Text("Load message")
            }
        }
    }

    func readBundleFileMessage() {
        do {
            let message = try viewModel.readBundleFileMessage()
            bundleFileViewMessageText = message
            bundleFileViewStatusText = "File successfully decrypted. Secret message is:"
        } catch {
            bundleFileViewStatusText = error.localizedDescription
        }
    }

    func readUserMessage() {
        do {
            let message = try viewModel.readUserMessage()
            userFileViewStatusText = "Current message is: \(message)"
            userFileViewMessageText = message
        } catch {
            userFileViewStatusText = "Could not load User file"
        }
    }

    func addUserMessage(_ message: String) {
        do {
            try viewModel.addUserMessage(message)
        } catch {
            userFileViewStatusText = "Could not write message because of error: \(error)"
        }
    }

}
import Keys

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let appCrypter = AppCrypter(
            secretsProvider: AppSecretsProvider(
                keys: BundleFileEncryptionKeys()
            )
        )

        let viewModel = ContentViewModel(
            plistDecrypter: PlistDecrypter(decrypter: appCrypter),
            plistEncrypter: PlistEncrypter(encrypter: appCrypter),
            fileManager: AppFileManager()
        )

        return ContentView(viewModel: viewModel)
    }
}
