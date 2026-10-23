//
//  TTLBaseView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLBaseView : UIView

+ (CGRect)frameWithNavigationBar;
+ (CGRect)frameWithoutNavigationBar;

@end

NS_ASSUME_NONNULL_END
