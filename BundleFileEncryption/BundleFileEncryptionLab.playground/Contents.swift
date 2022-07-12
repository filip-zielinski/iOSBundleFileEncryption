import CryptoSwift

func generateKey(passphrase: String, saltphrase: String) throws -> Array<UInt8> {
    try PKCS5.PBKDF2(
        password: Array(passphrase.utf8),
        salt: Array(saltphrase.utf8),
        iterations: 4096,
        keyLength: 32, // AES-256
        variant: .sha2(.sha256)
    )
    .calculate()
}

func generateInitializationVector() -> Array<UInt8> {
    AES.randomIV(AES.blockSize)
}

let key = try generateKey(passphrase: "kittens", saltphrase: "meow")
let iv = generateInitializationVector()

let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

/* Encrypt Data */
let inputData = "-Test-".data(using: .utf8)!
let encryptedBytes = try aes.encrypt(inputData.bytes)
let encryptedData = Data(encryptedBytes)

/* Decrypt Data */
let decryptedBytes = try aes.decrypt(encryptedData.bytes)
let decryptedData = Data(decryptedBytes)

print(String(data: decryptedData, encoding: .utf8) ?? "-")
