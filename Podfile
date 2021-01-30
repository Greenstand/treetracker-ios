platform :ios, '11.0'

plugin 'cocoapods-keys', {
  :project => "TreeTracker",
  :keys => [
    "AWSIdentityPoolId_Dev",
    "AWSIdentityPoolId_Test",
    "AWSIdentityPoolId_Prod",
  ]
}

target 'TreeTracker' do
  use_frameworks!
  pod 'SwiftLint'
  pod 'SwiftGen', '~> 6.0'
  pod 'AWSS3', '2.16.0'
end
