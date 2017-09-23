# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EcocoinWallet' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EcocoinWallet
  pod 'IQKeyboardManager', '4.0.9'
  pod 'Alamofire', '4.4.0'
  pod 'AlamofireObjectMapper', '4.1.0'
  pod 'AlamofireImage', '3.2.0'
  pod 'PKHUD', '~> 4.0'
  pod 'ObjectMapper', '2.2.6'

#  pod 'EFQRCode'
#  pod 'QRCodeReader'

  target 'EcocoinWalletTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EcocoinWalletUITests' do
    inherit! :search_paths
    # Pods for testing
  end

 post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end
  end

end
