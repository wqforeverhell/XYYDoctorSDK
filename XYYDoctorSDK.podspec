#
# Be sure to run `pod lib lint XYYDoctorSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XYYDoctorSDK'
  s.version          = '1.0.2'
  s.summary          = 'A short description of XYYDoctorSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aliangsama/XYYDoctorSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wqforeverhell' => '1528553924@qq.com' }
  s.source           = { :git => 'https://github.com/wqforeverhell/XYYDoctorSDK.git', :tag => s.version.to_s }
  #s.source           = { :git => '/Users/qxg/Desktop/xinyiyun__doctor_sdk', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '9.0'    #支持的系统
  #s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'XYYDoctorSDK/Classes/*','XYYDoctorSDK/Classes/**/*'
  
  s.resource_bundles = {
      'XYYDoctorSDK' => ['XYYDoctorSDK/Assets/*.{png,xib,storyboard,bundle,imageset,db,cer}']
  }
  
  s.public_header_files = 'XYYDoctorSDK/Classes/*.h','XYYDoctorSDK/Classes/**/*.h'
  s.frameworks = ["WebKit", "MapKit", "CoreLocation", "Foundation", "UIKit", "MobileCoreServices","MediaPlayer","AddressBook","AddressBookUI","AssetsLibrary","ContactsUI"]
  s.dependency 'MBProgressHUD', '~> 1.0.0'
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'LKDBHelper', '~> 2.1.3'
  s.dependency 'NIMSDK', '~> 5.5.0'
  s.dependency 'Reachability', '~> 3.2'
  s.dependency 'M80AttributedLabel', '~> 1.6.3'
  s.dependency 'SDWebImage', '~> 4.2.2'
  s.dependency 'Toast', '~> 3.0'
  s.dependency 'TZImagePickerController', '~> 1.9.3'
end
