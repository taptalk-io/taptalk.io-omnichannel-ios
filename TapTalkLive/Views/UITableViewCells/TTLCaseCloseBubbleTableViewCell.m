//
//  TTLCaseCloseBubbleTableViewCell.m
//  TapTalk
//
//  Created by Dominic Vedericho on 24/01/20.
//  Copyright © 2020 TapTalk.io. All rights reserved.
//

#import "TTLCaseCloseBubbleTableViewCell.h"

@interface TTLCaseCloseBubbleTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (void)setCellStyle;

@end

@implementation TTLCaseCloseBubbleTableViewCell
#pragma mark - Life Cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shadowView.backgroundColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorSystemMessageBackgroundShadow] colorWithAlphaComponent:0.4f];
    self.shadowView.layer.cornerRadius = 8.0f;
    self.shadowView.layer.shadowRadius = 4.0f;
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowView.layer.shadowOpacity = 1.0f;
    self.shadowView.layer.masksToBounds = NO;
    
    self.containerView.layer.cornerRadius = 8.0f;
    
    [self setCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Custom Method
- (void)setCellStyle {
    
    UIFont *systemMessageFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontSystemMessageBody];
    UIColor *systemMessageColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorSystemMessageBody];
    self.contentLabel.textColor = systemMessageColor;
    self.contentLabel.font = systemMessageFont;
    
    self.shadowView.backgroundColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorSystemMessageBackgroundShadow] colorWithAlphaComponent:0.4f];
    self.containerView.backgroundColor = [[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorSystemMessageBackground] colorWithAlphaComponent:0.82f];
}

- (void)setMessage:(TAPMessageModel *)message {
    NSString *contentString = message.body;
    self.contentLabel.text = contentString;
}


@end
