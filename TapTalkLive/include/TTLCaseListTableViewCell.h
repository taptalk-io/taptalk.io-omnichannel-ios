//
//  TTLCaseListTableViewCell.h
//  TapTalkLive
//
//  Created by Kevin on 1/24/24.
//

#import "TTLBaseTableViewCell.h"
#import "TAPRoomListModel.h"

typedef NS_ENUM(NSInteger, TTLMessageStatusType) {
    TTLMessageStatusTypeNone = 0,
    TTLMessageStatusTypeSending = 1,
    TTLMessageStatusTypeSent = 2,
    TTLMessageStatusTypeDelivered = 3,
    TTLMessageStatusTypeRead = 4,
    TTLMessageStatusTypeFailed = 5,
    TTLMessageStatusTypeDeleted = 6,
};

NS_ASSUME_NONNULL_BEGIN

@protocol TTLCaseListTableViewCellDelegate <NSObject>

@optional

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
