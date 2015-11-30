source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

def shared_dependencies
  pod 'Overcoat',
    :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
    :path => 'Overcoat.podspec',
    :inhibit_warnings => false
  pod 'AFNetworking', '3.0.0-beta.1'  # Specify for beta
  pod 'OHHTTPStubs'
end

target :osx, :exclusive => true do
  link_with 'OvercoatTests-OSX'
  platform :osx, '10.9'
  shared_dependencies
end

target :ios, :exclusive => true do
  link_with 'OvercoatTests-iOS'
  platform :ios, '8.0'
  shared_dependencies
end
