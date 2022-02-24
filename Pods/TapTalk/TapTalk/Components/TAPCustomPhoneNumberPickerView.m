//
//  TAPCustomPhoneNumberPickerView.m
//  TapTalk
//
//  Created by Dominic Vedericho on 01/04/19.
//  Copyright © 2019 Moselo. All rights reserved.
//

#import "TAPCustomPhoneNumberPickerView.h"

@interface TAPCustomPhoneNumberPickerView () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *countryCodeContainerView;
@property (strong, nonatomic) TAPImageView *countryFlagImageView;
@property (strong, nonatomic) UILabel *countryCodeLabel;
@property (strong, nonatomic) UIImageView *loadingImageView;

@property (strong, nonatomic) UIView *phoneNumberContainerView;
@property (strong, nonatomic) UIView *shadowView;

- (void)doneKeyboardButtonDidTapped;

@end

@implementation TAPCustomPhoneNumberPickerView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _countryCodeContainerView = [[UIView alloc] initWithFrame:CGRectMake(16.0f, 0.0f, 106.0f, 50.0f)];
        self.countryCodeContainerView.layer.cornerRadius = 8.0f;
        self.countryCodeContainerView.layer.borderWidth = 1.0f;
        self.countryCodeContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
        self.countryCodeContainerView.clipsToBounds = YES;
        self.countryCodeContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.countryCodeContainerView];
        
        _countryFlagImageView = [[TAPImageView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 28.0f, 20.0f)];
        self.countryFlagImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.countryCodeContainerView addSubview:self.countryFlagImageView];
        
        UIFont *countryCodeFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormTextFieldPlaceholder];
        UIColor *countryCodeColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormTextFieldPlaceholder];
        CGFloat countryCodeWidth = CGRectGetWidth(self.countryCodeContainerView.frame) - CGRectGetMaxX(self.countryFlagImageView.frame) - 10.0f - 15.0f;
        _countryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryFlagImageView.frame) + 10.0f, CGRectGetMinY(self.countryFlagImageView.frame) - 1.0f, countryCodeWidth, 20.0f)];
        self.countryCodeLabel.textColor = countryCodeColor;
        self.countryCodeLabel.font = countryCodeFont;
        [self.countryCodeContainerView addSubview:self.countryCodeLabel];
        
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryFlagImageView.frame) + 16.0f, CGRectGetMinY(self.countryFlagImageView.frame), 20.0f, 20.0f)];
        self.loadingImageView.alpha = 0.0f;
        [self.loadingImageView setImage:[UIImage imageNamed:@"TAPIconLoaderProgress" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.loadingImageView.image = [self.loadingImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconLoadingProgressPrimary]];
        [self.countryCodeContainerView addSubview:self.loadingImageView];
        
        CGFloat phoneNumberContainerViewWidth = CGRectGetWidth(self.frame) - 16.0f - 16.0f - 10.0f - CGRectGetWidth(self.countryCodeContainerView.frame);
        
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryCodeContainerView.frame) + 10.0f, CGRectGetMinY(self.countryCodeContainerView.frame), phoneNumberContainerViewWidth, 50.0f)];
        self.shadowView.backgroundColor = [UIColor whiteColor];
        self.shadowView.layer.cornerRadius = 8.0f;
        self.shadowView.layer.shadowRadius = 5.0f;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.shadowView.layer.shadowOpacity = 1.0f;
        self.shadowView.layer.masksToBounds = NO;
        self.shadowView.alpha = 0.0f;
//        [self addSubview:self.shadowView];
        
        _phoneNumberContainerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryCodeContainerView.frame) + 10.0f, CGRectGetMinY(self.countryCodeContainerView.frame), phoneNumberContainerViewWidth, 50.0f)];
        self.phoneNumberContainerView.layer.cornerRadius = 8.0f;
        self.phoneNumberContainerView.layer.borderWidth = 1.0f;
        self.phoneNumberContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
        self.phoneNumberContainerView.backgroundColor = [UIColor whiteColor];
        self.phoneNumberContainerView.clipsToBounds = YES;
        [self addSubview:self.phoneNumberContainerView];
        
        UIFont *textFieldFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormTextField];
        UIColor *textFieldColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormTextField];
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.phoneNumberContainerView.frame) - 16.0f - 16.0f, CGRectGetHeight(self.phoneNumberContainerView.frame))];
        self.phoneNumberTextField.delegate = self;
        self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
        self.phoneNumberTextField.placeholder = @"12345678910";
        [self.phoneNumberTextField setTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldCursor]];
        self.phoneNumberTextField.textColor = textFieldColor;
        self.phoneNumberTextField.font = textFieldFont;
        [self.phoneNumberContainerView addSubview:self.phoneNumberTextField];
        
        _keyboardAccessoryView = [[TAPNumericKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f)];
        NSString *keyboardString = NSLocalizedStringFromTableInBundle(@"DONE", nil, [TAPUtil currentBundle], @"");
        [self.keyboardAccessoryView setHeaderNumericKeyboardButtonTitleWithText:keyboardString];
        self.phoneNumberTextField.inputAccessoryView = self.keyboardAccessoryView;
        
        _pickerButton = [[UIButton alloc] initWithFrame:self.countryCodeContainerView.frame];
        [self addSubview:self.pickerButton];
        
        [self.keyboardAccessoryView.doneKeyboardButton addTarget:self action:@selector(doneKeyboardButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

#pragma mark - Delegate
#pragma mark UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate customPhoneNumberPickerViewTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if (![TAPUtil validateAllNumber:string]) {
        //REMOVE NON-NUMBER CHARACTER
        NSString *numberString = [[string componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        NSString *currentString = textField.text;
        currentString = [currentString stringByReplacingCharactersInRange:range withString:numberString];
        
        self.phoneNumberTextField.text = currentString;

        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldShouldReturn:)]) {
        return [self.delegate customPhoneNumberPickerViewTextFieldShouldReturn:textField];
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self setAsActive:YES animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldShouldBeginEditing:)]) {
        return [self.delegate customPhoneNumberPickerViewTextFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldDidBeginEditing:)]) {
        [self.delegate customPhoneNumberPickerViewTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self setAsActive:NO animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldShouldEndEditing:)]) {
        return [self.delegate customPhoneNumberPickerViewTextFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldDidEndEditing:)]) {
        [self.delegate customPhoneNumberPickerViewTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewTextFieldShouldClear:)]) {
         return [self.delegate customPhoneNumberPickerViewTextFieldShouldClear:textField];
    }
    
    return YES;
}

#pragma mark - Custom Method
- (void)showLoading:(BOOL)isLoading animated:(BOOL)animated {
    if (isLoading) {
        if (animated) {
            [UIView animateWithDuration:0.2f animations:^{
                self.loadingImageView.alpha = 1.0f;
                self.countryCodeLabel.alpha = 0.0f;
                self.pickerButton.userInteractionEnabled = NO;
                self.phoneNumberTextField.userInteractionEnabled = NO;
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
            self.countryCodeLabel.alpha = 0.0f;
            self.pickerButton.userInteractionEnabled = NO;
            self.phoneNumberTextField.userInteractionEnabled = NO;
            
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
                self.countryCodeLabel.alpha = 1.0f;
                self.pickerButton.userInteractionEnabled = YES;
                self.phoneNumberTextField.userInteractionEnabled = YES;
            }];
            
            //REMOVE ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.loadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
        else {
            self.loadingImageView.alpha = 0.0f;
            self.countryCodeLabel.alpha = 1.0f;
            self.pickerButton.userInteractionEnabled = YES;
            self.phoneNumberTextField.userInteractionEnabled = YES;
            
            //REMOVE ANIMATION
            if ([self.loadingImageView.layer animationForKey:@"SpinAnimation"] != nil) {
                [self.loadingImageView.layer removeAnimationForKey:@"SpinAnimation"];
            }
        }
    }
}

- (void)setAsActive:(BOOL)active animated:(BOOL)animated {
    if (animated) {
        if (active) {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 1.0f;
                self.shadowView.layer.shadowColor = [[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
                self.phoneNumberContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive].CGColor;
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.phoneNumberContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
            }];
        }
    }
    else {
        if (active) {
            self.shadowView.alpha = 1.0f;
            self.shadowView.layer.shadowColor = [[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
            self.phoneNumberContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive].CGColor;
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.phoneNumberContainerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
        }
    }
}

- (void)setCountryCodePhoneNumberWithData:(TAPCountryModel *)countryData {

    NSString *countryCodeNumber = countryData.countryCallingCode;
    NSString *countryFlagImageURL = countryData.flagIconURL;
    
    NSString *formattedCountryCodeNumber = @"";
    if (![countryCodeNumber isEqualToString:@""] && countryCodeNumber != nil) {
        formattedCountryCodeNumber = [NSString stringWithFormat:@"+%@", countryCodeNumber];
    }
    else {
        formattedCountryCodeNumber = @"-";
    }
    
    if (countryFlagImageURL == nil || [countryFlagImageURL isEqualToString:@""]) {
        //CS TEMP - set default country to Indonesia
        if ([countryCodeNumber isEqualToString:@"62"]) {
            [self.countryFlagImageView setImage:[UIImage imageNamed:@"TAPIconFlagIndonesia" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        }
        //END CS TEMP - set default country to Indonesia
        else {
             [self.countryFlagImageView setImage:[UIImage imageNamed:@"TAPDefaultCountryFlag" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        }
    }
    else {
        [self.countryFlagImageView setImageWithURLString:countryFlagImageURL];
    }
    
    self.countryCodeLabel.text = formattedCountryCodeNumber;
}

- (void)doneKeyboardButtonDidTapped {
    if ([self.delegate respondsToSelector:@selector(customPhoneNumberPickerViewDidTappedDoneKeyboardButton)]) {
        [self.delegate customPhoneNumberPickerViewDidTappedDoneKeyboardButton];
    }
}

- (void)setAsDisabled:(BOOL)disabled {
    
    UIFont *textFieldFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormTextField];
    UIColor *textFieldColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormTextField];
    
    UIFont *textFieldPlaceholderFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormTextFieldPlaceholder];
    UIColor *textFieldPlaceholderColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormTextFieldPlaceholder];
    
    //AS NOTE - ADDED FOR DEFAULT COLOR `countryCodeContainerView`
    self.countryCodeContainerView.backgroundColor = [UIColor whiteColor];
    self.countryCodeLabel.alpha = 1.0f;
    
    //AS NOTE - ADDED FOR DEFAULT COLOR `phoneNumberContainerView`
    self.phoneNumberContainerView.backgroundColor = [UIColor whiteColor];
    self.phoneNumberTextField.alpha = 1.0f;
    
    if (disabled) {
        self.pickerButton.userInteractionEnabled = NO;
        self.phoneNumberTextField.userInteractionEnabled = NO;
        
        //AS NOTE - CHANGE FOR DISABLED COLOR `countryCodeContainerView`
        UIColor *countryCodeContainerViewBackgroundColor = [[TAPUtil getColor:TAP_COLOR_TEXT_DARK] colorWithAlphaComponent:0.1f]; //AS TEMP
        self.countryCodeContainerView.backgroundColor = countryCodeContainerViewBackgroundColor; //AS TEMP
        self.countryCodeLabel.alpha = 0.4f; //AS TEMP
        self.countryCodeLabel.textColor = textFieldPlaceholderColor;
        
        //AS NOTE - CHANGE FOR DISABLED COLOR `phoneNumberContainerView`
        UIColor *phoneNumberContainerViewBackgroundColor = [[TAPUtil getColor:TAP_COLOR_TEXT_DARK] colorWithAlphaComponent:0.1f]; //AS TEMP
        self.phoneNumberContainerView.backgroundColor = phoneNumberContainerViewBackgroundColor; //AS TEMP
        self.phoneNumberTextField.alpha = 0.4f; //AS TEMP
        self.phoneNumberTextField.textColor = textFieldColor; //AS TEMP - CHANGE DISABLED COLOR OF TEXTFIELD
    }
    else {
        self.pickerButton.userInteractionEnabled = YES;
        self.phoneNumberTextField.userInteractionEnabled = YES;
        self.countryCodeLabel.textColor = textFieldColor;
        self.phoneNumberTextField.textColor = textFieldColor;
    }
}

@end
