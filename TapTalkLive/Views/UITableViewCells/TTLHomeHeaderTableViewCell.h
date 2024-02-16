//
//  HomeHeaderTableViewCell.h
//  TapTalkLive
//
//  Created by Fikri on 3/1/23.
//

#import "TTLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTLHomeHeaderTableViewCellDelegate <NSObject>

- (void)homeHeaderCellSeeAllMessagesButtonTapped;
- (void)homeHeaderOpenNewMessageForm;
- (void)homeHeaderCellCloseButtonTapped;
- (void)homeHeaderCaseListTapped:(TAPMessageModel *)lastMessage cell:(id)cell;

@end

@interface TTLHomeHeaderTableViewCell : TTLBaseTableViewCell

@property (weak, nonatomic) id<TTLHomeHeaderTableViewCellDelegate> delegate;

- (void)hideMessageHistoryView;
- (void)hideChannelContainer;
- (void)hideChannelList;
- (void)hideSendDirectly;
- (void)updateLatestCaseCellView:(TAPMessageModel *)message;

@end

NS_ASSUME_NONNULL_END
