//
//  TTLBaseViewController.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTLPopUpInfoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLBaseViewController : UIViewController

- (void)keyboardWillShowWithHeight:(CGFloat)keyboardHeight;
- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight;
- (void)showCustomBackButton;
- (void)showCustomCloseButton;
- (void)showCustomRightCloseButton;
- (void)showCustomCancelButton;
- (void)reachabilityChangeIsReachable:(BOOL)reachable;
- (void)showPopupViewWithPopupType:(TTLPopUpInfoViewControllerType)type popupIdentifier:(NSString * _Nonnull)popupIdentifier title:(NSString * _Nonnull)title detailInformation:(NSString * _Nonnull)detailInfo leftOptionButtonTitle:(NSString * __nullable)leftOptionString singleOrRightOptionButtonTitle:(NSString * __nullable)singleOrRightOptionString ;
- (void)popUpInfoDidTappedLeftButtonWithIdentifier:(NSString * _Nonnull)popupIdentifier;
- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString * _Nonnull)popupIdentifier;
- (void)showNavigationSeparator:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
