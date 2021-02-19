//
//  TTLCustomTextFieldView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCustomTextFieldView.h"

@interface TTLCustomTextFieldView () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *infoDescriptionLabel;
@property (strong, nonatomic) UILabel *errorInfoLabel;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *containerSeparatorView;

@property (strong, nonatomic) UIImageView *passwordShowImageView;

@property (strong, nonatomic) UIButton *showPasswordButton;

@property (nonatomic) BOOL isError;
@property (nonatomic) BOOL isActive;

- (void)setInfoDescriptionText:(NSString *)string;
- (void)showPasswordButtonDidTapped;
- (void)showShowPasswordButton:(BOOL)show;

@end

@implementation TTLCustomTextFieldView
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
        
        _containerSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.containerView.frame) - 50.0f, 0.0f, 1.0f, CGRectGetHeight(self.containerView.frame))];
        self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
        [self.containerView addSubview:self.containerSeparatorView];
        
        _passwordShowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.containerSeparatorView.frame) + 15.0f, 15.0f, 20.0f, 20.0f)];
        self.passwordShowImageView.image = [UIImage imageNamed:@"TTLIconShowPassword" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        TTLImage *passwordShowImage = (TTLImage *) self.passwordShowImageView.image;
        passwordShowImage = (TTLImage *) [passwordShowImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconViewPasswordInactive]];
        self.passwordShowImageView.image = passwordShowImage;
        [self.containerView addSubview:self.passwordShowImageView];
        
        _showPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.containerSeparatorView.frame), 0.0f, 50.0f, 50.0f)];
        [self.showPasswordButton addTarget:self action:@selector(showPasswordButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.showPasswordButton];
        
        UIFont *textFieldFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormTextField];
        UIColor *textFieldColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFormTextField];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.containerView.frame) - 16.0f - 16.0f, CGRectGetHeight(self.containerView.frame))];
        self.textField.delegate = self;
        [self.textField setTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldCursor]];
        self.textField.textColor = textFieldColor;
        self.textField.font = textFieldFont;
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
                
    }
    
    return self;
}

#pragma mark - Delegate
#pragma mark UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate customTextFieldViewTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldShouldReturn:)]) {
        return [self.delegate customTextFieldViewTextFieldShouldReturn:textField];
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self setAsActive:YES animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldShouldBeginEditing:)]) {
        return [self.delegate customTextFieldViewTextFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldDidBeginEditing:)]) {
        [self.delegate customTextFieldViewTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self setAsActive:NO animated:YES];

    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldShouldEndEditing:)]) {
        return [self.delegate customTextFieldViewTextFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldDidEndEditing:)]) {
        [self.delegate customTextFieldViewTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(customTextFieldViewTextFieldShouldClear:)]) {
        return [self.delegate customTextFieldViewTextFieldShouldClear:textField];
    }
    
    return YES;
}

#pragma mark - Custom Method
- (void)setTtlCustomTextFieldViewType:(TTLCustomTextFieldViewType)ttlCustomTextFieldViewType {
    _ttlCustomTextFieldViewType = ttlCustomTextFieldViewType;
    if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeFullName) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Full Name", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Full Name", nil, [TTLUtil currentBundle], @"");
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeUsername) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Username", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:NSLocalizedStringFromTableInBundle(@"Username is always required.\nMust be between 4-32 characters.\nCan only contain a-z, 0-9, underscores, and dot.\nCan't start with number or underscore or dot.\nCan't end with underscore or dot.\nCan't contain consecutive underscores, consecutive dot, underscore followed with dot, and otherwise.", nil, [TTLUtil currentBundle], @"")];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Enter username", nil, [TTLUtil currentBundle], @"");
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeUsernameWithoutDescription) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Username", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Enter username", nil, [TTLUtil currentBundle], @"");
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeEmailOptional) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Email Address Optional", nil, [TTLUtil currentBundle], @"");
        
        UIFont *formDescriptionFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormDescriptionLabel];
        NSString *optionalString = NSLocalizedStringFromTableInBundle(@"Optional", nil, [TTLUtil currentBundle], @"");
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        [attributedString addAttribute:NSFontAttributeName
                                            value:formDescriptionFont
                                            range:[self.titleLabel.text rangeOfString:optionalString]];
        self.titleLabel.attributedText = attributedString;
        
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Enter email address", nil, [TTLUtil currentBundle], @"");
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeEmail) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Email Address", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Enter email address", nil, [TTLUtil currentBundle], @"");
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypePasswordOptional) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Password Optional", nil, [TTLUtil currentBundle], @"");
        
        UIFont *formDescriptionFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormDescriptionLabel];
        NSString *optionalString = NSLocalizedStringFromTableInBundle(@"Optional", nil, [TTLUtil currentBundle], @"");
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        [attributedString addAttribute:NSFontAttributeName
                                 value:formDescriptionFont
                                 range:[self.titleLabel.text rangeOfString:optionalString]];
        self.titleLabel.attributedText = attributedString;
    
        [self setInfoDescriptionText:NSLocalizedStringFromTableInBundle(@"Password must contain at least one lowercase, uppercase, special character, and a number.", nil, [TTLUtil currentBundle], @"")];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Insert Password", nil, [TTLUtil currentBundle], @"");
        self.textField.secureTextEntry = YES;
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:YES];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeReTypePassword) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Retype Password", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Retype Password", nil, [TTLUtil currentBundle], @"");
        self.textField.secureTextEntry = YES;
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:YES];
    }
    else if (ttlCustomTextFieldViewType == TTLCustomTextFieldViewTypeGroupName) {
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Group Name", nil, [TTLUtil currentBundle], @"");
        [self setInfoDescriptionText:@""];
        [self setErrorInfoText:@""];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = NSLocalizedStringFromTableInBundle(@"Insert Name", nil, [TTLUtil currentBundle], @"");
        self.containerView.alpha = 1.0f;
        [self showShowPasswordButton:NO];
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
                self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive];
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
                self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
            }];
        }
    }
    else {
        if (active) {
            self.shadowView.alpha = 1.0f;
            self.shadowView.layer.shadowColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive].CGColor;
            self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderActive];
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
            self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
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
                self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderError];
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
                self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
                
            }];
        }
    }
    else {
        if (error) {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderError].CGColor;
            self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderError];
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive].CGColor;
            self.containerSeparatorView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorTextFieldBorderInactive];
        }
    }
}

- (void)showPasswordButtonDidTapped {
    if (self.textField.isSecureTextEntry) {
        self.textField.secureTextEntry = NO;
        self.passwordShowImageView.image = [UIImage imageNamed:@"TTLIconShowPassword" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        TTLImage *passwordShowImage = (TTLImage *) self.passwordShowImageView.image;
        passwordShowImage = (TTLImage *) [passwordShowImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconViewPasswordActive]];
        self.passwordShowImageView.image = passwordShowImage;
    }
    else {
        self.textField.secureTextEntry = YES;
        self.passwordShowImageView.image = [UIImage imageNamed:@"TTLIconShowPassword" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        TTLImage *passwordShowImage = (TTLImage *) self.passwordShowImageView.image;
        passwordShowImage = (TTLImage *) [passwordShowImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconViewPasswordInactive]];
        self.passwordShowImageView.image = passwordShowImage;
    }
}

- (void)showShowPasswordButton:(BOOL)show {
    if (show) {
        self.containerSeparatorView.alpha = 1.0f;
        self.passwordShowImageView.alpha = 1.0f;
        self.showPasswordButton.alpha = 1.0f;
        self.textField.frame = CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMinY(self.textField.frame), CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(self.showPasswordButton.frame) - 16.0f, CGRectGetHeight(self.textField.frame));
    }
    else {
        self.containerSeparatorView.alpha = 0.0f;
        self.passwordShowImageView.alpha = 0.0f;
        self.showPasswordButton.alpha = 0.0f;
        self.textField.frame = CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMinY(self.textField.frame), CGRectGetWidth(self.containerView.frame) - 16.0f - 16.0f, CGRectGetHeight(self.textField.frame));
    }
}

- (NSString *)getText {
    return self.textField.text;
}

- (void)setTextFieldWithData:(NSString *)dataString {
    self.textField.text = dataString;
}

- (void)setAsHidden:(BOOL)hidden {
    if (hidden) {
        self.titleLabel.alpha = 0.0f;
        self.textField.userInteractionEnabled = NO;
    }
    else {
        self.titleLabel.alpha = 1.0f;
        self.textField.userInteractionEnabled = YES;
    }
}

@end
