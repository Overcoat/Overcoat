Pod::Spec.new do |s|
  s.name     = 'Overcoat+Social'
  s.version  = File.read(File.join __dir__, 'Version').strip
  s.cocoapods_version = '>= 0.39'
  s.license  = 'MIT'
  s.summary  = 'Overcoat is a small but powerful library that makes creating REST clients simple and fun.'
  s.homepage = 'https://github.com/overcoat/Overcoat'
  s.authors  = { 'Guillermo Gonzalez' => 'gonzalezreal@icloud.com', 'sodastsai' => 'sodas@icloud.com' }
  s.source   = { :git => 'https://github.com/overcoat/Overcoat.git', :tag => "#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.frameworks = 'Accounts', 'Social'
  s.dependency 'AFNetworking/Serialization', '~> 3.0'

  s.source_files = 'sources/Social/*.{h,m}'
  s.header_dir = 'OvercoatSocial'
end
