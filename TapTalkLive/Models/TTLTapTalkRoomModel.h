//
//  TTLTapTalkRoomModel.h
//  TapTalkLive
//
//  Created by Kevin on 6/22/22.
//

#import "TTLBaseModel.h"
#import <TapTalk/TAPMessageModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLTapTalkRoomModel : TTLBaseModel

@property (nonatomic, strong) TAPMessageModel *lastMessage;
@property (nonatomic) NSInteger unreadCount;

@end

NS_ASSUME_NONNULL_END
