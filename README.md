# TapTalk.io Omnichannel SDK (TapTalkLive)
![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/language-Objective--C-orange.svg)

## Introduction
[TapTalk.io Omnichannel SDK](https://taptalk.io/onetalk) is a complete in-app SDK for OneTalk Live Chat implementation provided by TapTalk.io. It provides you with customizable UI Based implementation.

## Getting TapTalk.io Omnichannel SDK (Swift Package Manager)
From version 3.0.0 and above, TapTalk.io Omnichannel SDK is available in Swift Package Manager. 

### Installation
1. To add TapTalk.io Omnichannel package to your project, open your project in Xcode, then go to menu bar then select **File -> Add Package Dependencies**, then enter https://github.com/taptalk-io/taptalk.io-omnichannel-ios in the top right search bar.
2. Specify the version and your project, then click **Add Package**.
3. After the package is resolved, select your project from the Project navigator (folder icon at the top left pane), click the required target, go to **General** tab and make sure **OneTalkLiveChat** is added to Frameworks and Libraries, if not, add it with the **+** button, then add OneTalkLiveChat from TapTalkLive Package.
4. Check out the samples or follow the **Quick Start & Documentation** guide to start using it in your project.

## Getting TapTalk.io Omnichannel SDK (Cocoapods)

### Dependencies
TapTalk.io Omnichannel SDK depends on _TapTalkLive_ SDK. Since _TapTalkLive_ uses `git-lfs` you will need to install it to clone/install TapTalk.io Omnichannel SDK through **Cocoapods**.
Easiest way to install [git-lfs](https://git-lfs.github.com) is using [brew](https://brew.sh):
```
brew install git-lfs
git lfs install
```

### Installation
1. **Install git-lfs**
2. Add `pod 'TapTalkLive'` to your podfile
3. Run `pod install`
4. Check out the samples or follow the **Quick Start & Documentation** guide to start using it in your project.

## Quick Start & Documentation
For more information about the documentation, please refer to this [documentation page](https://docs.taptalk.io/onetalk-omnichannel-documentation/onetalk-channel-integration/live-chat/onetalk-ios/get-started-ios)
