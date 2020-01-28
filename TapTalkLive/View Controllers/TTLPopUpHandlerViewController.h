//
//  TTLPopUpHandlerViewController.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 28/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseViewController.h"
#import <TapTalk/TAPRoomModel.h>
#import <TapTalk/TAPUserModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLPopUpHandlerViewController : TTLBaseViewController

@property (strong, nonatomic) TAPRoomModel *room;
@property (strong, nonatomic) TAPUserModel *sender;
@property (strong, nonatomic) TAPUserModel *recipient;

- (void)showPopupViewWithPopupType:(TTLPopUpInfoViewControllerType)type popupIdentifier:(NSString *)popupIdentifier title:(NSString *)title detailInformation:(NSString *)detailInfo leftOptionButtonTitle:(NSString * __nullable)leftOptionString singleOrRightOptionButtonTitle:(NSString * __nullable)singleOrRightOptionString;
- (void)popUpInfoDidTappedLeftButtonWithIdentifier:(NSString * _Nonnull)popupIdentifier;
- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString * _Nonnull)popupIdentifier;

@end

NS_ASSUME_NONNULL_END
