# TapTalk.io Omnichannel SDK (TapTalkLive)
![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/language-Objective--C-orange.svg)

## Introduction
[TapTalk.io Omnichannel SDK](https://taptalk.io/onetalk) is an SDK for Live Chat provided by TapTalk.io. It provides you with UI Based implementation and fully customizable.

## Dependencies

TapTalk.io Omnichannel SDK depends on _TapTalkLive_ SDK. Since _TapTalkLive_ uses `git-lfs` you will need to install it to clone/install TapTalk.io Omnichannel SDK through **Cocoapods**.
Easiest way to install [git-lfs](https://git-lfs.github.com) is using [brew](https://brew.sh):
```
brew install git-lfs
git lfs install
```

## Getting TapTalk.io Omnichannel SDK
1. **Install git-lfs**
2.  Add `pod 'TapTalkLive'` to your podfile
3. Check out the samples or follow the **Quick Start & Documentation** guide to start using it in your project.

## Integration with Cocoapods
_TapTalk.io Omnichannel SDK (TapTalkLive)_ is an **Objective-C** framework, but you can also using it with **Swift** by creating the bridging header.

Add `TapTalkLive` to your target inside your `Podfile`:
```
pod 'TapTalkLive'
``` 
Run:
```
pod install
```

## Documentation
For more information about the documentation, please refer to this [documentation page](https://docs.taptalk.io/onetalk-omnichannel-documentation/onetalk-channel-integration/live-chat/onetalk-ios/get-started-ios)
