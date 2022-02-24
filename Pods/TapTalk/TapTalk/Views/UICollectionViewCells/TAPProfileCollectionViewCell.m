//
//  TAPProfileCollectionViewCell.m
//  TapTalk
//
//  Created by Dominic Vedericho on 31/10/18.
//  Copyright © 2018 Moselo. All rights reserved.
//

#import "TAPProfileCollectionViewCell.h"

@interface TAPProfileCollectionViewCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *rightIconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UISwitch *switchButton;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation TAPProfileCollectionViewCell

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0f, (CGRectGetHeight(frame) - 32.0f) / 2.0f, 32.0f, 32.0f)];
        self.iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.iconImageView];
        
        _rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 24.0f - 16.0f, (CGRectGetHeight(frame) - 24.0f) / 2.0f, 24.0f, 24.0f)];
        self.rightIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.rightIconImageView setImage:[UIImage imageNamed:@"TAPIconRightArrowCell" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.rightIconImageView.image = [self.rightIconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChevronRightGray]];

        [self.contentView addSubview:self.rightIconImageView];
        
        CGFloat rightPadding = 16.0f;
        CGFloat switchWidth = 51.0f;
        CGFloat switchHeight = 31.0f;
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - rightPadding - switchWidth, (CGRectGetHeight(frame) - switchHeight) / 2.0f, switchWidth, switchHeight)];
        self.switchButton.onTintColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorSwitchActiveBackground];
        self.switchButton.layer.cornerRadius = CGRectGetHeight(self.switchButton.frame) / 2.0f;
        self.switchButton.layer.borderWidth = 1.0f;
        [self.switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.switchButton];
        
        UIFont *titleLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontChatProfileMenuLabel];
        UIColor *titleLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorChatProfileMenuLabel];
        CGFloat titleXPosition = CGRectGetMaxX(self.iconImageView.frame) + 4.0f; //4.0f is left padding of title
        CGFloat titleWidth = CGRectGetMinX(self.switchButton.frame) - 4.0f - titleXPosition; //4.0f is right padding of title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleXPosition, 0.0f, titleWidth, CGRectGetHeight(frame))];
        self.titleLabel.font = titleLabelFont;
        self.titleLabel.textColor = titleLabelColor;
        [self.contentView addSubview:self.titleLabel];
        
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame) - 1.0f, CGRectGetWidth(frame), 1.0f)];
        self.separatorView.backgroundColor = [TAPUtil getColor:TAP_COLOR_GREY_DC];
        [self.contentView addSubview:self.separatorView];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)showSeparatorView:(BOOL)isShowed {
    if (isShowed) {
        self.separatorView.alpha = 1.0f;
    }
    else {
        self.separatorView.alpha = 0.0f;
    }
}

- (void)setProfileCollectionViewCellType:(TAPProfileCollectionViewCellType)type {
    //DV Temp
    BOOL isMute = NO;
    BOOL isBlocked = YES;
    //End Temp
    
    UIColor *titleLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorChatProfileMenuLabel];
    UIColor *titleLabelDestructiveColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorChatProfileMenuDestructiveLabel];
    
    if (type == profileCollectionViewCellTypeNotification) {
        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Notification", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 1.0f;
        
        if (isMute) {
            [self.switchButton setOn:NO];
            self.switchButton.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorSwitchInactiveBackground].CGColor;
            
            [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconNotificationActive" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
            self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuNotificationActive]];

        }
        else {
            [self.switchButton setOn:YES];
            self.switchButton.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorSwitchActiveBackground].CGColor;
            
            [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconNotificationActive" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
            self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuNotificationInactive]];
        }
        
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeBlock) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconBlock" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuBlockUser]];
        
        self.titleLabel.textColor = titleLabelColor;
        
        self.switchButton.alpha = 0.0f;
        
        if (isBlocked) {
            self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Unblock User", nil, [TAPUtil currentBundle], @"");
        }
        else {
            self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Block User", nil, [TAPUtil currentBundle], @"");
        }
        
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeConversationColor) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconConversationColor" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuConversationColor]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Conversation Color", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeClearChat) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconTrash" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuClearChat]];

        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Clear Chat", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeLeaveGroup) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconTrash" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuClearChat]];
        
        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Leave Group", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeDeleteGroup) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconTrash" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        
        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Delete Group", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeViewGroupMembers) {
        
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconGroupMembers" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupProfileMenuViewMembers]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"View Group Members", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 1.0f;
    }
    else if (type == profileCollectionViewCellTypeRemoveMember) {
        
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconTrash" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuRemoveMember]];
        
        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Remove Member", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeAppointAsAdmin) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconAppointAdmin" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuPromoteAdmin]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Promote to Admin", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeRemoveFromAdmin) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconDemote" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuDemoteAdmin]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Demote from Admin", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeSendMessage) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconMessage" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuSendMessage]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Send Message", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeAddContacts) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconAddGrey" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuAddToContacts]];

        self.titleLabel.textColor = titleLabelColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Add to Contacts", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeReportUser) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconFlag" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuReportUserOrGroup]];
        
        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Report User", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    else if (type == profileCollectionViewCellTypeReportGroup) {
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconFlag" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconGroupMemberProfileMenuReportUserOrGroup]];
        
        self.titleLabel.textColor = titleLabelDestructiveColor;
        self.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Report Group", nil, [TAPUtil currentBundle], @"");
        
        self.switchButton.alpha = 0.0f;
        self.rightIconImageView.alpha = 0.0f;
    }
    
}

- (void)switchValueChanged:(id)sender {
    if ([sender isOn]) {
        //CHANGED TO ON
        self.switchButton.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorSwitchActiveBackground].CGColor;
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconNotificationActive" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuNotificationActive]];
    }
    else {
        //CHANGED TO OFF
        self.switchButton.layer.borderColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorSwitchInactiveBackground].CGColor;
        [self.iconImageView setImage:[UIImage imageNamed:@"TAPIconNotificationActive" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil]];
        self.iconImageView.image = [self.iconImageView.image setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconChatProfileMenuNotificationInactive]];
    }
}

@end
