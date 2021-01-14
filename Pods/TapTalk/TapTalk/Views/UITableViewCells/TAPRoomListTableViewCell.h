//
//  TAPRoomListTableViewCell.h
//  TapTalk
//
//  Created by Dominic Vedericho on 6/9/18.
//  Copyright © 2018 Moselo. All rights reserved.
//

#import "TAPBaseTableViewCell.h"
#import "TAPRoomListModel.h"

typedef NS_ENUM(NSInteger, TAPMessageStatusType) {
    TAPMessageStatusTypeNone = 0,
    TAPMessageStatusTypeSending = 1,
    TAPMessageStatusTypeSent = 2,
    TAPMessageStatusTypeDelivered = 3,
    TAPMessageStatusTypeRead = 4,
    TAPMessageStatusTypeFailed = 5,
    TAPMessageStatusTypeDeleted = 6,
};

@interface TAPRoomListTableViewCell : TAPBaseTableViewCell

- (void)setRoomListTableViewCellWithData:(TAPRoomListModel *)roomList updateUnreadBubble:(BOOL)updateUnreadBubble;
- (void)setAsTyping:(BOOL)typing;
- (void)showMessageDraftWithMessage:(NSString *)draftMessage;
- (void)setIsLastCellSeparator:(BOOL)isLastCell;
- (void)showUnreadMentionBadge:(BOOL)isShow;

@end
