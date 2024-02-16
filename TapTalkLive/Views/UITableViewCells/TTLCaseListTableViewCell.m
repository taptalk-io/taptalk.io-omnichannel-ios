//
//  TTLCaseListTableViewCell.m
//  TapTalkLive
//
//  Created by Kevin on 1/24/24.
//

#import "TTLCaseListTableViewCell.h"
#import <TapTalk/TapUI.h>
#import <TapTalk/TAPChatManager.h>
#import <TapTalk/TAPStyleManager.h>
#import <TapTalk/TAPUtil.h>

@interface TTLCaseListTableViewCell () <TTLImageViewDelegate>

@property IBOutlet NSLayoutConstraint *caseListCellTopConstraint;
@property IBOutlet NSLayoutConstraint *caseListCellBottomConstraint;

@property IBOutlet UIView *avatarContainerView;
@property IBOutlet UILabel *initialLabel;
@property IBOutlet TTLImageView *avatarImageView;

@property IBOutlet UILabel *topicLabel;
@property IBOutlet UILabel *timestampLabel;
@property IBOutlet UILabel *senderNameLabel;
@property IBOutlet UILabel *lastMessageLabel;

@property IBOutlet UIImageView *typingAnimationImageView;
@property IBOutlet NSLayoutConstraint *typingAnimationImageViewWidthConstraint;
@property IBOutlet NSLayoutConstraint *typingAnimationImageViewRightConstraint;

@property IBOutlet UILabel *unreadCountLabel;
@property IBOutlet UIImageView *lastMessageStatusIconImageView;
@property IBOutlet NSLayoutConstraint *lastMessageStatusViewWidthConstraint;
@property IBOutlet NSLayoutConstraint *lastMessageStatusViewLeftConstraint;

@property IBOutlet UIView *separatorView;


@end

@implementation TTLCaseListTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarContainerView.clipsToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = self.avatarContainerView.frame.size.width / 2;
    
    self.initialLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListAvatar];
    self.initialLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListAvatar];
    
    self.topicLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListTitle];
    self.topicLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListTitle];
    
    self.senderNameLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListSender];
    self.senderNameLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListSender];
    
    self.lastMessageLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListLastMessage];
    self.lastMessageLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListLastMessage];
    
    self.timestampLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListTimestamp];
    self.timestampLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListTimestamp];
    
    self.unreadCountLabel.clipsToBounds = YES;
    self.unreadCountLabel.layer.cornerRadius = self.unreadCountLabel.frame.size.width / 2;
    
    self.unreadCountLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontCaseListUnreadCount];
    self.unreadCountLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorCaseListUnreadCount];
    
    self.typingAnimationImageView.animationImages = @[
        [UIImage imageNamed:@"TAPTypingSequence-1" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-2" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-3" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-4" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-5" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-6" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-7" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-8" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-9" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-10" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-11" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-12" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-13" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-14" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-15" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil],
        [UIImage imageNamed:@"TAPTypingSequence-16" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]
    ];
    self.typingAnimationImageView.animationDuration = 0.6f;
    self.typingAnimationImageView.animationRepeatCount = 0.0f;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarImageView.image = nil;
    self.initialLabel.alpha = 0.0f;
    self.avatarContainerView.backgroundColor = [UIColor clearColor];
//    self.typingAnimationImageView.alpha = 0.0f;
    [self.typingAnimationImageView stopAnimating];
    self.typingAnimationImageViewWidthConstraint.constant = 0.0f;
    self.typingAnimationImageViewRightConstraint.constant = 0.0f;
    self.topicLabel.text = @"";
    self.timestampLabel.text = @"";
    self.senderNameLabel.text = @"";
    self.lastMessageLabel.text = @"";
    self.lastMessageStatusIconImageView.alpha = 0.0f;
    self.unreadCountLabel.alpha = 0.0f;
    self.lastMessageStatusViewWidthConstraint.constant = 0.0f;
    self.lastMessageStatusViewLeftConstraint.constant = 0.0f;
}

#pragma mark - TTLImageViewDelegate

- (void)imageViewDidFinishLoadImage:(TTLImageView *)imageView {
    if (imageView.image != nil) {
        self.initialLabel.alpha = 0.0f;
        self.avatarContainerView.backgroundColor = [UIColor clearColor];
    }
    else {
        [self setInitial];
    }
}

#pragma mark - Public Methods

- (void)setData:(TAPRoomListModel *)roomListModel {
    _roomListModel = roomListModel;
    
    // Set initial / avatar
    [self setInitial];
    if ([TTLUtil isEmptyString:roomListModel.lastMessage.room.imageURL.thumbnail]) {
        [self.avatarImageView setImageWithURLString:roomListModel.lastMessage.room.imageURL.thumbnail];
    }
    else {
        self.avatarImageView.image = nil;
    }
    
    // Set room name
    self.topicLabel.text = roomListModel.lastMessage.room.name;
    NSMutableAttributedString *topicAttributedString = [[NSMutableAttributedString alloc] initWithString:self.topicLabel.text];
    [topicAttributedString addAttribute:NSKernAttributeName
                                  value:@-0.3f
                                  range:NSMakeRange(0, [self.topicLabel.text length])];
    self.topicLabel.attributedText = topicAttributedString;
    
    // Set sender name
    if (![TTLUtil isEmptyString:roomListModel.lastMessage.user.userID] &&
        [roomListModel.lastMessage.user.userID isEqualToString:[TAPChatManager sharedManager].activeUser.userID]
    ) {
        self.senderNameLabel.text = NSLocalizedStringFromTableInBundle(@"You", nil, [TTLUtil currentBundle], @"");
    }
    else {
        self.senderNameLabel.text = roomListModel.lastMessage.user.fullname;
    }
    NSMutableAttributedString *senderNameAttributedString = [[NSMutableAttributedString alloc] initWithString:self.senderNameLabel.text];
    [senderNameAttributedString addAttribute:NSKernAttributeName
                                       value:@-0.2f
                                       range:NSMakeRange(0, [self.senderNameLabel.text length])];
    self.senderNameLabel.attributedText = senderNameAttributedString;
    
    // Set last message timestamp
    self.timestampLabel.text = [self getTimestampString];
    NSMutableAttributedString *timestampAttributedString = [[NSMutableAttributedString alloc] initWithString:self.timestampLabel.text];
    [timestampAttributedString addAttribute:NSKernAttributeName
                                      value:@-0.2f
                                      range:NSMakeRange(0, [self.timestampLabel.text length])];
    self.timestampLabel.attributedText = timestampAttributedString;
    
    // Last message / typing state
    if ([[TAPChatManager sharedManager] checkIsTypingWithRoomID:roomListModel.lastMessage.room.roomID]) {
        [self showTypingState];
    }
    else {
        [self showLastMessageAnimated:NO];
    }
}

- (void)setFirstIndexLayout:(BOOL)isFirstIndex {
    if (isFirstIndex) {
        self.caseListCellTopConstraint.constant = 16.0f;
    }
    else {
        self.caseListCellTopConstraint.constant = 12.0f;
    }
}

- (void)setLastIndexLayout:(BOOL)isLastIndex {
    if (isLastIndex) {
        self.caseListCellBottomConstraint.constant = 16.0f;
        self.separatorView.alpha = 0.0f;
    }
    else {
        self.caseListCellBottomConstraint.constant = 0.0f;
        self.separatorView.alpha = 1.0f;
    }
}

- (void)showLastMessage {
    [self showLastMessageAnimated:YES];
}

- (void)showLastMessageAnimated:(BOOL)animated {
    NSTimeInterval animationDuration = 0.2f;
    if (!animated) {
        animationDuration = 0.0f;
    }
    [UIView animateWithDuration:animationDuration animations:^{
//        self.typingAnimationImageView.alpha = 0.0f;
        self.typingAnimationImageViewWidthConstraint.constant = 0.0f;
        self.typingAnimationImageViewRightConstraint.constant = 0.0f;
        [self layoutIfNeeded];
    }];
    [self.typingAnimationImageView stopAnimating];
    NSString *draft = [[TAPChatManager sharedManager].messageDraftDictionary objectForKey:self.roomListModel.lastMessage.room.roomID];
    if (![TTLUtil isEmptyString:draft]) {
        // Show draft
        self.lastMessageLabel.text = [NSString stringWithFormat:@"Draft: %@", draft];
    }
    else if (self.roomListModel.lastMessage.isDeleted) {
        if ([self isMessageFromActiveUser]) {
            self.lastMessageLabel.text = NSLocalizedStringFromTableInBundle(@"You deleted this message.", nil, [TTLUtil currentBundle], @"");
        }
        else {
            self.lastMessageLabel.text = NSLocalizedStringFromTableInBundle(@"This message was deleted.", nil, [TTLUtil currentBundle], @"");
        }
    }
    else {
        self.lastMessageLabel.text = self.roomListModel.lastMessage.body;
        
        if (self.roomListModel.numberOfUnreadMessages > 0) {
            // Show unread count
            self.unreadCountLabel.text = [NSString stringWithFormat:@"%ld", self.roomListModel.numberOfUnreadMessages];
            [UIView animateWithDuration:animationDuration animations:^{
                self.unreadCountLabel.alpha = 1.0f;
                self.lastMessageStatusIconImageView.alpha = 0.0f;
                self.lastMessageStatusViewWidthConstraint.constant = 24.0f;
                self.lastMessageStatusViewLeftConstraint.constant = 8.0f;
            }];
        }
        else if ([TTLUtil isEmptyString:draft] && [self isMessageFromActiveUser]) {
            // Show status icon
            [self setMessageStatusIcon];
        }
        else {
            // Hide last message status
            [UIView animateWithDuration:animationDuration animations:^{
                self.unreadCountLabel.alpha = 0.0f;
                self.lastMessageStatusIconImageView.alpha = 0.0f;
                self.lastMessageStatusViewWidthConstraint.constant = 0.0f;
                self.lastMessageStatusViewLeftConstraint.constant = 0.0f;
            }];
        }
    }
    NSMutableAttributedString *lastMessageAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lastMessageLabel.text];
    [lastMessageAttributedString addAttribute:NSKernAttributeName
                                        value:@-0.2f
                                        range:NSMakeRange(0, [self.lastMessageLabel.text length])];
    self.lastMessageLabel.attributedText = lastMessageAttributedString;
}

- (void)showTypingState {
    [self.typingAnimationImageView startAnimating];
    self.typingAnimationImageView.alpha = 1.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.typingAnimationImageViewWidthConstraint.constant = 16.0f;
        self.typingAnimationImageViewRightConstraint.constant = 4.0f;
        self.unreadCountLabel.alpha = 0.0f;
        self.lastMessageStatusIconImageView.alpha = 0.0f;
        self.lastMessageStatusViewWidthConstraint.constant = 0.0f;
        self.lastMessageStatusViewLeftConstraint.constant = 0.0f;
        [self layoutIfNeeded];
    }];
    self.lastMessageLabel.text = NSLocalizedStringFromTableInBundle(@"typing", nil, [TTLUtil currentBundle], @"");
    [self performSelector:@selector(showLastMessage) withObject:nil afterDelay:15.0f];
}

#pragma mark - Private Methods

- (void)setInitial {
    NSString *roomName = self.roomListModel.lastMessage.room.name;
    roomName = [TTLUtil nullToEmptyString:roomName];
    self.avatarContainerView.backgroundColor = [[TAPStyleManager sharedManager] getRandomDefaultAvatarBackgroundColorWithName:roomName];
    self.initialLabel.text = [[TAPStyleManager sharedManager] getInitialsWithName:roomName isGroup:YES];
    self.initialLabel.alpha = 1.0f;
}

- (void)setMessageStatusIcon {
    TTLMessageStatusType statusType = TTLMessageStatusTypeNone;
    NSString *currentUserID = [TAPChatManager sharedManager].activeUser.userID;
    if ([self.roomListModel.lastMessage.user.userID isEqualToString:currentUserID]) {
        //last message is from ourself
        if (self.roomListModel.lastMessage.isRead) {
            statusType = TTLMessageStatusTypeRead;
        }
        else if (self.roomListModel.lastMessage.isDelivered) {
            statusType = TTLMessageStatusTypeDelivered;
        }
        else if (self.roomListModel.lastMessage.isSending) {
            statusType = TTLMessageStatusTypeSending;
        }
        else if (self.roomListModel.lastMessage.isFailedSend) {
            statusType = TTLMessageStatusTypeFailed;
        }
        else if (self.roomListModel.lastMessage.isDeleted) {
            statusType = TTLMessageStatusTypeDeleted;
        }
        else {
            statusType = TTLMessageStatusTypeSent;
        }
    }
    switch (statusType) {
        case TTLMessageStatusTypeNone:
        {
            self.lastMessageStatusIconImageView.alpha = 0.0f;
            break;
        }
        case TTLMessageStatusTypeSending:
        {
            self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconSending" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            break;
        }
        case TTLMessageStatusTypeSent:
        {
            self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconSent" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            break;
        }
        case TTLMessageStatusTypeDelivered:
        {
            self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconDelivered" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            break;
        }
        case TTLMessageStatusTypeRead:
        {
            // Check if show read status
            BOOL isHideReadStatus = [[TapUI sharedInstance] getReadStatusHiddenState];
            if (isHideReadStatus) {
                // Set to delivered icon
                self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconDelivered" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            }
            else {
                // Set to read icon
                self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconRead" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            }
            
            break;
        }
        case TTLMessageStatusTypeFailed:
        {
            self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconFailed" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            break;
        }
        case TTLMessageStatusTypeDeleted:
        {
            self.lastMessageStatusIconImageView.image = [UIImage imageNamed:@"TAPIconBlock" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
            break;
        }
    }
    if (self.lastMessageStatusIconImageView.image != nil) {
        [UIView animateWithDuration:0.2f animations:^{
            self.lastMessageStatusIconImageView.alpha = 1.0f;
            self.unreadCountLabel.alpha = 0.0f;
            self.lastMessageStatusIconImageView.alpha = 1.0f;
            self.lastMessageStatusViewWidthConstraint.constant = 24.0f;
            self.lastMessageStatusViewLeftConstraint.constant = 8.0f;
        }];
    }
    else {
        [UIView animateWithDuration:0.2f animations:^{
            self.lastMessageStatusIconImageView.alpha = 0.0f;
            self.unreadCountLabel.alpha = 0.0f;
            self.lastMessageStatusIconImageView.alpha = 0.0f;
            self.lastMessageStatusViewWidthConstraint.constant = 0.0f;
            self.lastMessageStatusViewLeftConstraint.constant = 0.0f;
        }];
    }
}

- (BOOL)isMessageFromActiveUser {
    return ![TTLUtil isEmptyString:self.roomListModel.lastMessage.user.userID] && [self.roomListModel.lastMessage.user.userID isEqualToString:[TAPChatManager sharedManager].activeUser.userID];
}

- (NSString *)getTimestampString {
    NSTimeInterval lastMessageTimeInterval = [self.roomListModel.lastMessage.created doubleValue] / 1000.0f; // change to second from milisecond
    NSDate *lastMessageDate = [NSDate dateWithTimeIntervalSince1970:lastMessageTimeInterval];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
    
    NSTimeInterval timeGap = currentTimeInterval - lastMessageTimeInterval;
    
    NSDateFormatter *midnightDateFormatter = [[NSDateFormatter alloc] init];
    [midnightDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]; // POSIX to avoid weird issues
    midnightDateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString *midnightFormattedCreatedDate = [midnightDateFormatter stringFromDate:currentDate];
    
    NSDate *todayMidnightDate = [midnightDateFormatter dateFromString:midnightFormattedCreatedDate];
    NSTimeInterval midnightTimeInterval = [todayMidnightDate timeIntervalSince1970];
    
    NSTimeInterval midnightTimeGap = currentTimeInterval - midnightTimeInterval;
    
    NSString *timeString = @"";
    if (timeGap <= midnightTimeGap) {
        // Today
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:lastMessageDate];
        timeString = dateString;
    }
    else if (timeGap <= 86400.0f + midnightTimeGap) {
        // Yesterday
        timeString = NSLocalizedStringFromTableInBundle(@"Yesterday", nil, [TTLUtil currentBundle], @"");
    }
    else {
        // Set date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        
        NSString *dateString = [dateFormatter stringFromDate:lastMessageDate];
        
        timeString = dateString;
    }
    
    return timeString;
}

@end
