//
//  TTLPopUpInfoViewController.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTLPopUpInfoView.h"

typedef NS_ENUM(NSInteger, TTLPopUpInfoViewControllerType) {
    TTLPopUpInfoViewControllerTypeErrorMessage, // 1 button red
    TTLPopUpInfoViewControllerTypeSuccessMessage, // 1 button green
    TTLPopUpInfoViewControllerTypeInfoDefault, // 2 button (grey, green)
    TTLPopUpInfoViewControllerTypeInfoDestructive, // 2 button (grey, red)
};

@protocol TTLPopUpInfoViewControllerDelegate <NSObject>

- (void)popUpInfoViewControllerDidTappedLeftButtonWithIdentifier:(NSString *_Nonnull)identifier;
- (void)popUpInfoViewControllerDidTappedSingleButtonOrRightButtonWithIdentifier:(NSString *_Nonnull)identifier;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTLPopUpInfoViewController : UIViewController

@property (weak, nonatomic) id <TTLPopUpInfoViewControllerDelegate> delegate;
@property (strong, nonatomic) TTLPopUpInfoView *popUpInfoView;
@property (nonatomic) TTLPopUpInfoViewControllerType popUpInfoViewControllerType;
@property (strong, nonatomic) NSString *titleInformation;
@property (strong, nonatomic) NSString *detailInformation;
@property (strong, nonatomic) NSString *popupIdentifier;

- (void)setPopUpInfoViewControllerType:(TTLPopUpInfoViewControllerType)popUpInfoViewControllerType
                             withTitle:(NSString *)title
                     detailInformation:(NSString *)detailInfo
                 leftOptionButtonTitle:(NSString * __nullable)leftOptionTitle
        singleOrRightOptionButtonTitle:(NSString * __nullable)singleOrRightOptionTitle;
- (void)showPopupInfoView:(BOOL)isShow animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

