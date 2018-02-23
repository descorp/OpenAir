Pod::Spec.new do |s|
  s.name             = 'OpenAirSwift'
  s.version          = '0.1.0'
  s.summary          = 'Access to OpenAir XML API'

  s.description      = <<-DESC
iOS and Mac library for access OpenAir XML API.  
                       DESC

  s.homepage         = 'https://github.com/descorp/OpenAir'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vladimir Abramichev' => 'vladimir.abramichev@mail.ru' }
  s.source           = { :git => 'https://github.com/descorp/OpenAir.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = "10.10"
  s.requires_arc    = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.source_files = 'Source/Classes/**/*'
end
