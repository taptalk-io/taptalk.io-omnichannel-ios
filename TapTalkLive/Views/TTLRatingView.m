//
//  TTLRatingView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLRatingView.h"

@interface TTLRatingView ()

@property (strong, nonatomic) UIView *backgroundContainerView;
@property (strong, nonatomic) UIImageView *closeImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (strong, nonatomic) UIView *starRatingContainerView;
@property (strong, nonatomic) UIImageView *starRating1ImageView;
@property (strong, nonatomic) UIImageView *starRating2ImageView;
@property (strong, nonatomic) UIImageView *starRating3ImageView;
@property (strong, nonatomic) UIImageView *starRating4ImageView;
@property (strong, nonatomic) UIImageView *starRating5ImageView;

@end

@implementation TTLRatingView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundContainerView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundContainerView.backgroundColor = [[TTLUtil getColor:@"191919"] colorWithAlphaComponent:0.8f];
        [self addSubview:self.backgroundContainerView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth(self.frame), 0.0f)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        
        _closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, 16.0f, 22.0f, 22.0f)];
        TTLImage *buttonImage = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        buttonImage = [buttonImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconNavigationBarCloseButton]];
        self.closeImageView.image = buttonImage;
        self.closeImageView.clipsToBounds = YES;
        self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.closeImageView];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 40.0f, 40.0f)];
        self.closeButton.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:self.closeButton];
        
        CGFloat titleLabelGap = CGRectGetWidth(self.closeImageView.frame) + 16.0f + 16.0f;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelGap, 16.0f, CGRectGetWidth(self.containerView.frame) - titleLabelGap - titleLabelGap, 22.0f)];
        UIFont *titleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontNavigationBarTitleLabel];
        UIColor *titleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorNavigationBarTitleLabel];
        self.titleLabel.font = titleLabelFont;
        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = NSLocalizedString(@"Leave a review", @"");
        [self.containerView addSubview:self.titleLabel];
        
        //DV Note
        // 264.0f = (5 * 40.0f) + (4 * 16.0f)
        //(5 * star width) + (4 * spacing gap)
        //END DV Note
        CGFloat starRatingContainerXPosition = (CGRectGetWidth(self.containerView.frame) - 264.0f) / 2.0f;
        _starRatingContainerView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - 264.0f) / 2.0f, CGRectGetMaxY(self.titleLabel.frame) + 28.0f, 264.0f, 40.0f)];
        [self.containerView addSubview:self.starRatingContainerView];

        TTLImage *starRatingInactiveImage = [TTLImage imageNamed:@"TTLIconStarInactive" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];

        _starRating1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        self.starRating1ImageView.image = starRatingInactiveImage;
        self.starRating1ImageView.clipsToBounds = YES;
        self.starRating1ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.starRatingContainerView addSubview:self.starRating1ImageView];
        
        _starRating1Button = [[UIButton alloc] initWithFrame:self.starRating1ImageView.frame];
        self.starRating1Button.backgroundColor = [UIColor clearColor];
        [self.starRatingContainerView addSubview:self.starRating1Button];
        
        _starRating2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starRating1ImageView.frame) + 16.0f, CGRectGetMinY(self.starRating1ImageView.frame), CGRectGetWidth(self.starRating1ImageView.frame), CGRectGetHeight(self.starRating1ImageView.frame))];
        self.starRating2ImageView.image = starRatingInactiveImage;
        self.starRating2ImageView.clipsToBounds = YES;
        self.starRating2ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.starRatingContainerView addSubview:self.starRating2ImageView];
        
        _starRating2Button = [[UIButton alloc] initWithFrame:self.starRating2ImageView.frame];
        self.starRating2Button.backgroundColor = [UIColor clearColor];
        [self.starRatingContainerView addSubview:self.starRating2Button];
        
        _starRating3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starRating2ImageView.frame) + 16.0f, CGRectGetMinY(self.starRating1ImageView.frame), CGRectGetWidth(self.starRating1ImageView.frame), CGRectGetHeight(self.starRating1ImageView.frame))];
        self.starRating3ImageView.image = starRatingInactiveImage;
        self.starRating3ImageView.clipsToBounds = YES;
        self.starRating3ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.starRatingContainerView addSubview:self.starRating3ImageView];
        
        _starRating3Button = [[UIButton alloc] initWithFrame:self.starRating3ImageView.frame];
        self.starRating3Button.backgroundColor = [UIColor clearColor];
        [self.starRatingContainerView addSubview:self.starRating3Button];
        
        _starRating4ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starRating3ImageView.frame) + 16.0f, CGRectGetMinY(self.starRating1ImageView.frame), CGRectGetWidth(self.starRating1ImageView.frame), CGRectGetHeight(self.starRating1ImageView.frame))];
        self.starRating4ImageView.image = starRatingInactiveImage;
        self.starRating4ImageView.clipsToBounds = YES;
        self.starRating4ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.starRatingContainerView addSubview:self.starRating4ImageView];
        
        _starRating4Button = [[UIButton alloc] initWithFrame:self.starRating4ImageView.frame];
        self.starRating4Button.backgroundColor = [UIColor clearColor];
        [self.starRatingContainerView addSubview:self.starRating4Button];
        
        _starRating5ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starRating4ImageView.frame) + 16.0f, CGRectGetMinY(self.starRating1ImageView.frame), CGRectGetWidth(self.starRating1ImageView.frame), CGRectGetHeight(self.starRating1ImageView.frame))];
        self.starRating5ImageView.image = starRatingInactiveImage;
        self.starRating5ImageView.clipsToBounds = YES;
        self.starRating5ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.starRatingContainerView addSubview:self.starRating5ImageView];
        
        _starRating5Button = [[UIButton alloc] initWithFrame:self.starRating5ImageView.frame];
        self.starRating5Button.backgroundColor = [UIColor clearColor];
        [self.starRatingContainerView addSubview:self.starRating5Button];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, CGRectGetMaxY(self.starRatingContainerView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame) - 16.0f - 16.0f, 16.0f)];
        UIFont *subtitleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontInfoLabelBodyBold];
        UIColor *subtitleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorRatingBodyLabel];
        self.subtitleLabel.font = subtitleLabelFont;
        self.subtitleLabel.textColor = subtitleLabelColor;
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.text = NSLocalizedString(@"", @"");
        [self.containerView addSubview:self.subtitleLabel];
        
        _commentTextView = [[TTLFormGrowingTextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.subtitleLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 0.0f)];
        [self.commentTextView setTtlFormGrowingTextViewType:TTLFormGrowingTextViewTypeMessage];
        [self.commentTextView showTitleLabel:NO];
        self.commentTextView.frame = CGRectMake(CGRectGetMinX(self.commentTextView.frame), CGRectGetMinY(self.commentTextView.frame), CGRectGetWidth(self.commentTextView.frame), [self.commentTextView getHeight]);
        [self.commentTextView setPlaceholderText:NSLocalizedString(@"Leave a comment", @"")];
        [self.commentTextView setPlaceholderColor:[TTLUtil getColor:@"C7C7CD"]];
        UIFont *textFieldFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFormTextField];
        [self.commentTextView setPlaceholderFont:textFieldFont];
        [self.containerView addSubview:self.commentTextView];
    
        _submitButtonView = [[TTLCustomButtonView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.commentTextView.frame) + 24.0f, CGRectGetWidth(self.containerView.frame), 48.0f)];
        [self.submitButtonView setCustomButtonViewStyleType:TTLCustomButtonViewStyleTypePlain];
        [self.submitButtonView setCustomButtonViewType:TTLCustomButtonViewTypeInactive];
        [self.submitButtonView setButtonWithTitle:NSLocalizedString(@"Submit Review", @"")];
        [self.containerView addSubview:self.submitButtonView];
        
        CGFloat bottomGap = 16.0f;
        if (IS_IPHONE_X_FAMILY) {
            bottomGap = 32.0f;
        }
        self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth(self.containerView.frame), CGRectGetMaxY(self.submitButtonView.frame) + bottomGap);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:(CGSize){8.0, 8.0}].CGPath;
        self.containerView.layer.mask = containerViewLayer;
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)animateOpeningView {
    [UIView animateWithDuration:0.2f animations:^{
        CGFloat bottomGap = 16.0f;
        if (IS_IPHONE_X_FAMILY) {
            bottomGap = 32.0f;
        }
        self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMaxY(self.submitButtonView.frame) - bottomGap, CGRectGetWidth(self.containerView.frame), CGRectGetMaxY(self.submitButtonView.frame) + bottomGap);
    } completion:nil];
}
- (void)setStarRatingWithValue:(NSInteger)starValue {
    TTLImage *starRatingInactiveImage = [TTLImage imageNamed:@"TTLIconStarInactive" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    TTLImage *starRatingActiveImage = [TTLImage imageNamed:@"TTLIconStarActive" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];

    switch (starValue) {
        case 1:
        {
            //1 Star Rating
            self.starRating1ImageView.image = starRatingActiveImage;
            self.starRating2ImageView.image = starRatingInactiveImage;
            self.starRating3ImageView.image = starRatingInactiveImage;
            self.starRating4ImageView.image = starRatingInactiveImage;
            self.starRating5ImageView.image = starRatingInactiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"Horrible", @"");
            break;
        }
        case 2:
        {
            //2 Star Rating
            self.starRating1ImageView.image = starRatingActiveImage;
            self.starRating2ImageView.image = starRatingActiveImage;
            self.starRating3ImageView.image = starRatingInactiveImage;
            self.starRating4ImageView.image = starRatingInactiveImage;
            self.starRating5ImageView.image = starRatingInactiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"Not good", @"");
            break;
        }
        case 3:
        {
            //3 Star Rating
            self.starRating1ImageView.image = starRatingActiveImage;
            self.starRating2ImageView.image = starRatingActiveImage;
            self.starRating3ImageView.image = starRatingActiveImage;
            self.starRating4ImageView.image = starRatingInactiveImage;
            self.starRating5ImageView.image = starRatingInactiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"Okay", @"");
            break;
        }
        case 4:
        {
            //4 Star Rating
            self.starRating1ImageView.image = starRatingActiveImage;
            self.starRating2ImageView.image = starRatingActiveImage;
            self.starRating3ImageView.image = starRatingActiveImage;
            self.starRating4ImageView.image = starRatingActiveImage;
            self.starRating5ImageView.image = starRatingInactiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"Good", @"");
            break;
        }
        case 5:
        {
            //5 Star Rating
            self.starRating1ImageView.image = starRatingActiveImage;
            self.starRating2ImageView.image = starRatingActiveImage;
            self.starRating3ImageView.image = starRatingActiveImage;
            self.starRating4ImageView.image = starRatingActiveImage;
            self.starRating5ImageView.image = starRatingActiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"Excellent", @"");
            break;
        }
        default:
            {
            //0 Star Rating
            self.starRating1ImageView.image = starRatingInactiveImage;
            self.starRating2ImageView.image = starRatingInactiveImage;
            self.starRating3ImageView.image = starRatingInactiveImage;
            self.starRating4ImageView.image = starRatingInactiveImage;
            self.starRating5ImageView.image = starRatingInactiveImage;
            self.subtitleLabel.text = NSLocalizedString(@"", @"");
            break;
            }
    }
}

- (void)adjustGrowingContentViewWithAdditionalHeight:(CGFloat)additionalHeight {
    CGFloat bottomGap = 16.0f;
    if (IS_IPHONE_X_FAMILY) {
        bottomGap = 32.0f;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.commentTextView.frame = CGRectMake(CGRectGetMinX(self.commentTextView.frame), CGRectGetMinY(self.commentTextView.frame), CGRectGetWidth(self.commentTextView.frame), [self.commentTextView getHeight]);
        self.submitButtonView.frame = CGRectMake(CGRectGetMinX(self.submitButtonView.frame), CGRectGetMaxY(self.commentTextView.frame) + 24.0f, CGRectGetWidth(self.submitButtonView.frame), CGRectGetHeight(self.submitButtonView.frame));
        self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMaxY(self.submitButtonView.frame) - bottomGap - additionalHeight, CGRectGetWidth(self.containerView.frame), CGRectGetMaxY(self.submitButtonView.frame) + bottomGap + additionalHeight);
        CAShapeLayer *containerViewLayer = [CAShapeLayer layer];
        containerViewLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.containerView.layer.mask = containerViewLayer;
    }];
}

- (void)setCommentTextViewAsActive:(BOOL)active animated:(BOOL)animated {
    [self.commentTextView setAsActive:active animated:animated];
}

- (void)setSubmitButtonAsActive:(BOOL)active {
    [self.submitButtonView setAsActiveState:active animated:YES];
}

@end
    
