//
//  TTLBaseView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import "TTLBaseView.h"

@implementation TTLBaseView

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Custom Method
+ (CGRect)frameWithNavigationBar {
    return CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - [TTLUtil currentDeviceNavigationBarHeightWithStatusBar:YES iPhoneXLargeLayout:NO]);
}

+ (CGRect)frameWithoutNavigationBar {
    return CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
}

@end
