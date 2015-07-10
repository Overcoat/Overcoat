Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '2.2'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/gonzalezreal/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com' }
  s.social_media_url = 'https://twitter.com/gonzalezreal'
  s.source   = { :git => 'https://github.com/gonzalezreal/Overcoat.git', :tag => "#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.default_subspec = 'NSURLSession'

  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking', '~> 2.5'
    ss.dependency 'Mantle', '<= 3.0'

    ss.public_header_files = 'Overcoat/Core/*.h'
    ss.source_files = 'Overcoat/Core/*.{h,m}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'CoreData' do |ss|
    ss.dependency 'Overcoat/NSURLSession'
    ss.public_header_files = 'Overcoat/CoreData/*.h'
    ss.source_files = 'Overcoat/CoreData/*.{h,m}'
    ss.frameworks = 'CoreData'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => "OVERCOAT_SUPPORT_COREDATA=1"
    }
  end

  s.subspec 'Social' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.public_header_files = 'Overcoat/Social/*.h'
    ss.source_files = 'Overcoat/Social/*.{h,m}'
    ss.frameworks = 'Accounts', 'Social'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => "OVERCOAT_SUPPORT_SOCIAL=1"
    }
  end

  s.subspec 'NSURLSession' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.source_files = 'Overcoat/NSURLSession/OVCHTTPSessionManager.{h,m}'
  end

  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'Overcoat/NSURLSession'
    ss.dependency 'PromiseKit/Promise', '~>1.2'
    ss.public_header_files = 'PromiseKit+Overcoat/*.h'
    ss.source_files = 'PromiseKit+Overcoat'
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'Overcoat/NSURLSession'
    ss.dependency 'ReactiveCocoa', '~>2.4'

    ss.public_header_files = 'ReactiveCocoa+Overcoat/*.h'
    ss.source_files = 'ReactiveCocoa+Overcoat'
  end

end
