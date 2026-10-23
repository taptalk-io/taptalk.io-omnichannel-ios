//
//  TTLKeyboardAccessoryView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLKeyboardAccessoryView : TTLBaseView

@property (strong, nonatomic) UIView *headerKeyboardView;
@property (strong, nonatomic) UIView *topSeparatorKeyboardView;
@property (strong, nonatomic) UIView *bottomSeparatorKeyboardView;
@property (strong, nonatomic) UIButton *doneKeyboardButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)setHeaderKeyboardButtonTitleWithText:(NSString *)title;
- (void)setIsLoading:(BOOL)isLoading;

@end

NS_ASSUME_NONNULL_END
