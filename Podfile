source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

def shared_dependencies
  pod 'Overcoat', :path => '.'
  pod 'Overcoat+CoreData', :path => '.'
  pod 'Overcoat+PromiseKit', :path => '.'

  pod 'OHHTTPStubs'
end

def extra_dependencies
  pod 'Overcoat+ReactiveCocoa', :path => '.'  # doesn't support tvOS
end

target "OvercoatTests-OSX" do
  platform :osx, '10.10'
  shared_dependencies
  extra_dependencies
end

target "OvercoatTests-iOS" do
  platform :ios, '8.0'
  shared_dependencies
  extra_dependencies
end

target "OvercoatTests-tvOS" do
  platform :tvos, '9.0'
  shared_dependencies
end

post_install do |installer|
  rca_path = File.join __dir__, 'Pods', 'ReactiveObjC'
  ['EXTRuntimeExtensions', 'EXTScope', 'metamacros'].each do |header|
    `grep -rl '"#{header}\\.h"' #{rca_path} | xargs sed -i '' 's/"#{header}\\.h"/<ReactiveObjC\\/#{header}.h>/g'`
  end

  installer.pods_project.targets.each do |target|
    if target.platform_name != :osx then
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'YES'
      end
    end
  end
end
