require 'xcodeproj'

source 'https://github.com/CocoaPods/Specs.git'

# Workspace and Project file -------------------------------------------------------------------------------------------
workspace 'Overcoat'
xcodeproj 'Overcoat/Overcoat.xcodeproj'
link_with 'Overcoat-iOS', 'Overcoat-OSX'

# Environments and Variables -------------------------------------------------------------------------------------------
overcoat_podspec_path = 'Overcoat.podspec'

os_type = ENV['OS_TYPE'] || 'iOS'
platform_type = os_type.downcase.to_sym

overcoat_subspecs = ['ReactiveCocoa', 'PromiseKit']
mantle_version = ENV['MANTLE'] || '2.0'
if mantle_version == '1.5'
  overcoat_subspecs << 'CoreData/Mantle1'
  if os_type == 'iOS'
    os_version = '7.0'
  else
    os_version = '10.9'
  end
else
  overcoat_subspecs << 'CoreData'
  if os_type == 'iOS'
    os_version = '8.0'
  else
    os_version = '10.9'
  end
end

# Dependencies ---------------------------------------------------------------------------------------------------------
platform platform_type, os_version

pod 'AFNetworking', :inhibit_warnings => true
pod 'Mantle', "~> #{mantle_version}", :inhibit_warnings => true
if mantle_version == '2.0'
  pod 'MTLManagedObjectAdapter', :inhibit_warnings => true
end
pod 'Overcoat', :subspecs => overcoat_subspecs, :path => overcoat_podspec_path

# Test target ---------------------------------------------------------------------------------------------------------
target :test, :exclusive => true do
  # Link with Tests targets
  link_with Xcodeproj::Project.open('Overcoat/Overcoat.xcodeproj').root_object.targets.keep_if { |target|
    target.name.end_with?('Tests')
  }.map { |target|
    target.name
  }

  pod 'OHHTTPStubs', :inhibit_warnings => true
end
