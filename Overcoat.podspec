module Overcoat
  def Overcoat.coredata_subspec(s)  # TODO: Move back to CoreData section when dropping off Mantle 1.x support
    s.dependency 'Overcoat/Core'
    s.public_header_files = 'sources/CoreData/*.h'
    s.private_header_files = 'sources/CoreData/*_Internal.h'
    s.source_files = 'sources/CoreData/*.{h,m}'
    s.exclude_files = 'sources/CoreData/OVCManagedHTTP{RequestOperation,Session}Manager.{h,m}'
    s.frameworks = 'CoreData'
    s.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_COREDATA=1',  # Used for shortcuts in umbrella header
    }

    s.default_subspec = 'NSURLConnection', 'NSURLSession'
    s.subspec 'NSURLConnection' do |ss|
      ss.dependency 'Overcoat/Core/NSURLConnection'
      ss.source_files = 'sources/CoreData/OVCManagedHTTPRequestOperationManager.{h,m}'

      # AFNetworking/NSURLConnection doesn't support watchOS
      ss.platform = :ios
      ss.platform = :osx
    end
    s.subspec 'NSURLSession' do |ss|
      ss.dependency 'Overcoat/Core/NSURLSession'
      ss.source_files = 'sources/CoreData/OVCManagedHTTPSessionManager.{h,m}'
    end
  end
end

Pod::Spec.new do |s|
  s.name     = 'Overcoat'
  s.version  = '3.1.0'
  s.cocoapods_version = '>= 0.38'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/overcoat/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com', 'sodastsai' => 'sodas@icloud.com' }
  s.source   = { :git => 'https://github.com/overcoat/Overcoat.git', :tag => "#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking/Serialization', '~> 2.5'
    ss.dependency 'Mantle', '<= 3.0'

    ss.public_header_files = 'sources/Core/*.h'
    ss.private_header_files = 'sources/Core/*_Internal.h'
    ss.source_files = 'sources/Core/*.{h,m}'
    ss.exclude_files = 'sources/Core/OVCHTTP{RequestOperation,Session}Manager.{h,m}'
    ss.frameworks = 'Foundation'

    ss.default_subspec = 'NSURLConnection', 'NSURLSession'
    ss.subspec 'NSURLConnection' do |sss|
      sss.dependency 'AFNetworking/NSURLConnection', '~> 2.5'
      sss.source_files = 'sources/Core/OVCHTTPRequestOperationManager.{h,m}'
      # AFNetworking/NSURLConnection doesn't support watchOS
      sss.platform = :ios
      sss.platform = :osx
    end
    ss.subspec 'NSURLSession' do |sss|
      sss.dependency 'AFNetworking/NSURLSession', '~> 2.5'
      sss.source_files = 'sources/Core/OVCHTTPSessionManager.{h,m}'
    end
  end

  s.subspec 'CoreData' do |ss|
    ss.subspec 'Mantle2' do |sss|
      Overcoat::coredata_subspec sss
      sss.dependency 'Mantle', '~> 2'
      sss.dependency 'MTLManagedObjectAdapter', '> 1.0'
    end

    ss.subspec 'Mantle1' do |sss|
      Overcoat::coredata_subspec sss
      sss.dependency 'Mantle', '~> 1'

      # Mantle 1.x doesn't support watchOS
      sss.platform = :osx
      sss.platform = :ios
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

    # watchOS doesn't support `Accounts` and `Social` frameworks.
    ss.platform = :osx
    ss.platform = :ios
  end

  s.subspec 'PromiseKit' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'PromiseKit/Promise', '~> 1.2'
    ss.public_header_files = 'sources/PromiseKit/*.h'
    ss.source_files = 'sources/PromiseKit/*.{h,m}'
    ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_PROMISE_KIT=1',  # Used for shortcuts in umbrella header
    }

    # PromiseKit 1.x doesn't support watchOS
    ss.platform = :osx
    ss.platform = :ios
  end

  s.subspec 'ReactiveCocoa' do |ss|
    ss.dependency 'Overcoat/Core'
    ss.dependency 'ReactiveCocoa', '~> 2.4'
    ss.public_header_files = 'sources/ReactiveCocoa/*.h'
    ss.source_files = 'sources/ReactiveCocoa/*.{h,m}'
    ss.user_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'OVERCOAT_SUPPORT_REACTIVE_COCOA=1',  # Used for shortcuts in umbrella header
    }

    # ReactiveCocoa doesn't support watchOS
    ss.platform = :osx
    ss.platform = :ios
  end

end
