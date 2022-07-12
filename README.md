#  Bundle File Encryption

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

### runtime decryption (see: `AppCryptor`):

To decrypt file use `AppCryptor` object:

```swift
AppCryptor.decrypt(data:)
```

Internally `AppCryptor` is using cryptography functions provided in [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) library. 

```swift
AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(_:)
```

where `key` and `iv` are represented as array of bytes (`[UInt8]`). 

### Secrets

Key and IV (initialisation vector) are stored using `cocoapods-keys` key-value store. Secrets keys are defined in `Podfile` in `plugin 'cocoapods-keys'` section. Values are defined in the `.env` file located in project root. For sample, see `.env.sample` file. After modifying secrets in `.env` file, run `bundle exec pod install` to update `cocoapods-keys` store. Secrets can be accessed from code using `AppSecretsProvider`.

Use `openssl` CLI to generate key and IV:
```sh
openssl enc -nosalt -aes-256-cbc -k SECRET -P

// example output:
// key=84169A8D5B3289E8ECE00D7735081B53A25FFC874A38E2322AA4FDC9DFBC94A8
// iv =BCCEEC11BA4AAE7DCE7CC46498D150F7
```
where `SECRET` is a passphrase for generating key.

One key can be used to encrypt many items, but each item should be encrypted with different IV to prevent dictionary attacks. 







1. Add new file to project, do not add it to target. In this example it is property list (`plist`) file under `Resources/Important.plist`.
2. Make sure file is not added to any target.
3. 


cd Resources

openssl enc -e -aes-256-cbc -pass pass:kotki -in MyFile.plist -out MyFile.plist.encrypted

openssl enc -d -aes-256-cbc -pass pass:kotki -in MyFile.plist.encrypted -out MyFile.plist.decrypted

To use a plaintext password, replace -k symmetrickey with -pass stdin or -pass 'pass:PASSWORD' – 

### Key and IV generation:
openssl enc -nosalt -aes-256-cbc -k kittens
 -P
key=84169A8D5B3289E8ECE00D7735081B53A25FFC874A38E2322AA4FDC9DFBC94A8
iv =BCCEEC11BA4AAE7DCE7CC46498D150F7
