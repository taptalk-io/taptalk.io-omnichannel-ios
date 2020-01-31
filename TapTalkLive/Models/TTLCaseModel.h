//
//  TTLCaseModel.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 19/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLCaseModel : TTLBaseModel

@property (nonatomic, strong) NSString *caseID;
@property (nonatomic, strong) NSString *stringID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *agentAccountID;
@property (nonatomic, strong) NSString *agentFullName;
@property (nonatomic, strong) NSString *tapTalkXCRoomID;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSString *firstMessage;
@property (nonatomic, strong) NSNumber *firstResponseTime;
@property (nonatomic, strong) NSString *firstResponseAgentAccountID;
@property (nonatomic, strong) NSString *firstResponseAgentFullName;
@property (nonatomic) BOOL isClosed;
@property (nonatomic, strong) NSNumber *closedTime;
@property (nonatomic, strong) NSNumber *createdTime;
@property (nonatomic, strong) NSNumber *updatedTime;
@property (nonatomic, strong) NSNumber *deletedTime;

@end

NS_ASSUME_NONNULL_END
