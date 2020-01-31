//
//  TTLPopUpInfoView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLPopUpInfoView.h"

@interface TTLPopUpInfoView ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *popupWhiteView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

- (void)resizeSubview;
- (void)isShowTwoOptionButton:(BOOL)isShow;

@end

@implementation TTLPopUpInfoView

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        [self addSubview:self.backgroundView];
        
        _popupWhiteView = [[UIView alloc] initWithFrame:CGRectMake(32.0f, 0.0f, CGRectGetWidth(self.frame) - 32.0f - 32.0f, 0.0f)];
        self.popupWhiteView.layer.cornerRadius = 4.0f;
        self.popupWhiteView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
        self.popupWhiteView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.popupWhiteView.layer.shadowOpacity = 0.4f;
        self.popupWhiteView.layer.shadowRadius = 4.0f;
        self.popupWhiteView.backgroundColor = [UIColor whiteColor];
        self.popupWhiteView.clipsToBounds = YES;
        [self addSubview:self.popupWhiteView];
        
        UIFont *popupTitleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontPopupDialogTitle];
        UIColor *popupTitleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogTitle];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 16.0f, CGRectGetWidth(self.popupWhiteView.frame) - 16.0f - 16.0f, 22.0f)];
        self.titleLabel.font = popupTitleLabelFont;
        self.titleLabel.textColor = popupTitleLabelColor;
        [self.popupWhiteView addSubview:self.titleLabel];
        
        UIFont *popupBodyLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontPopupDialogBody];
        UIColor *popupBodyLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogBody];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 4.0f, CGRectGetWidth(self.titleLabel.frame), 0.0f)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = popupBodyLabelFont;
        self.detailLabel.textColor = popupBodyLabelColor;
        [self.popupWhiteView addSubview:self.detailLabel];
        
        UIFont *popupPrimaryButtonFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontPopupDialogButtonTextPrimary];
        UIColor *popupPrimaryButtonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogButtonTextPrimary];
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.popupWhiteView.frame) - 85.0f - 16.0f, CGRectGetMaxY(self.detailLabel.frame) + 16.0f, 85.0f, 40.0f)];
        self.rightButton.titleLabel.font = popupPrimaryButtonFont;
        self.rightButton.layer.cornerRadius = 4.0f;
        self.rightButton.titleLabel.textColor = popupPrimaryButtonColor;
        self.rightButton.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorPopupDialogPrimaryButtonSuccessBackground];
        [self.popupWhiteView addSubview:self.rightButton];
        
        UIFont *popupSecondaryButtonFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontPopupDialogButtonTextSecondary];
        UIColor *popupSecondaryButtonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogButtonTextSecondary];
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rightButton.frame) - 6.0f - 85.0f, CGRectGetMinY(self.rightButton.frame), CGRectGetWidth(self.rightButton.frame), CGRectGetHeight(self.rightButton.frame))];
        self.leftButton.layer.cornerRadius = 4.0f;
        self.leftButton.titleLabel.font = popupSecondaryButtonFont;
        self.leftButton.titleLabel.textColor = popupSecondaryButtonColor;
        self.leftButton.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorPopupDialogSecondaryButtonBackground];
        [self.popupWhiteView addSubview:self.leftButton];
        
    }
    return self;
}

#pragma mark - Custom Method
- (void)resizeSubview {
    CGSize size = [self.detailLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.detailLabel.frame), CGFLOAT_MAX)];
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.detailLabel.frame), CGRectGetMinY(self.detailLabel.frame), CGRectGetWidth(self.detailLabel.frame), size.height);
    
    self.rightButton.frame = CGRectMake(CGRectGetMinX(self.rightButton.frame), CGRectGetMaxY(self.detailLabel.frame) + 16.0f, CGRectGetWidth(self.rightButton.frame), CGRectGetHeight(self.rightButton.frame));
    
    self.leftButton.frame = CGRectMake(CGRectGetMinX(self.leftButton.frame), CGRectGetMinY(self.rightButton.frame), CGRectGetWidth(self.leftButton.frame), CGRectGetHeight(self.leftButton.frame));

    CGFloat popupInfoViewHeight = CGRectGetMaxY(self.rightButton.frame) + 16.0f;
    self.popupWhiteView.frame = CGRectMake(CGRectGetMinX(self.popupWhiteView.frame), (CGRectGetHeight(self.frame) - popupInfoViewHeight) / 2.0f, CGRectGetWidth(self.popupWhiteView.frame), popupInfoViewHeight);
}

- (void)isShowTwoOptionButton:(BOOL)isShow {
    if (isShow) {
        self.leftButton.userInteractionEnabled = YES;
        self.leftButton.alpha = 1.0f;
    }
    else {
        self.leftButton.userInteractionEnabled = NO;
        self.leftButton.alpha = 0.0f;
    }
}

- (void)setPopupInfoViewType:(TTLPopupInfoViewType)popupInfoViewType withTitle:(NSString *)title detailInformation:(NSString *)detailInfo leftOptionButtonTitle:(NSString *)leftOptionTitle singleOrRightOptionButtonTitle:(NSString *)singleOrRightOptionTitle {
    _popupInfoViewType = popupInfoViewType;
    
    if (self.popupInfoViewType == TTLPopupInfoViewTypeErrorMessage) {
        [self setPopupInfoViewThemeType:TTLPopupInfoViewThemeTypeDestructive];
    }
    else if (self.popupInfoViewType == TTLPopupInfoViewTypeSuccessMessage) {
        [self setPopupInfoViewThemeType:TTLPopupInfoViewThemeTypeDefault];
    }
    else if (self.popupInfoViewType == TTLPopupInfoViewTypeInfoDefault) {
        [self setPopupInfoViewThemeType:TTLPopupInfoViewThemeTypeDefault];
    }
    else if (self.popupInfoViewType == TTLPopupInfoViewTypeInfoDestructive) {
        [self setPopupInfoViewThemeType:TTLPopupInfoViewThemeTypeDestructive];
    }
    
    self.titleLabel.text = title;
    self.detailLabel.text = detailInfo;
    [self.leftButton setTitle:leftOptionTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:singleOrRightOptionTitle forState:UIControlStateNormal];
    
    [self resizeSubview];
}


- (void)setPopupInfoViewThemeType:(TTLPopupInfoViewThemeType)popupInfoViewThemeType {
    
    UIColor *popupPrimaryButtonSuccessColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogButtonTextPrimary];
    UIColor *popupPrimaryButtonSuccessBackgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorPopupDialogPrimaryButtonSuccessBackground];
    
    UIColor *popupPrimaryButtonDestructiveColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogButtonTextPrimary];
    UIColor *popupPrimaryButtonDestructiveBackgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorPopupDialogPrimaryButtonErrorBackground];
    
    UIColor *popupSecondaryButtonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorPopupDialogButtonTextSecondary];
    UIColor *popupSecondaryBackgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorPopupDialogSecondaryButtonBackground];
    
    _popupInfoViewThemeType = popupInfoViewThemeType;
    if (self.popupInfoViewThemeType == TTLPopupInfoViewThemeTypeDestructive) {
        //Red theme
        [self.rightButton setTitleColor:popupPrimaryButtonDestructiveColor forState:UIControlStateNormal];
        self.rightButton.backgroundColor = popupPrimaryButtonDestructiveBackgroundColor;
        
        [self.leftButton setTitleColor:popupSecondaryButtonColor forState:UIControlStateNormal];
        self.leftButton.backgroundColor = popupSecondaryBackgroundColor;
    }
    else {
        //Default green theme
        [self.rightButton setTitleColor:popupPrimaryButtonSuccessColor forState:UIControlStateNormal];
        self.rightButton.backgroundColor = popupPrimaryButtonSuccessBackgroundColor;
        
        [self.leftButton setTitleColor:popupSecondaryButtonColor forState:UIControlStateNormal];
        self.leftButton.backgroundColor = popupSecondaryBackgroundColor;
    }
}

@end

