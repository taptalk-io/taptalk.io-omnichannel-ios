Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.name         = "TapTalkLive"
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

    s.dependency "TapTalk"

    # ――― Prefix Header ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.prefix_header_contents ='#import "Configs.h"', '#import "TapTalkLive.h"'
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
