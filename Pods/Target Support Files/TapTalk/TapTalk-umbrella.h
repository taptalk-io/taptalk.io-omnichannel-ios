#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TapUI.h"
#import "TAPLocationManager.h"
#import "TAPNetworkManager.h"

FOUNDATION_EXPORT double TapTalkVersionNumber;
FOUNDATION_EXPORT const unsigned char TapTalkVersionString[];

