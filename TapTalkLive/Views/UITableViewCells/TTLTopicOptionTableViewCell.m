//
//  TTLTopicOptionTableViewCell.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLTopicOptionTableViewCell.h"

@interface TTLTopicOptionTableViewCell ()

@property (strong, nonatomic) UILabel *optionLabel;
@property (strong, nonatomic) TTLImageView *iconImageView;
@property (strong, nonatomic) UIView *separatorView;


@end

@implementation TTLTopicOptionTableViewCell
#pragma mark - Lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIFont *optionLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontTopicListLabel];
        UIColor *optionLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorTopicListLabel];
        _optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 16.0f - 24.0f - 16.0f, 44.0f)];
        self.optionLabel.font = optionLabelFont;
        self.optionLabel.textColor = optionLabelColor;
        [self.contentView addSubview:self.optionLabel];
        
        _iconImageView = [[TTLImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 24.0f, (44.0f - 24.0f) / 2.0f, 24.0f, 24.0f)];
        self.iconImageView.clipsToBounds = YES;
        TTLImage *selectedIconImage = [TTLImage imageNamed:@"TTLIconCheck" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
        self.iconImageView.image = selectedIconImage;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.iconImageView];
        
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(16.0f, 44.0f - 1.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f, 1.0f)];
        self.separatorView.backgroundColor = [TTLUtil getColor:TTL_COLOR_GREY_DC];
        [self.contentView addSubview:self.separatorView];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)prepareForReuse {
    [super prepareForReuse];
    self.optionLabel.text = @"";
    self.iconImageView.alpha = 0.0f;
    
    UIColor *optionLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorTopicListLabel];
    self.optionLabel.textColor = optionLabelColor;
}

- (void)setTopicOptionWithName:(NSString *)topicName {
    topicName = [TTLUtil nullToEmptyString:topicName];
    self.optionLabel.text = topicName;
}

- (void)showAsLastOption:(BOOL)lastOption {
    if (lastOption) {
        self.separatorView.frame = CGRectMake(0.0f, CGRectGetMinY(self.separatorView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.separatorView.frame));
    }
    else {
        self.separatorView.frame = CGRectMake(16.0f, CGRectGetMinY(self.separatorView.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f, CGRectGetHeight(self.separatorView.frame));
    }
}

- (void)showAsSelected:(BOOL)selected {
    UIColor *optionLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorTopicListLabel];
    UIColor *optionLabelSelectedColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorTopicListLabelSelected];

    if (selected) {
        self.optionLabel.textColor = optionLabelSelectedColor;
        self.iconImageView.alpha = 1.0f;
    }
    else {
        self.optionLabel.textColor = optionLabelColor;
        self.iconImageView.alpha = 0.0f;
    }
}

@end
