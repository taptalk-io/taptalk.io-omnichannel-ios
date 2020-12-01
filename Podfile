source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def tapTalkLive_pods
  pod 'TapTalk', :git => 'https://github.com/alfian0/taptalk.io-ios.git', :commit => '8174dd281ff5104dc32f1fdf7c3658f745bb6aa3'
  pod 'AFNetworking', '~> 4.0.0'
  pod 'JSONModel', '~> 1.1'
  pod 'SDWebImage'
  pod 'PodAsset'
end

target "TapTalkLive" do
    tapTalkLive_pods
end
