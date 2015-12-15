source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def shared_dependencies
  pod 'Overcoat',
    :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
    :path => 'Overcoat.podspec'
  pod 'OHHTTPStubs'

  # Version/Integration settings for implicity dependencies
  pod 'MTLManagedObjectAdapter', :inhibit_warnings => true
  pod 'ReactiveCocoa', '4.0.0-RC.1'
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

post_install do |installer|
  pods_rca_path = File.join __dir__, 'Pods', 'ReactiveCocoa'
  ['EXTRuntimeExtensions', 'EXTScope'].each do |header|
    `grep -rl '"#{header}\\.h"' #{pods_rca_path} | xargs sed -i '' 's/"#{header}\\.h"/<ReactiveCocoa\\/#{header}.h>/g'`
  end
end
