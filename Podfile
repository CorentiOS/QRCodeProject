# Uncomment the next line to define a global platform for your project
platform :ios, '13.3'

target 'QRScanner' do
  # Comment the next line if you don't want to use dynamic frameworks
  #use_frameworks!
  use_modular_headers!
  
  # Pods for QRScanner
  target 'QRScannerTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'QRScannerUITests' do
  inherit! :search_paths
end

# add the Firebase pod for Google Analytics
pod 'Firebase/Analytics'
pod 'Firebase/Storage'
pod 'Firebase/Database'
# add pods for any other desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
