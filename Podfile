require 'xcodeproj'

source 'https://github.com/CocoaPods/Specs.git'

workspace 'Overcoat'
xcodeproj 'Overcoat/Overcoat.xcodeproj'
link_with 'Overcoat-iOS', 'Overcoat-OSX'
use_frameworks!
inhibit_all_warnings!

os_type = ENV['OS_TYPE'] || 'iOS'
platform_type = os_type.downcase.to_sym
os_version = os_type == 'iOS' ? '8.0' : '10.9'
platform platform_type, os_version

pod 'Overcoat',
  :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
  :path => 'Overcoat.podspec',
  :inhibit_warnings => true

target :test do
  # Link with Tests targets
  targets = Array.new(Xcodeproj::Project.open('Overcoat/Overcoat.xcodeproj').root_object.targets)
  link_with targets.keep_if { |target|
    target.name.end_with?('Tests')
  }.map { |target|
    target.name
  }

  pod 'OHHTTPStubs', :inhibit_warnings => true
end
