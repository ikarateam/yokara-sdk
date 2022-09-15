#
# Be sure to run `pod lib lint yokara-sdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'yokara-sdk'
  s.version          = '1.1.3'
  s.summary          = 'Yokara SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rainnguyen/YokaraSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vu' => 'rainnguyen4490@gmail.com' }
  s.source           = { :git => 'https://github.com/rainnguyen/YokaraSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Classes/**/*'#YokaraSDK.h'
  s.info_plist = {
    'UIMainStoryboardFile' => 'PrepareRecord' ,
    'CFBundleVersion' => '1.1.3'
  }
   s.resource_bundles = {
     'YokaraSDK' => ['./*/*.{xib,storyboard,xcassets,json,png,jpg,lproj/*.strings}']
   }
  s.static_framework = true
  s.public_header_files = 'YokaraSDK/Classes/YokaraSDK.h'
  s.ios.vendored_frameworks = 'Pods/mp3lame-for-ios/lame.framework'
  s.frameworks = 'UIKit', 'CoreAudio' , 'CoreFoundation' , 'AVFoundation'
  s.ios.vendored_library = 'YokaraSDK/Classes/YokaraKaraoke/Model/libSuperpoweredAudioIOS.a'
  s.vendored_library = 'libc++.tbd'
  s.dependency 'AFNetworking' , '~> 4.0.0'
  s.dependency 'SDWebImage'
  s.dependency 'SDWebImageWebPCoder'
  s.dependency 'TOCropViewController'
  s.dependency 'CRRulerControl'
  s.dependency 'GZIP'
  s.dependency 'AKPickerView'
  s.dependency 'Firebase'
  s.dependency 'FirebaseAuth'
  s.dependency 'FirebaseFunctions'
  s.dependency 'FirebaseAnalytics'
  s.dependency 'FirebaseStorage'
  s.dependency 'FirebaseDatabase'
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'SCRecorder'
  s.dependency 'TheAmazingAudioEngine'
  s.dependency "youtube-ios-player-helper" , "~> 0.1.4"
  s.dependency 'JWGCircleCounter'
  s.dependency 'AWSS3', "~> 2.6.0"
  s.dependency 'mp3lame-for-ios'
  s.dependency 'Reachability'
  s.dependency 'SVGAPlayer', '~> 2.3'
  s.dependency 'lottie-ios' , "~> 2.1.4"
end
