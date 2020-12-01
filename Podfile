source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def tapTalkLive_pods
  pod 'TapTalk', :git => 'https://github.com/alfian0/taptalk.io-ios.git', :commit => '7a7f47af09bfe155ff944fbaf4cc2d569abb5a18'
  pod 'AFNetworking', '~> 4.0.0'
  pod 'JSONModel', '~> 1.1'
  pod 'SDWebImage'
  pod 'PodAsset'
end

target "TapTalkLive" do
    tapTalkLive_pods
end
