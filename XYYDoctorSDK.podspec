Pod::Spec.new do |s|
  s.name = "XYYDoctorSDK"
  s.version = "1.0.2"
  s.summary = "A short description of XYYDoctorSDK."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"wqforeverhell"=>"1528553924@qq.com"}
  s.homepage = "https://github.com/aliangsama/XYYDoctorSDK"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = ["WebKit", "MapKit", "CoreLocation", "Foundation", "UIKit", "MobileCoreServices", "MediaPlayer", "AddressBook", "AddressBookUI", "AssetsLibrary", "ContactsUI"]
  s.requires_arc = true
  s.source = { :path => '.' }
  s.resource_bundles = {
      'XYYDoctorSDK' => ['Assets/*.{png,xib,storyboard,bundle,imageset,db,cer}']
  }
  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/XYYDoctorSDK.framework'
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
