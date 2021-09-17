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
  pod 'Treetracker-Core', :git => 'https://github.com/Greenstand/treetracker-ios-core.git', :tag => 'v0.0.9'

end
