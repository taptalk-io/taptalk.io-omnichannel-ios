//
//  TTLPopUpInfoView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseView.h"

typedef NS_ENUM(NSInteger, TTLPopupInfoViewType) {
    TTLPopupInfoViewTypeErrorMessage, // 1 button red
    TTLPopupInfoViewTypeSuccessMessage, // 1 button green
    TTLPopupInfoViewTypeInfoDefault, // 2 button (grey, green)
    TTLPopupInfoViewTypeInfoDestructive,// 2 button (grey, red)
};

typedef NS_ENUM(NSInteger, TTLPopupInfoViewThemeType) {
    TTLPopupInfoViewThemeTypeDefault, //Green theme
    TTLPopupInfoViewThemeTypeDestructive //Red theme
};

NS_ASSUME_NONNULL_BEGIN

@interface TTLPopUpInfoView : TTLBaseView

@property (nonatomic) TTLPopupInfoViewType popupInfoViewType;
@property (nonatomic) TTLPopupInfoViewThemeType popupInfoViewThemeType;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

- (void)isShowTwoOptionButton:(BOOL)isShow;
- (void)setPopupInfoViewType:(TTLPopupInfoViewType)popupInfoViewType withTitle:(NSString *)title detailInformation:(NSString *)detailInfo leftOptionButtonTitle:(NSString *)leftOptionTitle singleOrRightOptionButtonTitle:(NSString *)singleOrRightOptionTitle;
- (void)setPopupInfoViewThemeType:(TTLPopupInfoViewThemeType)popupInfoViewThemeType;

@end

NS_ASSUME_NONNULL_END
