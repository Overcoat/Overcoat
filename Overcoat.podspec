Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '2.1'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/gonzalezreal/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com' }
  s.social_media_url = 'https://twitter.com/gonzalezreal'
  s.source   = { :git => 'https://github.com/gonzalezreal/Overcoat.git', :tag => '2.1' }
  s.requires_arc = true
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  
  s.default_subspec = 'NSURLSession'
  
  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking', '~> 2.0'
    ss.dependency 'Mantle', '~> 1.3'
    
    ss.public_header_files = 'Overcoat/*.h'
    ss.source_files = 'Overcoat/Overcoat.h', 'Overcoat/OVCResponse.{h,m}', 'Overcoat/NSError+OVCResponse.{h,m}', 'Overcoat/OVCURLMatcher.{h,m}',
                      'Overcoat/OVC{ModelResponse,SocialRequest}Serializer.{h,m}', 'Overcoat/OVCManagedStore.{h,m}', 'Overcoat/OVCHTTPRequestOperationManager.{h,m}',
                      'Overcoat/OVCManagedObjectSerializingContainer.h', 'Overcoat/NSDictionary+Overcoat.{h,m}'
    ss.frameworks = 'Foundation', 'Accounts', 'Social', 'CoreData'
  end
    
  s.subspec 'NSURLSession' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.source_files = 'Overcoat/OVCHTTPSessionManager.{h,m}'
  end
  
  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'Overcoat/NSURLSession'
    ss.dependency 'PromiseKit', '0.9.10'
    
    ss.public_header_files = 'PromiseKit+Overcoat/*.h'
    ss.source_files = 'PromiseKit+Overcoat'
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'Overcoat/NSURLSession'
    ss.dependency 'ReactiveCocoa'
    
    ss.public_header_files = 'ReactiveCocoa+Overcoat/*.h'
    ss.source_files = 'ReactiveCocoa+Overcoat'
  end

end
