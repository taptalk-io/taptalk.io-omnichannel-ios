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
    self.doneReviewView.clipsToBounds = YES;
    self.doneReviewView.layer.cornerRadius = 8.0f;
    
    self.notReviewView.clipsToBounds = YES;
    self.notReviewView.layer.cornerRadius = 8.0f;
    
    self.senderImageView.clipsToBounds = YES;
    self.senderImageView.layer.cornerRadius = CGRectGetHeight(self.senderImageView.frame)/2.0f;
        
    UIFont *senderNameLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontLeftBubbleSenderName];
    UIColor *senderNameLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorLeftBubbleSenderName];
    
    UIFont *initialNameLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontRoomAvatarSmallLabel];
    UIColor *initialNameLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorRoomAvatarSmallLabel];
    
    self.senderInitialLabel.textColor = initialNameLabelColor;
    self.senderInitialLabel.font = initialNameLabelFont;
    self.senderInitialView.layer.cornerRadius = CGRectGetWidth(self.senderInitialView.frame) / 2.0f;
    self.senderInitialView.clipsToBounds = YES;
        
    self.senderNameLabel.font = senderNameLabelFont;
    self.senderNameLabel.textColor = senderNameLabelColor;
    
    UIFont *buttonFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontButtonLabel];
    UIColor *buttonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorButtonLabel];
    UIColor *inactiveButtonColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorReviewBubbleDoneReviewButtonTitleLabel];
    
    //Not yet review view
    self.notReviewLabel.font = buttonFont;
    self.notReviewLabel.textColor = buttonColor;
    self.notReviewView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight];
    
    //Done review view
    self.doneReviewLabel.font = buttonFont;
    self.doneReviewLabel.textColor = inactiveButtonColor;
    self.doneReviewView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonInactiveBackgroundGradientLight];
    
    self.doneReviewIconImageView.image = [UIImage imageNamed:@"TTLIconCheck" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    TTLImage *checkIconImage = self.doneReviewIconImageView.image;
    checkIconImage = [checkIconImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconReviewBubbleCellDoneReviewCheck]];
    self.doneReviewIconImageView.image = checkIconImage;
    
    //Set view button to not review
    self.doneReviewView.alpha = 0.0f;
    self.notReviewView.alpha = 1.0f;
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
        
    NSString *bodyString = message.body;
    bodyString = [TTLUtil nullToEmptyString:bodyString];
    self.titleLabel.text = bodyString;
    
    NSString *thumbnailImageString = @"";
    TAPUserModel *obtainedUser = message.user;
    if (obtainedUser != nil && ![obtainedUser.imageURL.thumbnail isEqualToString:@""]) {
        thumbnailImageString = obtainedUser.imageURL.thumbnail;
        thumbnailImageString = [TTLUtil nullToEmptyString:thumbnailImageString];
    }
    else {
        thumbnailImageString = message.user.imageURL.thumbnail;
        thumbnailImageString = [TTLUtil nullToEmptyString:thumbnailImageString];
    }
        
    NSString *fullNameString = @"";
    if (obtainedUser != nil && ![obtainedUser.fullname isEqualToString:@""]) {
        fullNameString = obtainedUser.fullname;
        fullNameString = [TTLUtil nullToEmptyString:fullNameString];
    }
    else {
        fullNameString = message.user.fullname;
        fullNameString = [TTLUtil nullToEmptyString:fullNameString];
    }
        
    if ([thumbnailImageString isEqualToString:@""]) {
        //No photo found, get the initial
        self.senderInitialView.alpha = 1.0f;
        self.senderImageView.alpha = 0.0f;
        self.senderInitialView.backgroundColor = [[TTLStyleManager sharedManager] getRandomDefaultAvatarBackgroundColorWithName:fullNameString];
        self.senderInitialLabel.text = [[TTLStyleManager sharedManager] getInitialsWithName:fullNameString isGroup:NO];
    }
    else {
        self.senderInitialView.alpha = 0.0f;
        self.senderImageView.alpha = 1.0f;
        [self.senderImageView setImageWithURLString:thumbnailImageString];
    }
        
    self.senderNameLabel.text = fullNameString;
    
    if ([messageUserID isEqualToString:activeUserID]) {
        //Message is ours
        self.bubbleView.clipsToBounds = YES;
        self.bubbleView.layer.cornerRadius = 8.0f;
        self.bubbleView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMinYCorner;
        
        self.bubbleView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorRightBubbleBackground];
        UIFont *bubbleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontRightBubbleMessageBody];
        UIColor *bubbleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorRightBubbleMessageBody];
        self.titleLabel.textColor = bubbleLabelColor;
        self.titleLabel.font = bubbleLabelFont;
        
        self.senderImageViewWidthConstraint.constant = 0.0f;
        self.senderImageViewTrailingConstraint.constant = 0.0f;
        self.senderProfileImageButtonWidthConstraint.constant = 0.0f;
        self.senderProfileImageButton.userInteractionEnabled = NO;
        
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
        self.bubbleView.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        
        self.bubbleView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorLeftBubbleBackground];
        UIFont *bubbleLabelFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontLeftBubbleMessageBody];
        UIColor *bubbleLabelColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorLeftBubbleMessageBody];
        self.titleLabel.textColor = bubbleLabelColor;
        self.titleLabel.font = bubbleLabelFont;
        
        self.senderImageViewWidthConstraint.constant = 30.0f;
        self.senderImageViewTrailingConstraint.constant = 4.0f;
        self.senderProfileImageButtonWidthConstraint.constant = 30.0f;
        self.senderProfileImageButton.userInteractionEnabled = YES;
        
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

- (IBAction)reviewButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:)]) {
        [self.delegate reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:self.currentMessage];
    }
}

- (IBAction)senderProfileImageButtonDidTapped:(id)sender {
    
}

@end
