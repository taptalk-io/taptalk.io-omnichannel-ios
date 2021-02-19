//
//  TTLCreateCaseView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 03/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCreateCaseView.h"

@interface TTLCreateCaseView ()
@property (strong, nonatomic) UIView *topBackgroundView;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) TTLImageView *logoImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UIView *formHeaderContainerView;

@property (nonatomic) CGFloat messageTextViewHeight;

@end

@implementation TTLCreateCaseView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorDefaultBackground];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        //DV Note
        //500.0f used for still show orange color background dragging up when scrolling
        //END DV Note
        _topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -500.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 244.0f + 500.0f)];
        self.topBackgroundView.backgroundColor = [TTLUtil getColor:@"FF7D00"];
        [self.scrollView addSubview:self.topBackgroundView];
        
        CGFloat topGap = 20.0f;
        if (IS_IPHONE_X_FAMILY) {
            topGap = 44.0f;
        }
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 0.0f)];
        self.headerView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.headerView];
        
        _logoImageView = [[TTLImageView alloc] initWithFrame:CGRectMake(12.0f, topGap + 16.0f, 48.0f, 48.0f)];
        self.logoImageView.clipsToBounds = YES;
        self.logoImageView.image = [UIImage imageNamed:@"TapTalkLogo" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        self.logoImageView.layer.cornerRadius = 8.0f;
        self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.headerView addSubview:self.logoImageView];
        
        _closeImageView = [[TTLImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 24.0f, CGRectGetMinY(self.logoImageView.frame) + 12.0f, 24.0f, 24.0f)];
        self.closeImageView.image = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        TTLImage *closeIconImage = (TTLImage *) self.closeImageView.image;
        closeIconImage = (TTLImage *) [closeIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        self.closeImageView.image = closeIconImage;
        self.closeImageView.alpha = 0.0f;
        [self.headerView addSubview:self.closeImageView];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.closeImageView.frame) - 8.0f, CGRectGetMinY(self.closeImageView.frame) - 8.0f, 40.0f, 40.0f)];
        self.closeButton.alpha = 0.0f;
        self.closeButton.userInteractionEnabled = NO;
        [self.headerView addSubview:self.closeButton];
        
        _leftCloseImageView = [[TTLImageView alloc] initWithFrame:CGRectMake(12.0f, topGap + 16.0f, 24.0f, 24.0f)];
        self.leftCloseImageView.image = (TTLImage *) [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        TTLImage *leftCloseIconImage = (TTLImage *) self.leftCloseImageView.image;
        leftCloseIconImage = (TTLImage *) [leftCloseIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        self.leftCloseImageView.image = leftCloseIconImage;
        self.leftCloseImageView.alpha = 0.0f;
        [self.headerView addSubview:self.leftCloseImageView];
        
        _leftCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.leftCloseImageView.frame) - 8.0f, CGRectGetMinY(self.leftCloseImageView.frame) - 8.0f, 40.0f, 40.0f)];
        self.leftCloseButton.alpha = 0.0f;
        self.leftCloseButton.userInteractionEnabled = NO;
        [self.headerView addSubview:self.leftCloseButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, CGRectGetMaxY(self.logoImageView.frame) + 16.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 12.0f - 12.0f, 36.0f)];
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Need help with anything?", nil, [TTLUtil currentBundle], @"");
        UIFont *obtainedTitleLabelFont = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontBold];
        obtainedTitleLabelFont = [obtainedTitleLabelFont fontWithSize:24.0f];
        self.titleLabel.font = obtainedTitleLabelFont;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.headerView addSubview:self.titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 4.0f, CGRectGetWidth(self.titleLabel.frame), 48.0f)];
        self.subtitleLabel.numberOfLines = 0;
        self.subtitleLabel.text = NSLocalizedStringFromTableInBundle(@"Please fill out the form below before you leave a message", nil, [TTLUtil currentBundle], @"");
        UIFont *obtainedSubtitleLabelFont = [[TTLStyleManager sharedManager] getDefaultFontForType:TTLDefaultFontRegular];
        obtainedSubtitleLabelFont = [obtainedSubtitleLabelFont fontWithSize:16.0f];
        self.subtitleLabel.font = obtainedSubtitleLabelFont;
        self.subtitleLabel.textColor = [UIColor whiteColor];
        CGSize subtitleSize = [self.subtitleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.subtitleLabel.frame), CGFLOAT_MAX)];
        self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.subtitleLabel.frame), CGRectGetMinY(self.subtitleLabel.frame), CGRectGetWidth(self.subtitleLabel.frame), subtitleSize.height);
        [self.headerView addSubview:self.subtitleLabel];
        
        self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMinY(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetMaxY(self.subtitleLabel.frame));
        
        //DV Note
        //500.0f used for still show orange color background dragging up when scrolling
        //END DV Note
        self.topBackgroundView.frame = CGRectMake(CGRectGetMinX(self.topBackgroundView.frame), CGRectGetMinY(self.topBackgroundView.frame), CGRectGetWidth(self.topBackgroundView.frame), CGRectGetMaxY(self.headerView.frame) + 56.0f + topGap + 500.0f);
                
        _formHeaderContainerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.headerView.frame) + 24.0f, CGRectGetWidth(self.titleLabel.frame), 12.0f)];
        self.formHeaderContainerView.backgroundColor = [TTLUtil getColor:@"FFE7D0"];
        CAShapeLayer *headerContainerViewLayer = [CAShapeLayer layer];
        headerContainerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formHeaderContainerView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.formHeaderContainerView.layer.mask = headerContainerViewLayer;
        [self.scrollView addSubview:self.formHeaderContainerView];
        
        _formContainerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.formHeaderContainerView.frame), CGRectGetWidth(self.titleLabel.frame), 100.0f)];
        self.formContainerView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.formContainerView];
        
        _fullNameTextField = [[TTLCustomTextFieldView alloc] initWithFrame:CGRectMake(0.0f, 16.0f, CGRectGetWidth(self.formContainerView.frame), 0.0f)];
        [self.fullNameTextField setTtlCustomTextFieldViewType:TTLCustomTextFieldViewTypeFullName];
        self.fullNameTextField.frame = CGRectMake(CGRectGetMinX(self.fullNameTextField.frame), CGRectGetMinY(self.fullNameTextField.frame), CGRectGetWidth(self.fullNameTextField.frame), [self.fullNameTextField getTextFieldHeight]);
        [self.formContainerView addSubview:self.fullNameTextField];
        
        _emailTextField = [[TTLCustomTextFieldView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.fullNameTextField.frame) + 12.0f, CGRectGetWidth(self.formContainerView.frame), 0.0f)];
        [self.emailTextField setTtlCustomTextFieldViewType:TTLCustomTextFieldViewTypeEmail];
        self.emailTextField.frame = CGRectMake(CGRectGetMinX(self.emailTextField.frame), CGRectGetMinY(self.emailTextField.frame), CGRectGetWidth(self.emailTextField.frame), [self.emailTextField getTextFieldHeight]);
        [self.formContainerView addSubview:self.emailTextField];
        
        _topicDropDownView = [[TTLCustomDropDownTextFieldView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailTextField.frame) + 12.0f, CGRectGetWidth(self.formContainerView.frame), 0.0f)];
        [self.topicDropDownView setTtlCustomDropDownTextFieldViewType:TTLCustomDropDownTextFieldViewTypeTopic];
        self.topicDropDownView.frame = CGRectMake(CGRectGetMinX(self.topicDropDownView.frame), CGRectGetMinY(self.topicDropDownView.frame), CGRectGetWidth(self.topicDropDownView.frame), [self.topicDropDownView getTextFieldHeight]);
        [self.formContainerView addSubview:self.topicDropDownView];
        
        _messageTextView = [[TTLFormGrowingTextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.topicDropDownView.frame) + 12.0f, CGRectGetWidth(self.formContainerView.frame), 0.0f)];
        [self.messageTextView setTtlFormGrowingTextViewType:TTLFormGrowingTextViewTypeMessage];
        [self.messageTextView showTitleLabel:YES];
        self.messageTextView.frame = CGRectMake(CGRectGetMinX(self.messageTextView.frame), CGRectGetMinY(self.messageTextView.frame), CGRectGetWidth(self.messageTextView.frame), [self.messageTextView getHeight]);
        [self.messageTextView setPlaceholderText: NSLocalizedStringFromTableInBundle(@"Type message here", nil, [TTLUtil currentBundle], @"")];
        [self.messageTextView setPlaceholderColor:[TTLUtil getColor:@"C7C7CD"]];
        UIFont *textFieldFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormTextField];
        [self.messageTextView setPlaceholderFont:textFieldFont];
        [self.formContainerView addSubview:self.messageTextView];
        
        _keyboardAccessoryView = [[TTLKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f)];
        [self.keyboardAccessoryView setHeaderKeyboardButtonTitleWithText:NSLocalizedStringFromTableInBundle(@"DONE", nil, [TTLUtil currentBundle], @"")];
        self.messageTextView.textView.inputAccessoryView = self.keyboardAccessoryView;
        
        _createCaseButtonView = [[TTLCustomButtonView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.messageTextView.frame) + 24.0f, CGRectGetWidth(self.formContainerView.frame), 48.0f)];
        [self.createCaseButtonView setCustomButtonViewStyleType:TTLCustomButtonViewStyleTypeWithIcon];
        [self.createCaseButtonView setCustomButtonViewType:TTLCustomButtonViewTypeInactive];
        [self.createCaseButtonView setButtonWithTitle:NSLocalizedStringFromTableInBundle(@"Send Message", nil, [TTLUtil currentBundle], @"") andIcon:@"TTLIconSend" iconPosition:TTLCustomButtonViewIconPosititonLeft];
        [self.createCaseButtonView setAsActiveState:YES animated:NO];
        [self.formContainerView addSubview:self.createCaseButtonView];
        
        self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMinY(self.formContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.formContainerView.layer.mask = containerViewLayer;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
        
        
        //DV Temp
        //DV Note - 21 Feb 2020
        //Hide taptalk logo until user can upload their brand logo and change
        self.logoImageView.alpha = 0.0f;
        //END DV Temp
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setMessageTextViewAsActive:(BOOL)active animated:(BOOL)animated {
    [self.messageTextView setAsActive:active animated:animated];
}

- (void)adjustGrowingContentView {
    [UIView animateWithDuration:0.2f animations:^{
        self.messageTextView.frame = CGRectMake(CGRectGetMinX(self.messageTextView.frame), CGRectGetMinY(self.messageTextView.frame), CGRectGetWidth(self.messageTextView.frame), [self.messageTextView getHeight]);
        self.createCaseButtonView.frame = CGRectMake(CGRectGetMinX(self.createCaseButtonView.frame), CGRectGetMaxY(self.messageTextView.frame) + 24.0f, CGRectGetWidth(self.createCaseButtonView.frame), CGRectGetHeight(self.createCaseButtonView.frame));
        self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMinY(self.formContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.formContainerView.layer.mask = containerViewLayer;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
    }];
}

- (void)setCreateCaseButtonAsActive:(BOOL)active {
    if (active) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.createCaseButtonView setCustomButtonViewType:TTLCustomButtonViewTypeActive];
        }];
    }
    else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.createCaseButtonView setCustomButtonViewType:TTLCustomButtonViewTypeInactive];
        }];
    }
}

- (void)showUserDataForm:(BOOL)isShow {
    if (isShow) {
        [self.fullNameTextField setAsHidden:NO];
        [self.emailTextField setAsHidden:NO];
        self.fullNameTextField.frame = CGRectMake(CGRectGetMinX(self.fullNameTextField.frame), CGRectGetMinY(self.fullNameTextField.frame), CGRectGetWidth(self.fullNameTextField.frame), [self.fullNameTextField getTextFieldHeight]);
        self.emailTextField.frame = CGRectMake(CGRectGetMinX(self.emailTextField.frame), CGRectGetMaxY(self.fullNameTextField.frame) + 12.0f, CGRectGetWidth(self.emailTextField.frame), [self.emailTextField getTextFieldHeight]);
        self.topicDropDownView.frame = CGRectMake(CGRectGetMinX(self.topicDropDownView.frame), CGRectGetMaxY(self.emailTextField.frame) + 12.0f, CGRectGetWidth(self.topicDropDownView.frame), [self.topicDropDownView getTextFieldHeight]);
        self.messageTextView.frame = CGRectMake(CGRectGetMinX(self.messageTextView.frame), CGRectGetMaxY(self.topicDropDownView.frame) + 12.0f, CGRectGetWidth(self.messageTextView.frame), [self.messageTextView getHeight]);
        self.createCaseButtonView.frame = CGRectMake(CGRectGetMinX(self.createCaseButtonView.frame), CGRectGetMaxY(self.messageTextView.frame) + 24.0f, CGRectGetWidth(self.createCaseButtonView.frame), CGRectGetHeight(self.createCaseButtonView.frame));
        self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMinY(self.formContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.formContainerView.layer.mask = containerViewLayer;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
    }
    else {
        [self.fullNameTextField setAsHidden:YES];
        [self.emailTextField setAsHidden:YES];
        self.fullNameTextField.frame = CGRectMake(CGRectGetMinX(self.fullNameTextField.frame), CGRectGetMinY(self.fullNameTextField.frame), CGRectGetWidth(self.fullNameTextField.frame), 0.0f);
        self.emailTextField.frame = CGRectMake(CGRectGetMinX(self.emailTextField.frame), CGRectGetMaxY(self.fullNameTextField.frame), CGRectGetWidth(self.emailTextField.frame), 0.0f);
        self.topicDropDownView.frame = CGRectMake(CGRectGetMinX(self.topicDropDownView.frame), CGRectGetMaxY(self.emailTextField.frame), CGRectGetWidth(self.topicDropDownView.frame), [self.topicDropDownView getTextFieldHeight]);
        self.messageTextView.frame = CGRectMake(CGRectGetMinX(self.messageTextView.frame), CGRectGetMaxY(self.topicDropDownView.frame) + 12.0f, CGRectGetWidth(self.messageTextView.frame), [self.messageTextView getHeight]);
        self.createCaseButtonView.frame = CGRectMake(CGRectGetMinX(self.createCaseButtonView.frame), CGRectGetMaxY(self.messageTextView.frame) + 24.0f, CGRectGetWidth(self.createCaseButtonView.frame), CGRectGetHeight(self.createCaseButtonView.frame));
        self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMinY(self.formContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.formContainerView.layer.mask = containerViewLayer;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
    }
}

- (void)showCloseButton:(BOOL)isShow {
    if (isShow) {
        self.closeImageView.alpha = 1.0f;
        self.closeButton.alpha = 1.0f;
        self.closeButton.userInteractionEnabled = YES;
    }
    else {
        self.closeImageView.alpha = 0.0f;
        self.closeButton.alpha = 0.0f;
        self.closeButton.userInteractionEnabled = NO;
    }
}

- (void)showCreateCaseButtonAsLoading:(BOOL)loading {    
    [self.createCaseButtonView setAsLoading:loading animated:YES];
}

- (void)setCreateCaseViewType:(TTLCreateCaseViewType)createCaseViewType {
    _createCaseViewType = createCaseViewType;
    
    if (self.createCaseViewType == TTLCreateCaseViewTypeDefault) {
        CGFloat topGap = 20.0f;
        if (IS_IPHONE_X_FAMILY) {
            topGap = 44.0f;
        }
        
        self.logoImageView.frame = CGRectMake(12.0f, topGap + 16.0f, 48.0f, 48.0f);
        self.closeImageView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 24.0f, CGRectGetMinY(self.logoImageView.frame) + 12.0f, 24.0f, 24.0f);
        self.closeButton.frame = CGRectMake(CGRectGetMinX(self.closeImageView.frame) - 8.0f, CGRectGetMinY(self.closeImageView.frame) - 8.0f, 40.0f, 40.0f);
        self.closeButton.userInteractionEnabled = YES;
        self.closeButton.alpha = 1.0f;
        self.closeImageView.alpha = 1.0f;

        
        self.leftCloseImageView.frame = CGRectZero;
        self.leftCloseButton.frame = CGRectZero;
        self.leftCloseButton.userInteractionEnabled = NO;
        self.leftCloseButton.alpha = 0.0f;
        self.leftCloseImageView.alpha = 0.0f;
        
        self.titleLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(self.logoImageView.frame) + 16.0f, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Need help with anything?", nil, [TTLUtil currentBundle], @"");
        self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 4.0f, CGRectGetWidth(self.titleLabel.frame), 48.0f);
        self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMinY(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetMaxY(self.subtitleLabel.frame));
             
        self.topBackgroundView.frame = CGRectMake(CGRectGetMinX(self.topBackgroundView.frame), CGRectGetMinY(self.topBackgroundView.frame), CGRectGetWidth(self.topBackgroundView.frame), CGRectGetMaxY(self.headerView.frame) + 56.0f + topGap + 500.0f);
                     
        self.formHeaderContainerView.frame = CGRectMake(CGRectGetMinX(self.formHeaderContainerView.frame), CGRectGetMaxY(self.headerView.frame) + 24.0f, CGRectGetWidth(self.formHeaderContainerView.frame), CGRectGetHeight(self.formHeaderContainerView.frame));
        
         self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMaxY(self.formHeaderContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
         CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
         containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
         self.formContainerView.layer.mask = containerViewLayer;
        
         self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
    }
    else if (self.createCaseViewType == TTLCreateCaseViewTypeNewMessage) {
        CGFloat topGap = 20.0f;
             if (IS_IPHONE_X_FAMILY) {
                 topGap = 44.0f;
             }
        
        self.logoImageView.frame = CGRectZero;
        self.closeImageView.frame = CGRectZero;
        self.closeButton.frame = CGRectZero;
        self.closeButton.userInteractionEnabled = NO;
        self.closeButton.alpha = 0.0f;
        self.closeImageView.alpha = 0.0f;

        
        self.leftCloseImageView.frame = CGRectMake(12.0f, topGap + 16.0f, 24.0f, 24.0f);
        self.leftCloseButton.frame = CGRectMake(CGRectGetMinX(self.leftCloseImageView.frame) - 8.0f, CGRectGetMinY(self.leftCloseImageView.frame) - 8.0f, 40.0f, 40.0f);
        self.leftCloseButton.userInteractionEnabled = YES;
        self.leftCloseButton.alpha = 1.0f;
        self.leftCloseImageView.alpha = 1.0f;
        
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftCloseImageView.frame) + 12.0f, CGRectGetMinY(self.leftCloseImageView.frame) - 6.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.leftCloseImageView.frame) - 12.0f - 12.0f, CGRectGetHeight(self.titleLabel.frame));
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"New message", nil, [TTLUtil currentBundle], @"");
        
        self.subtitleLabel.frame = CGRectMake(CGRectGetMinX(self.subtitleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.subtitleLabel.frame), 0.0f);
         self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), CGRectGetMinY(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetMaxY(self.subtitleLabel.frame));
        
        self.topBackgroundView.frame = CGRectMake(CGRectGetMinX(self.topBackgroundView.frame), CGRectGetMinY(self.topBackgroundView.frame), CGRectGetWidth(self.topBackgroundView.frame), CGRectGetMaxY(self.headerView.frame) + 56.0f + topGap + 500.0f);
                     
        self.formHeaderContainerView.frame = CGRectMake(CGRectGetMinX(self.formHeaderContainerView.frame), CGRectGetMaxY(self.headerView.frame) + 24.0f, CGRectGetWidth(self.formHeaderContainerView.frame), CGRectGetHeight(self.formHeaderContainerView.frame));
        
         self.formContainerView.frame = CGRectMake(CGRectGetMinX(self.formContainerView.frame), CGRectGetMaxY(self.formHeaderContainerView.frame), CGRectGetWidth(self.formContainerView.frame), CGRectGetMaxY(self.createCaseButtonView.frame) + 16.0f);
         CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
         containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.formContainerView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
         self.formContainerView.layer.mask = containerViewLayer;
        
         self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.formContainerView.frame));
    }
}


@end
