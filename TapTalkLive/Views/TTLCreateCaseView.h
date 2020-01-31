//
//  TTLCreateCaseView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 03/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseView.h"
#import "TTLCustomTextFieldView.h"
#import "TTLKeyboardAccessoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLCreateCaseView : TTLBaseView

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) TTLCustomTextFieldView *fullNameTextField;
@property (strong, nonatomic) TTLCustomTextFieldView *emailTextField;
@property (strong, nonatomic) TTLCustomDropDownTextFieldView *topicDropDownView;
@property (strong, nonatomic) TTLFormGrowingTextView *messageTextView;
@property (strong, nonatomic) TTLCustomButtonView *createCaseButtonView;
@property (strong, nonatomic) TTLKeyboardAccessoryView *keyboardAccessoryView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) TTLImageView *closeImageView;

- (void)setMessageTextViewAsActive:(BOOL)active animated:(BOOL)animated;
- (void)adjustGrowingContentView;
- (void)setCreateCaseButtonAsActive:(BOOL)active;
- (void)showUserDataForm:(BOOL)isShow;
- (void)showCloseButton:(BOOL)isShow;
- (void)showCreateCaseButtonAsLoading:(BOOL)loading;


@end

NS_ASSUME_NONNULL_END
