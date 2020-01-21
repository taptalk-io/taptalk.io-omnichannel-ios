//
//  TTLRatingView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLRatingView : TTLBaseView

@property (strong, nonatomic) TTLFormGrowingTextView *commentTextView;
@property (strong, nonatomic) TTLCustomButtonView *submitButtonView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *starRating1Button;
@property (strong, nonatomic) UIButton *starRating2Button;
@property (strong, nonatomic) UIButton *starRating3Button;
@property (strong, nonatomic) UIButton *starRating4Button;
@property (strong, nonatomic) UIButton *starRating5Button;

- (void)setStarRatingWithValue:(NSInteger)starValue;
- (void)adjustGrowingContentViewWithAdditionalHeight:(CGFloat)additionalHeight;
- (void)setCommentTextViewAsActive:(BOOL)active animated:(BOOL)animated;
- (void)setSubmitButtonAsActive:(BOOL)active;

@end

NS_ASSUME_NONNULL_END
