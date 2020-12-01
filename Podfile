source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def tapTalkLive_pods
  pod 'TapTalk', :git => 'https://github.com/alfian0/taptalk.io-ios.git', :commit => 'aca841546c2981d2c08cf539734b8cb1380679ab'
  pod 'AFNetworking', '~> 4.0.0'
  pod 'JSONModel', '~> 1.1'
  pod 'SDWebImage'
  pod 'PodAsset'
end

target "TapTalkLive" do
    tapTalkLive_pods
end
