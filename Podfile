source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

def shared_dependencies
  pod 'Overcoat', :path => '.'
  pod 'Overcoat+CoreData', :path => '.'
  pod 'Overcoat+PromiseKit', :path => '.'
  pod 'Overcoat+ReactiveCocoa', :path => '.'

  pod 'OHHTTPStubs'
end

target "OvercoatTests-OSX" do
  platform :osx, '10.10'
  shared_dependencies
end

target "OvercoatTests-iOS" do
  platform :ios, '8.0'
  shared_dependencies
end

target "OvercoatTests-tvOS" do
  platform :tvos, '9.0'
  shared_dependencies
end

post_install do |installer|
  rca_path = File.join __dir__, 'Pods', 'ReactiveCocoa'
  ['EXTRuntimeExtensions', 'EXTScope', 'metamacros'].each do |header|
    `grep -rl '"#{header}\\.h"' #{rca_path} | xargs sed -i '' 's/"#{header}\\.h"/<ReactiveCocoa\\/#{header}.h>/g'`
  end
end
