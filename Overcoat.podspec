Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '2.0'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is an AFNetworking extension that makes it extremely simple for developers to use Mantle model objects with a REST client.'
  s.homepage = 'https://github.com/gonzalezreal/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com' }
  s.social_media_url = 'https://twitter.com/gonzalezreal'
  s.source   = { :git => 'https://github.com/gonzalezreal/Overcoat.git', :branch => '2.0-development' }
  s.requires_arc = true
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  
  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking', '~> 2.0'
    ss.dependency 'Mantle', '~> 1.3'
    
    ss.public_header_files = 'Overcoat/*.h'
    ss.source_files = 'Overcoat/Overcoat.h', 'Overcoat/OVCResponse.{h,m}', 'Overcoat/NSError+OVCResponse.{h,m}', 'Overcoat/OVCURLMatcher.{h,m}',
                      'Overcoat/OVC{ModelResponse,SocialRequest}Serializer.{h,m}', 'Overcoat/OVCManagedStore.{h,m}', 'Overcoat/OVCHTTPRequestOperationManager.{h,m}',
                      'Overcoat/OVCManagedObjectSerializingContainer.h'
    ss.frameworks = 'Foundation', 'Accounts', 'Social', 'CoreData'
  end
    
  s.subspec 'NSURLSession' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.source_files = 'Overcoat/OVCHTTPSessionManager.{h,m}'
  end
  
  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'Overcoat/NSURLSession'
    ss.dependency 'PromiseKit'
    
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
