#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint title_generator.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'title_generator'
  s.version          = '0.0.1'
  s.summary          = 'Generate smart titles from text using platform-specific Natural Language Processing capabilities.'
  s.description      = <<-DESC
Generate smart titles from text using platform-specific Natural Language Processing capabilities. 
Supports iOS and Android with native NLP integration.
                       DESC
  s.homepage         = 'https://github.com/rikun5989/title_generator'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rikun Patel' => 'rikun5989@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'title_generator_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
