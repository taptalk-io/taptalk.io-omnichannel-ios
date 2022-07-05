source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
inhibit_all_warnings!

def tapTalkLive_pods
  pod 'TapTalk'
  pod 'AFNetworking', '~> 4.0.0', :modular_headers => true
  pod 'JSONModel', '~> 1.1', :modular_headers => true
  pod 'SDWebImage'
  pod 'PodAsset'
end

target "TapTalkLive" do
    tapTalkLive_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      target.build_settings(config.name)['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end

