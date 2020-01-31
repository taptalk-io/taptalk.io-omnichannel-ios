//
//  TTLCustomTextFieldView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TTLCustomTextFieldViewType) {
    TTLCustomTextFieldViewTypeFullName,
    TTLCustomTextFieldViewTypeUsername,
    TTLCustomTextFieldViewTypeUsernameWithoutDescription, //To show username without validation description
    TTLCustomTextFieldViewTypeEmailOptional,
    TTLCustomTextFieldViewTypeEmail,
    TTLCustomTextFieldViewTypePasswordOptional,
    TTLCustomTextFieldViewTypeReTypePassword,
    TTLCustomTextFieldViewTypeGroupName,
};

@protocol TTLCustomTextFieldViewDelegate <NSObject>

- (BOOL)customTextFieldViewTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)customTextFieldViewTextFieldShouldReturn:(UITextField *)textField;
- (BOOL)customTextFieldViewTextFieldShouldBeginEditing:(UITextField *)textField;
- (void)customTextFieldViewTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)customTextFieldViewTextFieldShouldEndEditing:(UITextField *)textField;
- (void)customTextFieldViewTextFieldDidEndEditing:(UITextField *)textField;
- (BOOL)customTextFieldViewTextFieldShouldClear:(UITextField *)textField;

@end

@interface TTLCustomTextFieldView : UIView

@property (strong, nonatomic) UITextField *textField;

@property (weak, nonatomic) id<TTLCustomTextFieldViewDelegate> delegate;

@property (nonatomic) TTLCustomTextFieldViewType ttlCustomTextFieldViewType;

- (CGFloat)getTextFieldHeight;
- (void)setAsActive:(BOOL)active animated:(BOOL)animated;
- (void)setAsEnabled:(BOOL)enabled;
- (void)setAsError:(BOOL)error animated:(BOOL)animated;
- (void)setErrorInfoText:(NSString *)string;
- (NSString *)getText;
- (void)setTextFieldWithData:(NSString *)dataString;
- (void)setAsHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
