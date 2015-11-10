require 'xcodeproj'

source 'https://github.com/CocoaPods/Specs.git'

workspace 'Overcoat'
xcodeproj 'Overcoat/Overcoat.xcodeproj'
use_frameworks!
inhibit_all_warnings!

def test_targets(platform)
  Xcodeproj::Project.open('Overcoat/Overcoat.xcodeproj').root_object.targets.keep_if { |target|
    target.name.start_with?("Overcoat-#{platform}") && target.name.end_with?('Tests')
  }.map { |target| target.name }
end

def main_dependency
    pod 'Overcoat',
      :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
      :path => 'Overcoat.podspec',
      :inhibit_warnings => true
    pod 'AFNetworking', '3.0.0-beta.1'
end

def test_dependency
    pod 'OHHTTPStubs'
end

target :ios, :exclusive => true do
  link_with 'Overcoat-iOS'
  platform :ios, '8.0'
  main_dependency

  target :tests do
    link_with test_targets('iOS')
    test_dependency
  end
end

target :osx, :exclusive => true do
  link_with 'Overcoat-OSX'
  platform :osx, '10.9'
  main_dependency

  target :tests do
    link_with test_targets('OSX')
    test_dependency
  end
end
