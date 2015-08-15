Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '3.0.0'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/overcoat/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com', 'sodastsai' => 'sodas@icloud.com' }
  s.source   = { :git => 'https://github.com/overcoat/Overcoat.git', :tag => "#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking', '~> 2.5'
    ss.dependency 'Mantle', '<= 3.0'

    ss.public_header_files = 'sources/Core/*.h'
    ss.private_header_files = 'sources/Core/*_Internal.h'
    ss.source_files = 'sources/Core/*.{h,m}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'CoreData' do |ss|
    ss.subspec 'Mantle2' do |sss|
      sss.dependency 'Overcoat/Core'
      sss.public_header_files = 'sources/CoreData/*.h'
      sss.private_header_files = 'sources/CoreData/*_Internal.h'
      sss.source_files = 'sources/CoreData/*.{h,m}'
      sss.frameworks = 'CoreData'
      sss.user_target_xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_COREDATA=1',  # Used for shortcuts in umbrella header
      }
      sss.dependency 'Mantle', '~> 2'
      sss.dependency 'MTLManagedObjectAdapter'
      sss.dependency 'MTLManagedObjectAdapter/extobjc'
    end

    ss.subspec 'Mantle1' do |sss|
      sss.dependency 'Overcoat/Core'
      sss.public_header_files = 'sources/CoreData/*.h'
      sss.private_header_files = 'sources/CoreData/*_Internal.h'
      sss.source_files = 'sources/CoreData/*.{h,m}'
      sss.frameworks = 'CoreData'
      sss.user_target_xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_COREDATA=1',  # Used for shortcuts in umbrella header
      }
      sss.dependency 'Mantle', '~> 1'
    end

    ss.default_subspec = 'Mantle2'
  end

  s.subspec 'Social' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.public_header_files = 'sources/Social/*.h'
    ss.source_files = 'sources/Social/*.{h,m}'
    ss.frameworks = 'Accounts', 'Social'
    ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_SOCIAL=1',  # Used for shortcuts in umbrella header
    }
  end

  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'PromiseKit/Promise', '~>1.2'
    ss.public_header_files = 'sources/PromiseKit/*.h'
    ss.source_files = 'sources/PromiseKit/*.{h,m}'
    ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_PROMISE_KIT=1',  # Used for shortcuts in umbrella header
    }
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'ReactiveCocoa', '~>2.4'
    ss.public_header_files = 'sources/ReactiveCocoa/*.h'
    ss.source_files = 'sources/ReactiveCocoa/*.{h,m}'
    ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_REACTIVE_COCOA=1',  # Used for shortcuts in umbrella header
    }
  end

end
