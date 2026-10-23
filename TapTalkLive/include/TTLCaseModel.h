//
//  TTLCaseModel.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 19/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseModel.h"
#import "TTLTapTalkRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLCaseModel : TTLBaseModel

@property (nonatomic, strong) NSString *caseID;
@property (nonatomic, strong) NSString *stringID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userAlias;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *agentAccountID;
@property (nonatomic, strong) NSString *agentFullName;
@property (nonatomic, strong) NSString *tapTalkXCRoomID;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSNumber *mediumChannelID;
@property (nonatomic, strong) NSString *firstMessage;
@property (nonatomic, strong) NSNumber *firstResponseTime;
@property (nonatomic, strong) NSString *firstResponseAgentAccountID;
@property (nonatomic, strong) NSString *firstResponseAgentFullName;
@property (nonatomic, strong) NSString *agentRemark;
//@property (nonatomic, strong) NSArray<NSNumber *> *labelIDs;
@property (nonatomic, strong) NSNumber *creatorAgentAccountID;
@property (nonatomic, strong) NSNumber *firstUserReplyTime;
@property (nonatomic, strong) NSNumber *closedTime;
@property (nonatomic, strong) NSNumber *createdTime;
@property (nonatomic, strong) NSNumber *updatedTime;
@property (nonatomic, strong) NSNumber *deletedTime;
@property (nonatomic, strong) TTLTapTalkRoomModel *tapTalkRoom;
@property (nonatomic) BOOL isCreatedByAgent;
@property (nonatomic) BOOL isClosed;
@property (nonatomic) BOOL isJunk;

@end

NS_ASSUME_NONNULL_END
