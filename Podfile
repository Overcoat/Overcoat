source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def main_dependencies
  pod 'Overcoat',
    :subspecs => ['ReactiveCocoa', 'PromiseKit', 'CoreData'],
    :path => 'Overcoat.podspec'

  # Version/Integration settings for implicity dependencies
  pod 'MTLManagedObjectAdapter', :inhibit_warnings => true
  pod 'ReactiveCocoa', '4.0.0-RC.1'
end

def test_dependencies
  pod 'OHHTTPStubs'
end

target :osx, :exclusive => true do
  link_with 'OvercoatApp-OSX'
  platform :osx, '10.10'
  main_dependencies

  target :test do
    link_with 'OvercoatTests-OSX'
    test_dependencies
  end
end

target :ios, :exclusive => true do
  link_with 'OvercoatApp-iOS'
  platform :ios, '8.0'
  main_dependencies

  target :test do
    link_with 'OvercoatTests-iOS'
    test_dependencies
  end
end

post_install do |installer|
  rca_path = File.join __dir__, 'Pods', 'ReactiveCocoa'
  ['EXTRuntimeExtensions', 'EXTScope'].each do |header|
    `grep -rl '"#{header}\\.h"' #{rca_path} | xargs sed -i '' 's/"#{header}\\.h"/<ReactiveCocoa\\/#{header}.h>/g'`
  end
end
