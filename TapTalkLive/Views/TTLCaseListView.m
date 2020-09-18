//
//  TTLCaseListView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 10/02/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCaseListView.h"
#import "TTLCustomButtonView.h"

@interface TTLCaseListView ()

@property (strong, nonatomic) UIView *primaryBackgroundView;
@property (strong, nonatomic) TTLImageView *logoImageView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIView *closeButtonContainerView;
@property (strong, nonatomic) UIImageView *closeImageView;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) TTLCustomButtonView *addNewChatButton;

@end

@implementation TTLCaseListView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _primaryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 223.0f)];
        self.primaryBackgroundView.backgroundColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
        [self addSubview:self.primaryBackgroundView];
        
        _logoImageView = [[TTLImageView alloc] initWithFrame:CGRectMake(12.0f, 16.0f, 48.0f, 48.0f)];
        [self addSubview:self.logoImageView];
 
        _closeButtonContainerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 12.0f - 32.0f, 24.0f, 32.0f, 32.0f)];
        self.closeButtonContainerView.backgroundColor = [[TTLUtil getColor:@"191919"] colorWithAlphaComponent:0.1f];
        self.closeButtonContainerView.layer.cornerRadius = 8.0f;
        [self addSubview:self.closeButtonContainerView];
        
        _closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.closeButtonContainerView.frame) - 24.0f) / 2.0f, (CGRectGetHeight(self.closeButtonContainerView.frame) - 24.0f) / 2.0f, 24.0f, 24.0f)];
        self.closeImageView.image = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] withConfiguration:nil];
        TTLImage *closeIconImage = self.closeImageView.image;
        closeIconImage = [closeIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        self.closeImageView.image = closeIconImage;
        [self addSubview:self.closeImageView];

        CGFloat headerLabelWidth = CGRectGetWidth(self.frame) - CGRectGetMaxX(self.logoImageView.frame) - 12.0f - 12.0f - CGRectGetWidth(self.closeButtonContainerView.frame) - 12.0f;
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame), 22.0f, headerLabelWidth, 36.0f)];
        UIFont *headerLabelTitleFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontInfoLabelTitle];
        UIColor *headerLabelTitleColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLComponentFontInfoLabelTitle];
        self.headerLabel.text = NSLocalizedStringFromTableInBundle(@"Messages", nil, [TTLUtil currentBundle], @"");
        self.headerLabel.font = headerLabelTitleFont;
        self.headerLabel.textColor = headerLabelTitleColor;
        [self addSubview:self.headerLabel];
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(12.0f, CGRectGetHeight(self.frame) - 72.0f, CGRectGetWidth(self.frame) - 12.0f - 12.0f, 72.0f)];
        [self addSubview:self.footerView];
        
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.footerView.frame), 1.0f)];
        self.separatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
        [self.footerView addSubview:self.separatorView];
        
        _addNewChatButton = [[TTLCustomButtonView alloc] initWithFrame:CGRectMake(0.0f, (CGRectGetHeight(self.footerView.frame) - 48.0f) / 2.0f, CGRectGetWidth(self.footerView.frame), 48.0f)];
        [self.addNewChatButton setCustomButtonViewStyleType:TTLCustomButtonViewStyleTypeWithIcon];
        [self.addNewChatButton setCustomButtonViewType:TTLCustomButtonViewTypeActive];
        [self.addNewChatButton setButtonWithTitle:NSLocalizedStringFromTableInBundle(@"New Message", nil, [TTLUtil currentBundle], @"") andIcon:@"TTLIconSend" iconPosition:TTLCustomButtonViewIconPosititonLeft];
        [self.addNewChatButton setButtonIconTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        [self.footerView addSubview:self.addNewChatButton];
    }
    
    return self;
}

#pragma mark - Custom Method

@end
