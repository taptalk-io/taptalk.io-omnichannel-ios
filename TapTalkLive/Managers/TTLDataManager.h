//
//  TTLDataManager.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLUserModel.h"
#import "TTLCaseModel.h"
#import "TTLTopicModel.h"

@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

@interface TTLDataManager : NSObject

+ (TTLDataManager *)sharedManager;
+ (void)setActiveUser:(TTLUserModel *)user;
+ (TTLUserModel *)getActiveUser;
+ (void)setAccessToken:(NSString *)accessToken expiryDate:(NSTimeInterval)expiryDate;
+ (NSString *)getAccessToken;
+ (NSTimeInterval)getAccessTokenExpiryTime;
+ (void)setRefreshToken:(NSString *)refreshToken expiryDate:(NSTimeInterval)expiryDate;
+ (NSString *)getRefreshToken;


//API Call
+ (void)callAPICreateUserWithFullName:(NSString *)fullName
                                email:(NSString *)email
                              success:(void (^)(TTLUserModel *user, NSString *ticket))success
                              failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetCurrentUserProfileSuccess:(void (^)(TTLUserModel *user))success
                                    failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetAccessTokenWithTicket:(NSString *)ticket
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure;
- (void)callAPIRefreshAccessTokenSuccess:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetTapTalkLiveProjectConfigsSuccess:(void (^)(NSDictionary *tapTalkConfigsDictionary))success
                                           failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetTapTalkAuthTicketSuccess:(void (^)(NSString *tapTalkAuthTicket))success
                                   failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetTopicListSuccess:(void (^)(NSArray<TTLTopicModel *> *topicListArray))success
                           failure:(void (^)(NSError *error))failure;
+ (void)callAPICreateCaseWithTopicID:(NSString *)topicID
                             message:(NSString *)message
                             success:(void (^)(TTLCaseModel *caseData))success
                             failure:(void (^)(NSError *error))failure;
+ (void)callAPICloseCaseWithTopicID:(NSString *)topicID
                            success:(void (^)(BOOL isSuccess))success
                            failure:(void (^)(NSError *error))failure;
+ (void)callAPIGetCaseDetailWithCaseID:(NSString *)caseID
                               success:(void (^)(TTLCaseModel *caseData))success
                               failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
