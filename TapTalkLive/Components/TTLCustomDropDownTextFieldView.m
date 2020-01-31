//
//  TTLCustomDropDownTextFieldView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 16/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCustomDropDownTextFieldView.h"
#import "TTLStyleManager.h"

@interface TTLCustomDropDownTextFieldView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *infoDescriptionLabel;
@property (strong, nonatomic) UILabel *errorInfoLabel;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIImageView *loadingImageView;
@property (strong, nonatomic) UIButton *containerButton;

@property (nonatomic) BOOL isError;
@property (nonatomic) BOOL isActive;

- (void)setInfoDescriptionText:(NSString *)string;

@end

@implementation TTLCustomDropDownTextFieldView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIFont *formLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormLabel];
        UIColor *formLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormLabel];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 22.0f)];
        self.titleLabel.font = formLabelFont;
        self.titleLabel.textColor = formLabelColor;
        [self addSubview:self.titleLabel];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 8.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 50.0f)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
        self.containerView.layer.cornerRadius = 8.0f;
        self.containerView.layer.borderWidth = 1.0f;
        
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.containerView.frame), 50.0f)];
        self.shadowView.backgroundColor = [UIColor whiteColor];
        self.shadowView.layer.cornerRadius = 8.0f;
        self.shadowView.layer.shadowRadius = 5.0f;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.shadowView.layer.shadowOpacity = 1.0f;
        self.shadowView.layer.masksToBounds = NO;
        self.shadowView.alpha = 0.0f;
        [self addSubview:self.shadowView];
        [self addSubview:self.containerView];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.containerView.frame) - 24.0f - 16.0f, (CGRectGetHeight(self.containerView.frame) - 24.0f) / 2.0f, 24.0f, 24.0f)];
        self.arrowImageView.image = [UIImage imageNamed:@"TTLIconArrowDown" inBundle:[TTLUtil currentBundle] withConfiguration:nil];
        self.arrowImageView.clipsToBounds = YES;
        self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.arrowImageView];
        
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.containerView.frame) - 24.0f - 16.0f, (CGRectGetHeight(self.containerView.frame) - 24.0f) / 2.0f, 24.0f, 24.0f)];
        self.loadingImageView.image = [UIImage imageNamed:@"TTLIconLoaderProgress" inBundle:[TTLUtil currentBundle] withConfiguration:nil];
        self.loadingImageView.clipsToBounds = YES;
        self.loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.loadingImageView.alpha = 0.0f;
        [self.containerView addSubview:self.loadingImageView];
         
        UIFont *textFieldFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormTextField];
        UIColor *textFieldColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormTextField];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(self.arrowImageView.frame) - 16.0f - 16.0f, CGRectGetHeight(self.containerView.frame))];
        self.textField.delegate = self;
        [self.textField setTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldCursor]];
        self.textField.textColor = textFieldColor;
        self.textField.font = textFieldFont;
        self.textField.userInteractionEnabled = NO;
        [self.containerView addSubview:self.textField];

        UIFont *formDescriptionLabelBodyFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormDescriptionLabel];
        UIColor *formDescriptionLabelBodyColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormDescriptionLabel];
        _infoDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.containerView.frame) + 8.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 0.0f)];
        self.infoDescriptionLabel.font = formDescriptionLabelBodyFont;
        self.infoDescriptionLabel.textColor = formDescriptionLabelBodyColor;
        self.infoDescriptionLabel.numberOfLines = 0;
        [self addSubview:self.infoDescriptionLabel];

        UIFont *formErrorInfoLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormErrorInfoLabel];
        UIColor *formErrorInfoLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormErrorInfoLabel];
        _errorInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.infoDescriptionLabel.frame) + 8.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 0.0f)];
        self.errorInfoLabel.font = formErrorInfoLabelFont;
        self.errorInfoLabel.textColor = formErrorInfoLabelColor;
        self.errorInfoLabel.numberOfLines = 0;
        [self addSubview:self.errorInfoLabel];
        
        _containerButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
        [self.containerButton addTarget:self action:@selector(containerButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.containerButton];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setTtlCustomDropDownTextFieldViewType:(TTLCustomDropDownTextFieldViewType)ttlCustomDropDownTextFieldViewType {
    _ttlCustomDropDownTextFieldViewType = ttlCustomDropDownTextFieldViewType;
    if (ttlCustomDropDownTextFieldViewType == TTLCustomDropDownTextFieldViewTypeTopic) {
        self.titleLabel.text = NSLocalizedString(@"Topic", @"");
        self.textField.placeholder = NSLocalizedString(@"Select topic", @"");
        self.containerView.alpha = 1.0f;
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
    }
}

- (void)setInfoDescriptionText:(NSString *)string {
    self.infoDescriptionLabel.text = string;
    
    CGFloat ySpacing = 8.0f;
    if ([string isEqualToString:@""] || string ==  nil) {
        ySpacing = 0.0f;
    }
    
    CGSize size = [self.infoDescriptionLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.infoDescriptionLabel.frame), CGFLOAT_MAX)];
    self.infoDescriptionLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.containerView.frame) + ySpacing, CGRectGetWidth(self.infoDescriptionLabel.frame), size.height);
    
    CGFloat errorInfoYSpacing = 8.0f;
    if ([self.errorInfoLabel.text isEqualToString:@""] || self.errorInfoLabel.text ==  nil) {
        errorInfoYSpacing = 0.0f;
    }
    self.errorInfoLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.infoDescriptionLabel.frame) + errorInfoYSpacing, CGRectGetWidth(self.errorInfoLabel.frame), CGRectGetHeight(self.errorInfoLabel.frame));
}

- (void)setErrorInfoText:(NSString *)string {
    self.errorInfoLabel.text = string;
    
    CGFloat ySpacing = 8.0f;
    if ([string isEqualToString:@""] || string ==  nil) {
        ySpacing = 0.0f;
    }
    
    CGSize size = [self.errorInfoLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.errorInfoLabel.frame), CGFLOAT_MAX)];
    self.errorInfoLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.infoDescriptionLabel.frame) + ySpacing, CGRectGetWidth(self.errorInfoLabel.frame), size.height);
}

- (CGFloat)getTextFieldHeight {
    return CGRectGetMaxY(self.errorInfoLabel.frame);
}

- (void)setAsActive:(BOOL)active animated:(BOOL)animated {
    
    _isActive = active;
    
    if (self.isError) {
        return;
    }
    
    if (animated) {
        if (active) {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 1.0f;
                self.shadowView.layer.shadowColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive].CGColor;
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
            }];
        }
    }
    else {
        if (active) {
            self.shadowView.alpha = 1.0f;
            self.shadowView.layer.shadowColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive].CGColor;
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
        }
    }
}

- (void)setAsEnabled:(BOOL)enabled {
    
    UIColor *textFieldColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormTextField];
    UIColor *textFieldPlaceholderColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormTextFieldPlaceholder];
    
    if (enabled) {
        self.textField.textColor = textFieldColor;
        self.textField.userInteractionEnabled = YES;
    }
    else {
        self.textField.textColor = textFieldPlaceholderColor;
        self.textField.userInteractionEnabled = NO;
    }
}

- (void)setAsError:(BOOL)error animated:(BOOL)animated {
    _isError = error;
    
    if (self.isActive && !error) {
        [self setAsActive:YES animated:animated];
        return;
    }
    
    if (animated) {
        if (error) {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderError].CGColor;
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
                
            }];
        }
    }
    else {
        if (error) {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderError].CGColor;
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
        }
    }
}

- (void)setAsFilled:(BOOL)isFilled {
    if (isFilled) {
        self.textField.placeholder = NSLocalizedString(@"", @"");
    }
    else {
        self.textField.placeholder = NSLocalizedString(@"Select topic", @"");
    }
}

- (void)setTextFieldWithData:(NSString *)dataString {
    [self setAsFilled:YES];
    self.textField.text = dataString;
}

- (void)setAsLoading:(BOOL)loading animated:(BOOL)animated {
    if (loading) {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                self.loadingImageView.alpha = 1.0f;
                self.arrowImageView.alpha = 0.0f;
                self.containerButton.userInteractionEnabled = NO;
            }];
            
            //ADD ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] == nil) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                animation.fromValue = [NSNumber numberWithFloat:0.0f];
                animation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
                animation.duration = 1.5f;
                animation.repeatCount = INFINITY;
                animation.cumulative = YES;
                animation.removedOnCompletion = NO;
                [self.loadingImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
            }
        }
        else {
            self.loadingImageView.alpha = 1.0f;
            self.arrowImageView.alpha = 0.0f;
            self.containerButton.userInteractionEnabled = NO;
            
            //ADD ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] == nil) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                animation.fromValue = [NSNumber numberWithFloat:0.0f];
                animation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
                animation.duration = 1.5f;
                animation.repeatCount = INFINITY;
                animation.cumulative = YES;
                animation.removedOnCompletion = NO;
                [self.loadingImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
            }
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                self.loadingImageView.alpha = 0.0f;
                self.arrowImageView.alpha = 1.0f;
                self.containerButton.userInteractionEnabled = YES;
            }];
            
            //REMOVE ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.loadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
        else {
            self.loadingImageView.alpha = 0.0f;
            self.arrowImageView.alpha = 1.0f;
            self.containerButton.userInteractionEnabled = YES;

            //REMOVE ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.loadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
    }
}

- (NSString *)getText {
    return self.textField.text;
}

- (void)containerButtonDidTapped {
    if ([self.delegate respondsToSelector:@selector(customDropDownTextFieldViewDidTapped)]) {
        [self.delegate customDropDownTextFieldViewDidTapped];
    }
}

@end
