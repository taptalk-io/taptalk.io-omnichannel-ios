//
//  TTLCustomButtonView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCustomButtonView.h"

@interface TTLCustomButtonView ()

@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *buttonContainerView;
@property (strong, nonatomic) UILabel *buttonTitleLabel;
@property (strong, nonatomic) UIImageView *buttonLoadingImageView;
@property (strong, nonatomic) UIImageView *buttonIconImageView;

- (void)buttonDidTapped;

@end

@implementation TTLCustomButtonView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame))];
        self.shadowView.backgroundColor = [UIColor whiteColor];
        self.shadowView.layer.cornerRadius = 8.0f;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        self.shadowView.layer.shadowOpacity = 1.0f;
        self.shadowView.layer.masksToBounds = NO;
        [self addSubview:self.shadowView];
        
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame))];
        self.buttonContainerView.backgroundColor = [UIColor clearColor];
        self.buttonContainerView.clipsToBounds = YES;
        self.buttonContainerView.layer.cornerRadius = 8.0f;
        self.buttonContainerView.layer.borderWidth = 1.0f;
        [self addSubview:self.buttonContainerView];
        
        _buttonIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        TTLImage *buttonIconImage = self.buttonIconImageView.image;
        buttonIconImage = [buttonIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        self.buttonIconImageView.image = buttonIconImage;
        [self.buttonContainerView addSubview:self.buttonIconImageView];
        
        UIFont *buttonFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontButtonLabel];
        UIColor *buttonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorButtonLabel];
        _buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.buttonContainerView.frame), CGRectGetHeight(self.buttonContainerView.frame))];
        self.buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonTitleLabel.font = buttonFont;
        self.buttonTitleLabel.textColor = buttonColor;
        [self.buttonContainerView addSubview:self.buttonTitleLabel];
        
        _button = [[UIButton alloc] initWithFrame:self.buttonContainerView.frame];
        [self.button addTarget:self action:@selector(buttonDidTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        _buttonLoadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.buttonContainerView.frame) - 20.0f) / 2.0f, (CGRectGetHeight(self.buttonContainerView.frame) - 20.0f) / 2.0f, 20.0f, 20.0f)];
        self.buttonLoadingImageView.alpha = 0.0f;
        [self.buttonLoadingImageView setImage:[UIImage imageNamed:@"TTLIconLoaderProgress" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil]];
        TTLImage *buttonLoadingImage = self.buttonLoadingImageView.image;
        buttonLoadingImage = [buttonLoadingImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconLoadingProgressWhite]];
        self.buttonLoadingImageView.image = buttonLoadingImage;
        [self.buttonContainerView addSubview:self.buttonLoadingImageView];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setCustomButtonViewType:(TTLCustomButtonViewType)customButtonViewType {
    _customButtonViewType = customButtonViewType;
    
    if (self.customButtonViewType == TTLCustomButtonViewTypeActive) {
        if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypePlain || self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
            //orange gradient background
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.buttonContainerView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientDark].CGColor, nil];
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            [self.buttonContainerView.layer insertSublayer:gradient atIndex:0];
            
            self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder].CGColor;
            self.button.userInteractionEnabled = YES;
            
            if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
                self.shadowView.layer.shadowColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
            }
            else {
                UIColor *shadowColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder];
                self.shadowView.layer.shadowColor = [shadowColor colorWithAlphaComponent:0.5f].CGColor;
            }
            self.shadowView.alpha = 1.0f;
        }
        else {
            //destructive type, no button background
            self.buttonContainerView.layer.borderColor = [UIColor clearColor].CGColor;
            self.button.userInteractionEnabled = YES;
            self.shadowView.layer.shadowColor = [UIColor clearColor].CGColor;
            self.shadowView.alpha = 0.0f;
        }
    }
    else if (self.customButtonViewType == TTLCustomButtonViewTypeInactive) {
        if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypePlain || self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
            //grey gradient background
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.buttonContainerView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientDark].CGColor, nil];
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            [self.buttonContainerView.layer insertSublayer:gradient atIndex:0];
            
            self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
            self.button.userInteractionEnabled = NO;
            
            self.shadowView.layer.shadowColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
            self.shadowView.alpha = 1.0f;
        }
        else {
            //destructive type, no button background
            self.buttonContainerView.layer.borderColor = [UIColor clearColor].CGColor;
            self.button.userInteractionEnabled = NO;
            self.shadowView.layer.shadowColor = [UIColor clearColor].CGColor;
            self.shadowView.alpha = 0.0f;
        }
        
    }
}

- (void)setCustomButtonViewStyleType:(TTLCustomButtonViewStyleType)customButtonViewStyleType {
    _customButtonViewStyleType = customButtonViewStyleType;
    if (customButtonViewStyleType == TTLCustomButtonViewStyleTypePlain) {
        self.buttonIconImageView.alpha = 0.0f;
        //Left and Right gap is 16.0f
        self.shadowView.frame =  CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame));
        self.buttonContainerView.frame = CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame));
        self.buttonTitleLabel.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.buttonContainerView.frame), CGRectGetHeight(self.buttonContainerView.frame));
        self.button.frame = self.buttonContainerView.frame;
        self.buttonLoadingImageView.frame = CGRectMake((CGRectGetWidth(self.buttonContainerView.frame) - 20.0f) / 2.0f, (CGRectGetHeight(self.buttonContainerView.frame) - 20.0f) / 2.0f, 20.0f, 20.0f);
    }
    else if (customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
        self.buttonIconImageView.alpha = 1.0f;
        //Left and Right gap is 10.0f
        self.shadowView.frame =  CGRectMake(10.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f - 10.0f, CGRectGetHeight(self.frame));
        self.buttonContainerView.frame = CGRectMake(10.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f - 10.0f, CGRectGetHeight(self.frame));
        self.buttonTitleLabel.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.buttonContainerView.frame), CGRectGetHeight(self.buttonContainerView.frame));
        self.button.frame = self.buttonContainerView.frame;
        self.buttonLoadingImageView.frame = CGRectMake((CGRectGetWidth(self.buttonContainerView.frame) - 20.0f) / 2.0f, (CGRectGetHeight(self.buttonContainerView.frame) - 20.0f) / 2.0f, 20.0f, 20.0f);
        
        //Set icon tint color
        TTLImage *buttonIconImage = self.buttonIconImageView.image;
        buttonIconImage = [buttonIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIcon]];
        self.buttonIconImageView.image = buttonIconImage;
    }
    else if (customButtonViewStyleType == TTLCustomButtonViewStyleTypeDestructivePlain) {
        self.buttonIconImageView.alpha = 0.0f;
        //Left and Right gap is 16.0f
        self.shadowView.frame =  CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame));
        self.buttonContainerView.frame = CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, CGRectGetHeight(self.frame));
        self.buttonTitleLabel.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.buttonContainerView.frame), CGRectGetHeight(self.buttonContainerView.frame));
        self.button.frame = self.buttonContainerView.frame;
        self.buttonLoadingImageView.frame = CGRectMake((CGRectGetWidth(self.buttonContainerView.frame) - 20.0f) / 2.0f, (CGRectGetHeight(self.buttonContainerView.frame) - 20.0f) / 2.0f, 20.0f, 20.0f);
        UIColor *clickableDestructiveButtonLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorClickableDestructiveLabel];
        self.buttonTitleLabel.textColor = clickableDestructiveButtonLabelColor;
    }
    else if (customButtonViewStyleType == TTLCustomButtonViewStyleTypeDestructiveWithIcon) {
        self.buttonIconImageView.alpha = 1.0f;
        //Left and Right gap is 10.0f
        self.shadowView.frame =  CGRectMake(10.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f - 10.0f, CGRectGetHeight(self.frame));
        self.buttonContainerView.frame = CGRectMake(10.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f - 10.0f, CGRectGetHeight(self.frame));
        self.buttonTitleLabel.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.buttonContainerView.frame), CGRectGetHeight(self.buttonContainerView.frame));
        self.button.frame = self.buttonContainerView.frame;
        self.buttonLoadingImageView.frame = CGRectMake((CGRectGetWidth(self.buttonContainerView.frame) - 20.0f) / 2.0f, (CGRectGetHeight(self.buttonContainerView.frame) - 20.0f) / 2.0f, 20.0f, 20.0f);
        UIColor *clickableDestructiveButtonLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorClickableDestructiveLabel];
        self.buttonTitleLabel.textColor = clickableDestructiveButtonLabelColor;
        
        //Set icon tint color
        TTLImage *buttonIconImage = self.buttonIconImageView.image;
        buttonIconImage = [buttonIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonIconDestructive]];
        self.buttonIconImageView.image = buttonIconImage;
    }
}

- (void)setAsActiveState:(BOOL)active animated:(BOOL)animated {
    if (animated) {
        if (active) {
            [UIView animateWithDuration:0.2f animations:^{
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = self.buttonContainerView.bounds;
                gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientDark].CGColor, nil];
                gradient.startPoint = CGPointMake(0.0f, 0.0f);
                gradient.endPoint = CGPointMake(0.0f, 1.0f);
                [self.buttonContainerView.layer replaceSublayer:[self.buttonContainerView.layer.sublayers objectAtIndex:0] with:gradient];
                
                self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder].CGColor;
                self.button.userInteractionEnabled = YES;
                
                self.shadowView.layer.shadowColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder] colorWithAlphaComponent:0.5f].CGColor;            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = self.buttonContainerView.bounds;
                gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientDark].CGColor, nil];
                gradient.startPoint = CGPointMake(0.0f, 0.0f);
                gradient.endPoint = CGPointMake(0.0f, 1.0f);
                [self.buttonContainerView.layer replaceSublayer:[self.buttonContainerView.layer.sublayers objectAtIndex:0] with:gradient];
                
                self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
                self.button.userInteractionEnabled = NO;
                
                self.shadowView.layer.shadowColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
            }];
        }
    }
    else {
        if (active) {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.buttonContainerView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientDark].CGColor, nil];
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            [self.buttonContainerView.layer replaceSublayer:[self.buttonContainerView.layer.sublayers objectAtIndex:0] with:gradient];
            
            self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder].CGColor;
            self.button.userInteractionEnabled = YES;
            
            self.shadowView.layer.shadowColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder] colorWithAlphaComponent:0.5f].CGColor;
        }
        else {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.buttonContainerView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientDark].CGColor, nil];
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            [self.buttonContainerView.layer replaceSublayer:[self.buttonContainerView.layer.sublayers objectAtIndex:0] with:gradient];
            
            self.buttonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
            self.button.userInteractionEnabled = NO;
            
            self.shadowView.layer.shadowColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBorder].CGColor;
        }
    }
}

- (void)setButtonWithTitle:(NSString *)title {
    self.buttonTitleLabel.text = title;
}

- (void)setButtonWithTitle:(NSString *)title andIcon:(NSString *)imageName iconPosition:(TTLCustomButtonViewIconPosititon)ttlCustomButtonViewIconPosititon {
    self.buttonTitleLabel.text = title;
    self.buttonIconImageView.image = [UIImage imageNamed:imageName inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    
    CGSize size = [self.buttonTitleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20.0f)];
    CGFloat maximumLabelWidth = CGRectGetWidth(self.frame) - 10.0f - 10.0f - 4.0f - 32.0f; //10 - left&right gap, 4 - gap to image view, 32 image view width
    CGFloat newWidth = size.width;
    if (newWidth > maximumLabelWidth) {
        newWidth = maximumLabelWidth;
    }
    CGFloat newMinX = (CGRectGetWidth(self.buttonContainerView.frame) - (newWidth + 4.0f + 32.0f))/2.0f;
    
    if (ttlCustomButtonViewIconPosititon == TTLCustomButtonViewIconPosititonLeft) {
        self.buttonIconImageView.frame = CGRectMake(newMinX, 5.0f, 32.0f, CGRectGetHeight(self.buttonIconImageView.frame));
        self.buttonTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.buttonIconImageView.frame) + 4.0f, CGRectGetMinY(self.buttonTitleLabel.frame), newWidth, CGRectGetHeight(self.buttonTitleLabel.frame));
    }
    else {
        self.buttonTitleLabel.frame = CGRectMake(newMinX, CGRectGetMinY(self.buttonTitleLabel.frame), newWidth, CGRectGetHeight(self.buttonTitleLabel.frame));
        self.buttonIconImageView.frame = CGRectMake(CGRectGetMaxX(self.buttonTitleLabel.frame) + 4.0f, 5.0f, 32.0f, CGRectGetHeight(self.buttonIconImageView.frame));
    }
}

- (void)setAsLoading:(BOOL)loading animated:(BOOL)animated {
    if (loading) {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                self.buttonLoadingImageView.alpha = 1.0f;
                self.buttonTitleLabel.alpha = 0.0f;
                
                if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
                    self.buttonIconImageView.alpha = 0.0f;
                }
                
                self.button.userInteractionEnabled = NO;
            }];
            
            //ADD ANIMATION
            if ([self.buttonLoadingImageView.layer animationForKey:@"SpinAnimation"] == nil) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                animation.fromValue = [NSNumber numberWithFloat:0.0f];
                animation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
                animation.duration = 1.5f;
                animation.repeatCount = INFINITY;
                animation.cumulative = YES;
                animation.removedOnCompletion = NO;
                [self.buttonLoadingImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
            }
        }
        else {
            self.buttonLoadingImageView.alpha = 1.0f;
            self.buttonTitleLabel.alpha = 0.0f;
            if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
                self.buttonIconImageView.alpha = 0.0f;
            }
            self.button.userInteractionEnabled = NO;
            
            //ADD ANIMATION
            if ([self.buttonLoadingImageView.layer animationForKey:@"SpinAnimation"] == nil) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                animation.fromValue = [NSNumber numberWithFloat:0.0f];
                animation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
                animation.duration = 1.5f;
                animation.repeatCount = INFINITY;
                animation.cumulative = YES;
                animation.removedOnCompletion = NO;
                [self.buttonLoadingImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
            }
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                self.buttonLoadingImageView.alpha = 0.0f;
                self.buttonTitleLabel.alpha = 1.0f;
                self.button.userInteractionEnabled = YES;
                
                if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
                    self.buttonIconImageView.alpha = 1.0f;
                }

            }];
            
            //REMOVE ANIMATION
            if ([self.buttonLoadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.buttonLoadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
        else {
            self.buttonLoadingImageView.alpha = 0.0f;
            self.buttonTitleLabel.alpha = 1.0f;
            
            if (self.customButtonViewStyleType == TTLCustomButtonViewStyleTypeWithIcon) {
                self.buttonIconImageView.alpha = 1.0f;
            }
            
            self.button.userInteractionEnabled = YES;

            
            //REMOVE ANIMATION
            if ([self.buttonLoadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.buttonLoadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
    }
}

- (void)buttonDidTapped {
    if ([self.delegate respondsToSelector:@selector(customButtonViewDidTappedButton)]) {
        [self.delegate customButtonViewDidTappedButton];
    }
}

- (void)setButtonIconTintColor:(UIColor *)color {
    TTLImage *buttonIconImage = self.buttonIconImageView.image;
    buttonIconImage = [buttonIconImage setImageTintColor:color];
    self.buttonIconImageView.image = buttonIconImage;
}

@end

