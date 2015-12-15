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
    ss.dependency 'AFNetworking/Serialization', '~> 3.0'
    ss.dependency 'AFNetworking/NSURLSession', '~> 3.0'

    ss.source_files = 'Sources/Core/*.{h,m}'
    ss.private_header_files = 'Sources/Core/*_Internal.h'
    ss.header_dir = 'Overcoat'
  end

  s.subspec 'CoreData' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'MTLManagedObjectAdapter', '> 1.0'
    ss.frameworks = 'CoreData'

    ss.source_files = 'Sources/CoreData/*.{h,m}'
    ss.private_header_files = 'Sources/CoreData/*_Internal.h'
    ss.header_dir = 'OvercoatCoreData'
  end

  s.subspec 'Social' do |ss|
    ss.dependency 'AFNetworking/Serialization'
    ss.frameworks = 'Accounts', 'Social'

    ss.public_header_files = 'Sources/Social/*.h'
    ss.source_files = 'Sources/Social/*.{h,m}'
    ss.header_dir = 'OvercoatSocial'
  end

  s.subspec 'PromiseKit' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.osx.deployment_target = '10.9'

    ss.dependency 'PromiseKit/CorePromise', '> 2'  # Swift 2.0 support comes after PromiseKit 3.0

    ss.source_files = 'Sources/PromiseKit/*.{h,m}'
    ss.header_dir = 'OvercoatPromiseKit'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC',  # Objective-C Categories
    }

  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'ReactiveCocoa/Core', '> 2.4'

    ss.source_files = 'Sources/ReactiveCocoa/*.{h,m}'
    ss.header_dir = 'OvercoatReactiveCocoa'

    ss.pod_target_xcconfig = ss.user_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC',  # Objective-C Categories
    }
  end
end
