//
//  TTLCreateCaseView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 03/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCreateCaseView.h"
#import <TapTalk/TAPCustomGrowingTextView.h>
#import <TapTalk/TAPImageView.h>

@interface TTLCreateCaseView ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *topBackgroundView;
@property (strong, nonatomic) TAPImageView *logoImageView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation TTLCreateCaseView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        CGFloat topGap = [TTLUtil currentDeviceNavigationBarHeightWithStatusBar:YES iPhoneXLargeLayout:NO];
        _topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 244.0f)];
        self.topBackgroundView.backgroundColor = [TTLUtil getColor:@"FF7D00"];
        [self.scrollView addSubview:self.topBackgroundView];
        
        _logoImageView = [[TAPImageView alloc] initWithFrame:CGRectMake(0.0f, topGap + 16.0f, 48.0f, 48.0f)];
        self.logoImageView.clipsToBounds = YES;
        self.logoImageView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3f]; //DV Temp
        self.logoImageView.layer.cornerRadius = 8.0f;
        self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.logoImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, CGRectGetMaxY(self.logoImageView.frame) + 16.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 36.0f)];
        [self.scrollView addSubview:self.titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 4.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 48.0f)];
        self.subtitleLabel.numberOfLines = 0;
        [self.scrollView addSubview:self.subtitleLabel];
        
        
    }
    
    return self;
}

#pragma mark - Custom Method

@end
