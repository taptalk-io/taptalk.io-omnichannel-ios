//
//  TTLCaseListTableViewCell.h
//  TapTalkLive
//
//  Created by Kevin on 1/24/24.
//

#import "TTLBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, TAPMessageStatusType) {
    TAPMessageStatusTypeNone = 0,
    TAPMessageStatusTypeSending = 1,
    TAPMessageStatusTypeSent = 2,
    TAPMessageStatusTypeDelivered = 3,
    TAPMessageStatusTypeRead = 4,
    TAPMessageStatusTypeFailed = 5,
    TAPMessageStatusTypeDeleted = 6,
};

NS_ASSUME_NONNULL_BEGIN

@protocol TTLCaseListTableViewCellDelegate <NSObject>

- (void)caseListTableViewCellDidTapped:(TAPRoomListModel *)caseModel;

@end

@interface TTLCaseListTableViewCell : TTLBaseTableViewCell

@property (weak, nonatomic) id<TTLCaseListTableViewCellDelegate> delegate;
@property (strong, nonatomic) TAPRoomListModel *roomListModel;

- (void)setData:(TAPRoomListModel *)roomListModel;
- (void)setFirstIndexLayout:(BOOL)isFirstIndex;
- (void)setLastIndexLayout:(BOOL)isLastIndex;
- (void)showLastMessage;
- (void)showTypingState;

@end

NS_ASSUME_NONNULL_END
