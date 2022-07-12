#  iOS App File Encryption PoC

## Prove of Concept

This project demonstrates how to add an encrypted file to iOS app bundle and read it in runtime. 

## Process overview

App uses symmetric encryption with key stored using cocoapods-keys. File is encrypted during build time, and later decrypted in runtime. Encryption and decryption must use the same cryptographic alghorithm. This example uses AES with 256 bit key length. Key and IV (initialisation vector) are stored in cocoapods-keys key-value store. 

### Build time encryption

File is encrypted using `openssl` cryptography toolkit. See `Encrypt MyFile` build phase script.

```sh
openssl enc -e -aes-256-cbc -K KEY -iv IV -in INPUT_FILE -out OUTPUTFILE.enc
```

where `KEY` and `IV` are represented as strings comprised of hex digits.

### runtime decryption:

`AppCrypter` is used to decrypt file:

```swift
AppCrypter.decrypt(data:)
```

Internally `AppCrypter` is using cryptography functions provided in [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) library. 

```swift
AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(_:)
```

where `key` and `iv` are represented as array of bytes (`[UInt8]`). 

### Secrets

Key and IV (initialisation vector) are stored using `cocoapods-keys` key-value store. Keys are defined in `Podfile` -> `plugin 'cocoapods-keys'` section. Values are defined in the `.env` file located in project root. For sample, see `.env.sample` file. After modifying secrets in `.env` file, run `bundle exec pod install` to update `cocoapods-keys` store. You might also need to update key name in `Encrypt MyFile` build phase script. Secrets can be accessed from code using `AppSecretsProvider`.

Use `openssl` CLI to generate key and IV:

```sh
openssl enc -aes-256-cbc -k SECRET -P

// example output:
// salt=1C048D9861BFBF16
// key=541DCC7160BBE5C00E3283A9B6C82C850A8CCCFC2F446CE02D940A83AA4B8A2C
// iv =4F6088968E902A5F3841E3E4D528B5EF
```

`SECRET` is a passphrase used to generate the key.
`salt` is randomly generated each time.

One key can be used to encrypt many items, but each item should be encrypted with different IV to prevent dictionary attacks. 

## Project setup

1. Generate key and IV (see "Secrets" section) and put them in the `.env` file.
2. run `bundle install`
3. run `bundle exec pod install`
4. open `BundleFileEncryption.xcworkspace` in Xcode.

## How to implement file encryption in Your project

1. Add CryptoSwift dependency to your project. For alternatives, see "Dependencies" section of this document.
2. Add a file you want to encrypt to the project, but do not add it to target. In this example it is property list (`plist`) file located under `Resources/MyFile.plist`.
3. Make sure file is not added to any target.
4. Copy `Encrypt MyFile` build phase script and adjust its configuration (`input` and `output`) to match your file and project.
5. Setup secrets: add key names to `Podfile` and values to `.env` file - just like in this project. Run `bundle exec pod install`. Make sure that `.env` is not tracked by GIT.
6. Add or modify existing `SecretsProvider`-like object so it can provide the key and the IV. 
7. Copy `AppCrypter` to your project, adjusting its secret providing logic to match your project.
8. Use `AppCrypter` to decrypt the encrypted file, like in this project's `PlistDecrypter`:

`try decrypter.decrypt(data: data)`

## Dependencies

### iOS app dependencies:
- [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift): can be replaced with [Swift Crypto](https://github.com/apple/swift-crypto) or Common Crypto.

### app development and deployment:
- [OpenSSL](https://www.openssl.org)
