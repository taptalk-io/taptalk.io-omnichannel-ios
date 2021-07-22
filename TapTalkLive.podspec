Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.name         = "TapTalkLive"
    s.version      = "1.0.9"
    s.summary      = "TapTalk.io Live Chat SDK is a complete live chat customer service chat SDK and API. Its in-app chat features give you and your user the best in-app chat experience. TapTalk.io Live Chat SDK UI based implementation and code based implementation and is fully customizable."
    s.homepage     = "https://taptalk.io"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.authors = { 'TapTalk.io' => 'hello@taptalk.io' }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.platform     = :ios, "11.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.source       = { :git => 'https://github.com/taptalk-io/taptalk.io-omnichannel-ios.git', :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.source_files  = "TapTalkLive", "TapTalkLive/*{h,m}", "TapTalkLive/**/*.{h,m}", "TapTalkLive/**/**/*.{h,m}"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    #s.resources = "TapTalkLive/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf,otf}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

   s.static_framework = true

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.dependency "TapTalk"
    s.dependency "AFNetworking"
    s.dependency "JSONModel", "~> 1.1"
    s.dependency "SDWebImage"
    s.dependency "PodAsset"

    # ――― Prefix Header ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.prefix_header_contents ='#import "AFNetworkActivityIndicatorManager.h"', '#import "NSUserDefaults+DVSecureUserDefaults.h"', '#import "PodAsset.h"', '#import "TTLConfigs.h"', '#import "TTLStyle.h"', '#import "TapTalkLive.h"', '#import "TTLUtil.h"', '#import "TTLImageView.h"', '#import "TTLImage.h"', '#import "TTLCustomDropDownTextFieldView.h"', '#import "TTLFormGrowingTextView.h"', '#import "TTLCustomButtonView.h"', '#import "TTLStyleManager.h"', '#import "TTLAPIManager.h"', '#import "TTLDataManager.h"', '#import "TTLNetworkManager.h"', '#import "TTLUserModel.h"', '#import "TTLCaseModel.h"', '#import "TTLTopicModel.h"'
    # ――― Bundle ------―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    
    s.resource_bundles = {
        'TapTalkLive' => [
            'Pod/**/*.xib',
            'Pod/**/*.storyboard',
            'Pod/**/*.{png,jpeg,jpg,xcassets,ttf,otf,caf}',
            'TapTalkLive/**/*.xib',
            'TapTalkLive/**/*.storyboard',
            'TapTalkLive/**/*.{png,jpeg,jpg,xcassets,ttf,otf,caf}',
            'TapTalkLive/*.lproj/*.strings'
        ]
    }

    # ――― XCConfig ------―――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #uncomment to disable bitcode
#    s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'DEBUG_INFORMATION_FORMAT' => 'dwarf' }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
