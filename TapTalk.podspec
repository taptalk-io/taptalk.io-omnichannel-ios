Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.name         = "TapTalk Live"
    s.version      = "0.0.1"
    s.summary      = "TapTalk.io is a complete in-app chat SDK and messaging API. Its in-app chat feature give you and your user the best in-app chat experience, it provides you with UI Based implementation and code based implementation and fully customizable."
    s.homepage     = "https://taptalk.io"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.authors = { 'Ritchie Nathaniel' => 'ritchie@taptalk.io',
                  'Dominic Vedericho' => 'dominic@taptalk.io' }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.platform     = :ios, "11.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.source       = { :git => 'https://github.com/taptalk-io/taptalk.io-ios.git', :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.source_files  = "TapTalkLive", "TapTalkLive/*{h,m}", "TapTalkLive/**/*.{h,m}", "TapTalkLive/**/**/*.{h,m}"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    #s.resources = "TapTalkLive/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf,otf}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

   s.static_framework = true

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.dependency "AFNetworking", "~> 3.1.0"
    s.dependency "SocketRocket"
    s.dependency "JSONModel", "~> 1.1"
    s.dependency "Realm", "3.13.1"
    s.dependency "SDWebImage", "4.4.2"
    s.dependency "PodAsset"
    s.dependency "GooglePlaces"
    s.dependency "GooglePlacePicker"
    s.dependency "GoogleMaps"
    s.dependency "ZSWTappableLabel", "~> 2.0"

    # ――― Prefix Header ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.prefix_header_contents ='#import "Configs.h"', '#import "TAPStyle.h"', '#import "AFNetworkActivityIndicatorManager.h"', '#import "NSUserDefaults+MPSecureUserDefaults.h"', '#import "PodAsset.h"', '#import "TapTalk.h"', '#import "TapUI.h"', '#import "TAPUtil.h"', '#import "TapCoreChatRoomManager.h"', '#import "TapCoreContactManager.h"', '#import "TapCoreErrorManager.h"', '#import "TapCoreMessageManager.h"', '#import "TapCoreRoomListManager.h"', '#import "TAPChatManager.h"', '#import "TAPConnectionManager.h"', '#import "TAPContactManager.h"', '#import "TAPContactCacheManager.h"', '#import "TAPCustomBubbleManager.h"', '#import "TAPDataManager.h"', '#import "TAPDatabaseManager.h"', '#import "TAPEncryptorManager.h"', '#import "TAPFetchMediaManager.h"', '#import "TAPFileDownloadManager.h"', '#import "TAPFileUploadManager.h"', '#import "TAPGroupManager.h"', '#import "TAPLocationManager.h"', '#import "TAPMessageStatusManager.h"', '#import "TAPNetworkManager.h"', '#import "TAPNotificationManager.h"', '#import "TAPOldDataManager.h"', '#import "TAPStyleManager.h"', '#import "TAPGrowingTextView.h"', '#import "TAPImageView.h"', '#import "TAPSearchBarView.h"', '#import "UIImage+Color.h"'

    # ――― Bundle ------―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    
    s.resource_bundles = {
        'TapTalkLive' => [
            'Pod/**/*.xib',
            'Pod/**/*.storyboard',
            'Pod/**/*.{png,jpeg,jpg,xcassets,ttf,otf,caf}',
            'TapTalkLive/**/*.xib',
            'TapTalkLive/**/*.storyboard',
            'TapTalkLive/**/*.{png,jpeg,jpg,xcassets,ttf,otf,caf}'
        ]
    }

    # ――― XCConfig ------―――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #uncomment to disable bitcode
#    s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'DEBUG_INFORMATION_FORMAT' => 'dwarf' }

end
