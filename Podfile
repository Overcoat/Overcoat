source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def shared_dependencies
  pod 'Overcoat',
    :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
    :path => 'Overcoat.podspec'
  pod 'OHHTTPStubs'

  # Version/Integration settings for implicity dependencies
  pod 'MTLManagedObjectAdapter', :inhibit_warnings => true
  pod 'ReactiveCocoa', '2.5'
end

target :osx, :exclusive => true do
  link_with 'OvercoatTests-OSX'
  platform :osx, '10.10'
  shared_dependencies
end

target :ios, :exclusive => true do
  link_with 'OvercoatTests-iOS'
  platform :ios, '8.0'
  shared_dependencies
end
