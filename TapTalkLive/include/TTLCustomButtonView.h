//
//  TTLCustomButtonView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTLCustomButtonViewType) {
    TTLCustomButtonViewTypeActive = 0,
    TTLCustomButtonViewTypeInactive = 1
};

typedef NS_ENUM(NSInteger, TTLCustomButtonViewStyleType) {
    TTLCustomButtonViewStyleTypePlain = 0,
    TTLCustomButtonViewStyleTypeWithIcon = 1,
    TTLCustomButtonViewStyleTypeDestructivePlain = 2,
    TTLCustomButtonViewStyleTypeDestructiveWithIcon = 3,
};

typedef NS_ENUM(NSInteger, TTLCustomButtonViewIconPosititon) {
    TTLCustomButtonViewIconPosititonLeft = 0,
    TTLCustomButtonViewIconPosititonRight = 1
};

@protocol TTLCustomButtonViewDelegate <NSObject>

- (void)customButtonViewDidTappedButton;

@end

@interface TTLCustomButtonView : UIView

@property (strong, nonatomic) UIButton *button;
@property (nonatomic) TTLCustomButtonViewType customButtonViewType;
@property (nonatomic) TTLCustomButtonViewStyleType customButtonViewStyleType;
@property (weak, nonatomic) id <TTLCustomButtonViewDelegate> delegate;

- (void)setCustomButtonViewType:(TTLCustomButtonViewType)customButtonViewType;
- (void)setCustomButtonViewStyleType:(TTLCustomButtonViewStyleType)customButtonViewStyleType;
- (void)setButtonWithTitle:(NSString *)title;
- (void)setButtonWithTitle:(NSString *)title andIcon:(NSString *)imageName iconPosition:(TTLCustomButtonViewIconPosititon)ttlCustomButtonViewIconPosititon;
- (void)setAsActiveState:(BOOL)active animated:(BOOL)animated;
- (void)setAsLoading:(BOOL)loading animated:(BOOL)animated;
- (void)setButtonIconTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
