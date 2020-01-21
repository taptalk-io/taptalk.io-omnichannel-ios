//
//  TTLCustomDropDownTextFieldView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 16/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TTLCustomDropDownTextFieldViewType) {
    TTLCustomDropDownTextFieldViewTypeTopic,
};

@protocol TTLCustomDropDownTextFieldViewDelegate <NSObject>

- (void)customDropDownTextFieldViewDidTapped;

@end

@interface TTLCustomDropDownTextFieldView : UIView

@property (strong, nonatomic) UITextField *textField;

@property (weak, nonatomic) id<TTLCustomDropDownTextFieldViewDelegate> delegate;

@property (nonatomic) TTLCustomDropDownTextFieldViewType ttlCustomDropDownTextFieldViewType;

- (CGFloat)getTextFieldHeight;
- (void)setAsFilled:(BOOL)isFilled;
- (void)setAsEnabled:(BOOL)enabled;
- (void)setAsActive:(BOOL)active animated:(BOOL)animated;
- (void)setAsError:(BOOL)error animated:(BOOL)animated;
- (void)setErrorInfoText:(NSString *)string;
- (NSString *)getText;
- (void)setTextFieldWithData:(NSString *)dataString;
- (void)setAsLoading:(BOOL)loading animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
