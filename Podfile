source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'ViperTaskManager' do
pod 'Swinject'
pod 'SwinjectStoryboard'
pod 'Alamofire', '~> 4.7.1'
pod 'Realm', '~> 3.11.1'
pod 'RealmSwift', '~> 3.11.1'
pod "RBQFetchedResultsController", :git => 'https://github.com/DeveloperLY/RBQFetchedResultsController.git'
pod 'SwiftFetchedResultsController', :git => 'https://github.com/DeveloperLY/RBQFetchedResultsController.git'
pod 'SwiftyJSON', '~> 4.2.0'

# Will used soon
pod 'SnapKit', '~> 4.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "4.2"
    end
  end
end
