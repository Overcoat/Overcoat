Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '2.2'
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

    ss.public_header_files = 'Overcoat/Core/*.h'
    ss.private_header_files = 'Overcoat/Core/*_Internal.h'
    ss.source_files = 'Overcoat/Core/*.{h,m}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'CoreData' do |ss|
    ss.subspec 'Core' do |sss|
      sss.dependency 'Overcoat/Core'
      sss.public_header_files = 'Overcoat/CoreData/*.h'
      sss.private_header_files = 'Overcoat/CoreData/*_Internal.h'
      sss.source_files = 'Overcoat/CoreData/*.{h,m}'
      sss.frameworks = 'CoreData'
      sss.xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_COREDATA=1'
      }
    end

    ss.subspec 'Mantle2' do |sss|
      sss.dependency 'Overcoat/CoreData/Core'
      sss.dependency 'MTLManagedObjectAdapter'
    end

    ss.subspec 'Mantle1' do |sss|
      sss.dependency 'Overcoat/CoreData/Core'
    end

    ss.default_subspec = 'Mantle2'
  end

  s.subspec 'Social' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.public_header_files = 'Overcoat/Social/*.h'
    ss.source_files = 'Overcoat/Social/*.{h,m}'
    ss.frameworks = 'Accounts', 'Social'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_SOCIAL=1'
    }
  end

  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'PromiseKit/Promise', '~>1.2'
    ss.public_header_files = 'PromiseKit+Overcoat/*.h'
    ss.source_files = 'PromiseKit+Overcoat'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_PROMISE_KIT=1'
    }
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'ReactiveCocoa', '~>2.4'
    ss.public_header_files = 'ReactiveCocoa+Overcoat/*.h'
    ss.source_files = 'ReactiveCocoa+Overcoat'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_REACTIVE_COCOA=1'
    }
  end

end
