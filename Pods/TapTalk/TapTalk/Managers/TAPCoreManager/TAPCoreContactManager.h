//
//  TAPCoreContactManager.h
//  TapTalk
//
//  Created by Dominic Vedericho on 30/07/19.
//  Copyright © 2019 Moselo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAPCoreContactManager : NSObject

+ (TAPCoreContactManager *)sharedManager;

- (void)getAllUserContactsWithSuccess:(void (^)(NSArray <TAPUserModel *>*userArray))success
                              failure:(void (^)(NSError *error))failure;
- (void)getUserDataWithUserID:(NSString *)userID
                      success:(void (^)(TAPUserModel *user))success
                      failure:(void (^)(NSError *error))failure;
- (void)getUserDataWithXCUserID:(NSString *)xcUserID
                        success:(void (^)(TAPUserModel *user))success
                        failure:(void (^)(NSError *error))failure;
- (void)saveUserData:(TAPUserModel *)user;
- (void)addToTapTalkContactsWithUserID:(NSString *)userID
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;
- (void)addToTapTalkContactsWithPhoneNumber:(NSString *)phoneNumber
                                    success:(void (^)(void))success
                                    failure:(void (^)(NSError *error))failure;
- (void)removeFromTapTalkContactsWithUserID:(NSString *)userID
                                    success:(void (^)(NSString *successMessage))success
                                    failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
