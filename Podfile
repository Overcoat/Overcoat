source 'https://github.com/CocoaPods/Specs.git'

# Workspace and Project file
workspace 'OvercoatApp'
xcodeproj 'OvercoatApp/OvercoatApp.xcodeproj'

# Environments and Variables
overcoat_podspec_path = 'Overcoat.podspec'

os_type = ENV['OS_TYPE'] || 'iOS'
platform_type = os_type.downcase.to_sym

mantle_version = ENV['MANTLE'] || '2.0'
if mantle_version == '1.5'
  if os_type == 'iOS'
    os_version = '6.0'
  else
    os_version = '10.8'
  end
else
  if os_type == 'iOS'
    os_version = '8.0'
  else
    os_version = '10.9'
  end
end

# Targets
target "Overcoat-#{os_type}-Tests" do
  platform platform_type, os_version
  pod 'OHHTTPStubs'
  pod 'Overcoat', :path => overcoat_podspec_path
  pod 'Mantle', "~> #{mantle_version}"
end

target "Overcoat-#{os_type}-RC-Tests" do
  platform platform_type, os_version
  pod 'OHHTTPStubs'
  pod 'Overcoat/ReactiveCocoa', :path => overcoat_podspec_path
  pod 'Mantle', "~> #{mantle_version}"
end

target "Overcoat-#{os_type}-PK-Tests" do
  platform platform_type, os_version
  pod 'OHHTTPStubs'
  pod 'Overcoat/PromiseKit', :path => overcoat_podspec_path
  pod 'Mantle', "~> #{mantle_version}"
end

target "Overcoat-#{os_type}-CoreData-Tests" do
  platform platform_type, os_version
  pod 'OHHTTPStubs'
  pod 'Overcoat/CoreData', :path => overcoat_podspec_path
  pod 'Mantle', "~> #{mantle_version}"

  if mantle_version == '2.0'
    pod 'MTLManagedObjectAdapter'
  end
end
