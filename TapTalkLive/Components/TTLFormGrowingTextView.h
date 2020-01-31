//
//  TTLFormGrowingTextView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TTLFormGrowingTextViewType) {
    TTLFormGrowingTextViewTypeMessage,
    TTLFormGrowingTextViewTypeComment,
};

@protocol TTLFormGrowingTextViewDelegate <NSObject>

@optional
- (BOOL)formGrowingTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)formGrowingTextView:(UITextView *)textView shouldChangeHeight:(CGFloat)height;
- (void)formGrowingTextViewDidBeginEditing:(UITextView *)textView;
- (void)formGrowingTextViewDidEndEditing:(UITextView *)textView;
- (void)formGrowingTextViewDidStartTyping:(UITextView *)textView;
- (void)formGrowingTextViewDidStopTyping:(UITextView *)textView;

@end

@interface TTLFormGrowingTextView : UIView

@property (weak, nonatomic) id<TTLFormGrowingTextViewDelegate> delegate;
@property (nonatomic) TTLFormGrowingTextViewType ttlFormGrowingTextViewType;

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *shadowView;


@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSString *text;

@property (nonatomic) CGFloat minimumHeight;
@property (nonatomic) CGFloat maximumHeight;

- (void)becameFirstResponder;
- (void)resignFirstResponder;
- (void)resignFirstResponderWithoutAnimation;
- (BOOL)isFirstResponder;
- (void)selectAll:(id)sender;
- (void)setInitialText:(NSString *)text;
- (void)setPlaceholderText:(NSString *)text;
- (void)setTextColor:(UIColor *)color;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setPlaceholderFont:(UIFont *)font;
- (void)setInputView:(UIView *)inputView;
- (CGFloat)getHeight;
- (NSString *)getText;
- (void)setAsActive:(BOOL)active animated:(BOOL)animated;
- (void)showTitleLabel:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
