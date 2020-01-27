//
//  TTLReviewBubbleTableViewCell.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 23/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLReviewBubbleTableViewCell.h"
#import <TapTalk/TapUserModel.h>

@interface TTLReviewBubbleTableViewCell ()

@property (strong, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *reviewButtonView;

@property (strong, nonatomic) IBOutlet UIView *doneReviewView;
@property (strong, nonatomic) IBOutlet TTLImageView *doneReviewIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *doneReviewLabel;
@property (strong, nonatomic) IBOutlet UIView *notReviewView;
@property (strong, nonatomic) IBOutlet UILabel *notReviewLabel;

@property (strong, nonatomic) IBOutlet UIButton *reviewButton;
@property (strong, nonatomic) IBOutlet TTLImageView *senderImageView;
@property (strong, nonatomic) IBOutlet UIButton *senderProfileImageButton;
@property (strong, nonatomic) IBOutlet UIView *senderInitialView;
@property (strong, nonatomic) IBOutlet UILabel *senderInitialLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderImageViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderImageViewTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderProfileImageButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderNameTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderNameHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewButtonViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewButtonViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *senderImageViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewTrailingConstraint;

- (IBAction)reviewButtonDidTapped:(id)sender;
- (IBAction)senderProfileImageButtonDidTapped:(id)sender;

@property (strong, nonatomic) TAPMessageModel *currentMessage;

@end

@implementation TTLReviewBubbleTableViewCell
#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = NSLocalizedString(@"Do you mind leaving a review so that we can keep on improving our services 😊", @"");
    
    self.doneReviewView.clipsToBounds = YES;
    self.doneReviewView.layer.cornerRadius = 8.0f;
    
    self.notReviewView.clipsToBounds = YES;
    self.notReviewView.layer.cornerRadius = 8.0f;
        
    UIFont *buttonFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontButtonLabel];
    UIColor *buttonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorButtonLabel];
    UIColor *inactiveButtonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorReviewBubbleDoneReviewButtonTitleLabel];
    
    //Not yet review view
    self.notReviewLabel.font = buttonFont;
    self.notReviewLabel.textColor = buttonColor;
    
    CAGradientLayer *notReviewGradient = [CAGradientLayer layer];
    notReviewGradient.frame = self.notReviewView.bounds;
    notReviewGradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientDark].CGColor, nil];
    notReviewGradient.startPoint = CGPointMake(0.0f, 0.0f);
    notReviewGradient.endPoint = CGPointMake(0.0f, 1.0f);
    notReviewGradient.cornerRadius = 6.0f;
    [self.notReviewView.layer insertSublayer:notReviewGradient atIndex:0];
    
    //Done review view
    self.doneReviewLabel.font = buttonFont;
    self.doneReviewLabel.textColor = inactiveButtonColor;
    
    CAGradientLayer *doneReviewGradient = [CAGradientLayer layer];
    doneReviewGradient.frame = self.doneReviewView.bounds;
    doneReviewGradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientDark].CGColor, nil];
    doneReviewGradient.startPoint = CGPointMake(0.0f, 0.0f);
    doneReviewGradient.endPoint = CGPointMake(0.0f, 1.0f);
    doneReviewGradient.cornerRadius = 6.0f;
    [self.doneReviewView.layer insertSublayer:doneReviewGradient atIndex:0];
    
    self.doneReviewIconImageView.image = [UIImage imageNamed:@"TTLIconCheck" inBundle:[TTLUtil currentBundle] withConfiguration:nil];
    TTLImage *checkIconImage = self.doneReviewIconImageView.image;
    checkIconImage = [checkIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconReviewBubbleCellDoneReviewCheck]];
    self.doneReviewIconImageView.image = checkIconImage;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method
- (void)setMessage:(TAPMessageModel *)message {
    [super setMessage:message];
    
    _currentMessage = message;
    
    TAPUserModel *currentActiveUser = [TTLDataManager getActiveUser];
    NSString *activeUserID = currentActiveUser.userID;
    activeUserID = [TTLUtil nullToEmptyString:activeUserID];
    
    NSString *messageUserID = message.user.xcUserID;
    messageUserID = [TTLUtil nullToEmptyString:messageUserID];
    
    if ([messageUserID isEqualToString:activeUserID]) {
        //Message is ours
        self.bubbleView.clipsToBounds = YES;
        self.bubbleView.layer.cornerRadius = 8.0f;
        self.bubbleView.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
        
        self.bubbleView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorLeftBubbleBackground];
        UIFont *bubbleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontLeftBubbleMessageBody];
        UIColor *bubbleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorLeftBubbleMessageBody];
        self.titleLabel.textColor = bubbleLabelColor;
        self.titleLabel.font = bubbleLabelFont;
        
        self.reviewButtonViewHeightConstraint.constant = 0.0f;
        self.reviewButtonViewTopConstraint.constant = 0.0f;
        self.senderNameHeightConstraint.constant = 0.0f;
        self.senderNameTopConstraint.constant = 0.0f;
        
        self.senderImageViewLeadingConstraint.active = NO;
        self.senderImageViewLeadingConstraint.constant = 0.0f;
        self.bubbleViewTrailingConstraint.active = YES;
        self.bubbleViewTrailingConstraint.constant = 16.0f;
    }
    else {
        //Message is from other user
        self.bubbleView.clipsToBounds = YES;
        self.bubbleView.layer.cornerRadius = 8.0f;
        self.bubbleView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        
        self.bubbleView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorRightBubbleBackground];

        UIFont *bubbleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontRightBubbleMessageBody];
        UIColor *bubbleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorRightBubbleMessageBody];
        self.titleLabel.textColor = bubbleLabelColor;
        self.titleLabel.font = bubbleLabelFont;
        
        self.reviewButtonViewHeightConstraint.constant = 48.0f;
        self.reviewButtonViewTopConstraint.constant = 10.0f;
        self.senderNameHeightConstraint.constant = 18.0f;
        self.senderNameTopConstraint.constant = 10.0f;
        
        self.senderImageViewLeadingConstraint.constant = 16.0f;
        self.senderImageViewLeadingConstraint.active = YES;
        self.bubbleViewTrailingConstraint.active = NO;
        self.bubbleViewTrailingConstraint.constant = 0.0f;
    }
}

- (void)setReviewBubbleType:(TTLReviewBubbleType)reviewBubbleType {
    _reviewBubbleType = reviewBubbleType;
    
}

- (IBAction)reviewButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:)]) {
        [self.delegate reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:self.currentMessage];
    }
}

- (IBAction)senderProfileImageButtonDidTapped:(id)sender {
    
}

@end
