//
//  TTLAPIManager.m
//  TapTalk
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 TapTalk. All rights reserved.
//

#import "TTLAPIManager.h"

static NSString * const kAPIBaseURLString = @"https://taplive-api-dev.taptalk.io/api/visitor"; //DV Temp
static NSString * const kAPIVersionString = @"v1";

@interface TTLAPIManager ()

@property (strong, nonatomic) NSString *APIBaseURL;

@end

@implementation TTLAPIManager

#pragma mark - Lifecycle
+ (TTLAPIManager *)sharedManager {
    static TTLAPIManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[TTLAPIManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _APIBaseURL = [NSString string];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setBaseAPIURLString:(NSString *)urlString {
    _APIBaseURL = urlString;
}

- (NSString *)urlForType:(TTLAPIManagerType)type {
    if (type == TTLAPIManagerTypeGetAccessToken) {
        NSString *apiPath = @"auth/access_token/request";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeRefreshAccessToken) {
        NSString *apiPath = @"auth/access_token/refresh";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetTapTalkAuthTicket) {
        NSString *apiPath = @"client/taptalk/request_auth_ticket";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetProjectConfigs) {
        NSString *apiPath = @"client/project/get_configs";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetServerTime) {
        NSString *apiPath = @"client/server_time";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeLogout) {
        NSString *apiPath = @"logout";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeCreateUser) {
        NSString *apiPath = @"client/user/create";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetTopicList) {
        NSString *apiPath = @"client/topic/get_list";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetUserProfile) {
        NSString *apiPath = @"client/user/get";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeCreateCase) {
        NSString *apiPath = @"client/case/create";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeCloseCase) {
        NSString *apiPath = @"client/case/close";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetCaseList) {
        NSString *apiPath = @"client/case/get_list";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeGetCaseDetails) {
        NSString *apiPath = @"client/case/get_by_id";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }
    else if (type == TTLAPIManagerTypeRateConversation) {
        NSString *apiPath = @"client/case/rate";
        return [NSString stringWithFormat:@"%@/%@/%@", kAPIBaseURLString, kAPIVersionString, apiPath];
    }

    
    return [NSString stringWithFormat:@"%@", kAPIBaseURLString];
}

@end
