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
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseCrashlytics'
  pod 'Treetracker-Core', :git => 'https://github.com/Greenstand/treetracker-ios-core.git', :tag => 'v0.1.1'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
