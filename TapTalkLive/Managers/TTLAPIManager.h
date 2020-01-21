//
//  TTLAPIManager.h
//  TapTalk
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 TapTalk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TTLAPIManagerType) {
    TTLAPIManagerTypeGetAccessToken,
    TTLAPIManagerTypeRefreshAccessToken,
    TTLAPIManagerTypeGetTapTalkAuthTicket,
    TTLAPIManagerTypeGetProjectConfigs,
    TTLAPIManagerTypeGetServerTime,
    TTLAPIManagerTypeLogout,
    TTLAPIManagerTypeCreateUser,
    TTLAPIManagerTypeGetTopicList,
    TTLAPIManagerTypeGetUserProfile,
    TTLAPIManagerTypeCreateCase,
    TTLAPIManagerTypeCloseCase,
    TTLAPIManagerTypeGetCaseDetails,
    TTLAPIManagerTypeRateConversation,
};

@interface TTLAPIManager : NSObject

+ (TTLAPIManager *)sharedManager;
- (NSString *)urlForType:(TTLAPIManagerType)type;
- (void)setBaseAPIURLString:(NSString *)urlString;

@end
