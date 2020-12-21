use_modular_headers!
platform :ios, '10.0'

project 'Example/HelloSDK.xcodeproj'

target 'HelloSDK' do  
  pod 'MapGL', :path => './'
  pod 'SwiftLint', '~> 0.39.2'
  target 'HelloSDKTests' do
    pod 'MapGL', :path => './', :testspecs => ['Tests']
  end
end
