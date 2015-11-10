Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '4.0.0-beta.1'
  s.cocoapods_version = '>= 0.39'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/overcoat/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com', 'sodastsai' => 'sodas@icloud.com' }
  s.source   = { :git => 'https://github.com/overcoat/Overcoat.git', :tag => "#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.dependency 'Mantle', '~> 2.0'
    ss.dependency 'AFNetworking/Serialization', '3.0.0-beta.1'
    ss.dependency 'AFNetworking/NSURLSession', '3.0.0-beta.1'

    ss.source_files = 'sources/Core/*.{h,m}'
    ss.private_header_files = 'sources/Core/*_Internal.h'
  end

  s.subspec 'CoreData' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'MTLManagedObjectAdapter', '> 1.0'
    ss.frameworks = 'CoreData'

    ss.source_files = 'sources/CoreData/*.{h,m}'
    ss.private_header_files = 'sources/CoreData/*_Internal.h'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_COREDATA=1',  # Used for shortcuts in umbrella header
    }
  end

  s.subspec 'Social' do |ss|
    ss.dependency 'AFNetworking/Serialization'
    ss.frameworks = 'Accounts', 'Social'

    ss.public_header_files = 'sources/Social/*.h'
    ss.source_files = 'sources/Social/*.{h,m}'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_SOCIAL=1',  # Used for shortcuts in umbrella header
    }
  end

  s.subspec 'PromiseKit' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.osx.deployment_target = '10.9'

    ss.dependency 'PromiseKit/CorePromise', '> 2'  # Swift 2.0 support comes after PromiseKit 3.0

    ss.source_files = 'sources/PromiseKit/*.{h,m}'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_PROMISE_KIT=1',  # Used for shortcuts in umbrella header
    }
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'ReactiveCocoa', '~> 2.4'

    ss.source_files = 'sources/ReactiveCocoa/*.{h,m}'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_REACTIVE_COCOA=1',  # Used for shortcuts in umbrella header
    }
  end
end
