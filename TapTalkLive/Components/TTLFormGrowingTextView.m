//
//  TTLFormGrowingTextView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLFormGrowingTextView.h"
#import <TapTalk/TAPCustomTextView.h>
#import <TapTalk/TAPStyleManager.h>

@interface TTLFormGrowingTextView () <UITextViewDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (nonatomic) BOOL isActive;

- (void)initialSetup;
- (void)checkHeight;

@end

@implementation TTLFormGrowingTextView
#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    
    if (self) {
        [self initialSetup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialSetup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialSetup];
        
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)initialSetup {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIFont *formLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormLabel];
    UIColor *formLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormLabel];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 22.0f)];
    self.titleLabel.font = formLabelFont;
    self.titleLabel.textColor = formLabelColor;
    [self addSubview:self.titleLabel];

    _containerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 8.0f, CGRectGetWidth(self.frame) - 16.0f - 16.0f, 66.0f)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
    self.containerView.layer.cornerRadius = 8.0f;
    self.containerView.layer.borderWidth = 1.0f;
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.containerView.frame), 66.0f)];
    self.shadowView.backgroundColor = [UIColor whiteColor];
    self.shadowView.layer.cornerRadius = 8.0f;
    self.shadowView.layer.shadowRadius = 5.0f;
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowView.layer.shadowOpacity = 1.0f;
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.alpha = 0.0f;
    [self addSubview:self.shadowView];
    [self addSubview:self.containerView];
    
    //For iOS 7+ - Handle jumping text
    NSString *requiredSystemVersion = @"7.0";
    NSString *currentSystemVersion = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currentSystemVersion compare:requiredSystemVersion options:NSNumericSearch] != NSOrderedAscending);
    
    if (osVersionSupported) {
        
        [_textView removeFromSuperview];
        _textView = nil;
        
        NSTextStorage *textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
        [layoutManager addTextContainer:textContainer];
        
        UIFont *textViewFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontFormTextField];
        UIColor *textViewColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorFormTextField];
        _textView = [[TAPCustomTextView alloc] initWithFrame:CGRectMake(16.0f, 16.0f, CGRectGetWidth(self.containerView.frame) - 16.0f - 16.0f, CGRectGetHeight(self.containerView.frame) - 16.0f - 16.0f) textContainer:textContainer];
        self.textView.delegate = self;
        self.textView.textContainer.lineFragmentPadding = 0;
        self.textView.font = textViewFont;
        self.textView.textColor = textViewColor;
        [self.textView setTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldCursor]];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.textView.spellCheckingType = UITextSpellCheckingTypeDefault;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.textView.returnKeyType = UIReturnKeyDefault;
        self.textView.inputView.autoresizingMask = YES;
        
        [self.containerView addSubview:self.textView];
    }
    
    self.textView.textContainerInset = UIEdgeInsetsZero;
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textView.frame), CGRectGetMinY(self.textView.frame) - 8.0f, CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.placeholderLabel];
    
    if (self.minimumHeight == 0.0f) {
        self.minimumHeight = 34.0f;
    }
    
    if (self.maximumHeight == 0.0f) {
        self.maximumHeight = 76.0f;
    }
}

#pragma mark - Delegate
#pragma mark UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    _text = newString;
    
    if ([newString isEqualToString:@""]) {
        self.placeholderLabel.alpha = 1.0f;
        
        if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidStopTyping:)]) {
            [self.delegate formGrowingTextViewDidStopTyping:self];
        }
    }
    else {
        self.placeholderLabel.alpha = 0.0f;
        
        if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidStartTyping:)]) {
            [self.delegate formGrowingTextViewDidStartTyping:self];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(formGrowingTextView:shouldChangeTextInRange:replacementText:)]) {
        BOOL result = [self.delegate formGrowingTextView:textView shouldChangeTextInRange:range replacementText:text];
        return result;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self checkHeight];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.alpha = 0.0f;
    
    if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidBeginEditing:)]) {
        [self.delegate formGrowingTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.alpha = 1.0f;
    }
    else {
        self.placeholderLabel.alpha = 0.0f;
    }
    
    if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidEndEditing:)]) {
        [self.delegate formGrowingTextViewDidEndEditing:self];
    }
}

#pragma mark - Custom Method
- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.textView.font = font;
    self.placeholderLabel.font = font;
}

- (void)setTextColor:(UIColor *)color {
    self.textView.textColor = color;
}

- (void)setPlaceholderColor:(UIColor *)color {
    self.placeholderLabel.textColor = color;
}

- (void)setPlaceholderFont:(UIFont *)font {
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textView.text = text;
    
    if ([self.text isEqualToString:@""]) {
        self.placeholderLabel.alpha = 1.0f;
        
        if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidStopTyping:)]) {
            [self.delegate formGrowingTextViewDidStopTyping:self];
        }
    }
    else {
        self.placeholderLabel.alpha = 0.0f;
        
        if ([self.delegate respondsToSelector:@selector(formGrowingTextViewDidStartTyping:)]) {
            [self.delegate formGrowingTextViewDidStartTyping:self];
        }
    }
    
    [self checkHeight];
}

- (void)setInitialText:(NSString *)text {
    _text = text;
    
    self.textView.text = text;
    
    if ([self.text isEqualToString:@""]) {
        self.placeholderLabel.alpha = 1.0f;
    }
    else {
        self.placeholderLabel.alpha = 0.0f;
    }
    
    [self checkHeight];
}

- (void)checkHeight {
    CGSize contentSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
    
    self.textView.textContainer.size = CGSizeMake(self.textView.textContainer.size.width, contentSize.height);
    
    if (contentSize.height < self.minimumHeight) {
        contentSize.height = self.minimumHeight;
    }
    
    if (contentSize.height > self.maximumHeight) {
        contentSize.height = self.maximumHeight;
    }
    
    self.textView.frame = CGRectMake(CGRectGetMinX(self.textView.frame), CGRectGetMinY(self.textView.frame), CGRectGetWidth(self.textView.frame), contentSize.height);
    
    if (contentSize.height != CGRectGetHeight(self.frame)) {
        
        self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.containerView.frame), contentSize.height + 16.0f + 16.0f);
        
        self.shadowView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
        
        if ([self.delegate respondsToSelector:@selector(formGrowingTextView:shouldChangeHeight:)]) {
            [self.delegate formGrowingTextView:self shouldChangeHeight:contentSize.height];
        }
    }
}

- (void)becameFirstResponder {
    [self.textView becomeFirstResponder];
    //    [self performSelector:@selector(setTextViewFirstResponder) withObject:nil afterDelay:0.2f];
}

- (void)resignFirstResponder {
    [self.textView resignFirstResponder];
}

- (void)resignFirstResponderWithoutAnimation {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self.textView resignFirstResponder];
    
    [UIView commitAnimations];
}

- (BOOL)isFirstResponder {
    return [self.textView isFirstResponder];
}

- (void)setInputView:(UIView *)inputView {
    self.textView.inputView = inputView;
    [self.textView reloadInputViews];
}

- (void)selectAll:(id)sender {
    [self.textView selectAll:sender];
}

- (void)setPlaceholderText:(NSString *)text {
    self.placeholderLabel.text = text;
}

- (void)setTtlFormGrowingTextViewType:(TTLFormGrowingTextViewType)ttlFormGrowingTextViewType {
    _ttlFormGrowingTextViewType = ttlFormGrowingTextViewType;
    
    if (self.ttlFormGrowingTextViewType == TTLFormGrowingTextViewTypeMessage) {
        self.titleLabel.text = NSLocalizedString(@"Message", @"");
    }
    else if (self.ttlFormGrowingTextViewType == TTLFormGrowingTextViewTypeComment) {
        self.titleLabel.text = NSLocalizedString(@"Comment", @"");
    }
}

- (CGFloat)getHeight {
    return CGRectGetMaxY(self.containerView.frame);
}

- (NSString *)getText {
    return self.textView.text;
}

- (void)setAsActive:(BOOL)active animated:(BOOL)animated {
    
    _isActive = active;
    
    if (animated) {
        if (active) {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 1.0f;
                self.shadowView.layer.shadowColor = [[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
                self.containerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive].CGColor;
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.shadowView.alpha = 0.0f;
                self.containerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
            }];
        }
    }
    else {
        if (active) {
            self.shadowView.alpha = 1.0f;
            self.shadowView.layer.shadowColor = [[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive] colorWithAlphaComponent:0.24f].CGColor;
            self.containerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderActive].CGColor;
        }
        else {
            self.shadowView.alpha = 0.0f;
            self.containerView.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTextFieldBorderInactive].CGColor;
        }
    }
}

- (void)showTitleLabel:(BOOL)isShow {
    if (isShow) {
        self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 22.0f);
        self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMaxY(self.titleLabel.frame) + 8.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
        self.shadowView.frame = CGRectMake(CGRectGetMinX(self.shadowView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.shadowView.frame), CGRectGetHeight(self.containerView.frame));
    }
    else {
         self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 0.0f);
         self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
         self.shadowView.frame = CGRectMake(CGRectGetMinX(self.shadowView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.shadowView.frame), CGRectGetHeight(self.containerView.frame));
    }
}

@end
