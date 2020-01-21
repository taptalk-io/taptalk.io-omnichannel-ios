//
//  TTLKeyboardAccessoryView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLKeyboardAccessoryView.h"

@implementation TTLKeyboardAccessoryView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _headerKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f)];
//        self.headerKeyboardView.backgroundColor = [UIColor whiteColor];
        self.headerKeyboardView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorDefaultBackground];
        self.headerKeyboardView.clipsToBounds = YES;
        [self addSubview:self.headerKeyboardView];
        
        _topSeparatorKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.headerKeyboardView.frame), [TTLUtil lineMinimumHeight])];
        self.topSeparatorKeyboardView.backgroundColor = [TTLUtil getColor:@"8C8C8C"];
        [self.headerKeyboardView addSubview:self.topSeparatorKeyboardView];
        
        _bottomSeparatorKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.headerKeyboardView.frame) - [TTLUtil lineMinimumHeight], CGRectGetWidth(self.headerKeyboardView.frame), [TTLUtil lineMinimumHeight])];
        self.bottomSeparatorKeyboardView.backgroundColor = [TTLUtil getColor:@"8C8C8C"];
        [self.headerKeyboardView addSubview:self.bottomSeparatorKeyboardView];
        
        UIFont *keyboardFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontKeyboardAccessoryLabel];
        UIColor *keyboardColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorKeyboardAccessoryLabel];
        _doneKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.headerKeyboardView.frame) - 80.0f, 0.0f, 80.0f, 44.0f)];
        [self.doneKeyboardButton.titleLabel setFont:keyboardFont];
        [self.doneKeyboardButton setTitleColor:keyboardColor forState:UIControlStateNormal];
        [self.headerKeyboardView addSubview:self.doneKeyboardButton];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityIndicator.center = self.doneKeyboardButton.center;
        [self.activityIndicator startAnimating];
        self.activityIndicator.alpha = 0.0f;
        [self.headerKeyboardView addSubview:self.activityIndicator];

    }
    return self;
}

- (void)setHeaderKeyboardButtonTitleWithText:(NSString *)title {
    [self.doneKeyboardButton setTitle:title forState:UIControlStateNormal];
}

- (void)setIsLoading:(BOOL)isLoading {
    if(isLoading) {
        self.doneKeyboardButton.alpha = 0.0f;
        self.activityIndicator.alpha = 1.0f;
    }
    else {
        self.doneKeyboardButton.alpha = 1.0f;
        self.activityIndicator.alpha = 0.0f;
    }
}

@end

