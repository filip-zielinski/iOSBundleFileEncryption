source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.1'


target 'BundleFileEncryption' do
  use_frameworks!
  pod 'CryptoSwift', '~> 1.5.1'

end

plugin 'cocoapods-keys', {
  :project => "BundleFileEncryption",
  :keys => [
    "AppCrypter_key",
    "MyFile_iv",
  ]}
