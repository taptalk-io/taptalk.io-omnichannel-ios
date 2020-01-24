//
//  TTLDataManager.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLDataManager.h"
#import "TTLAPIManager.h"

@interface TTLDataManager()

@property (strong, nonatomic) NSLock *refreshTokenLock;
@property (nonatomic) BOOL isShouldRefreshToken;

@end

@implementation TTLDataManager

#pragma mark - Lifecycle
+ (TTLDataManager *)sharedManager {
    static TTLDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _refreshTokenLock = [NSLock new];
    }
    
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark - Custom Method
+ (void)logErrorStringFromError:(NSError *)error {
    NSString *dataString = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"Error Response: %@", dataString);
#endif
}

+ (BOOL)isDataEmpty:(NSDictionary *)responseDictionary {
    NSDictionary *dataDictionary = [responseDictionary objectForKey:@"data"];
    
    if (dataDictionary == nil || [dataDictionary allKeys].count == 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isResponseSuccess:(NSDictionary *)responseDictionary {
    NSDictionary *errorDictionary = [responseDictionary objectForKey:@"error"];
    
    if (errorDictionary == nil || [errorDictionary allKeys].count == 0) {
        return YES;
    }
    
    NSInteger httpStatusCode = [[responseDictionary valueForKeyPath:@"status"] integerValue];
    if ([[NSString stringWithFormat:@"%li", (long)httpStatusCode] hasPrefix:@"2"]) {
        return YES;
    }
    
    return NO;
}

+ (void)setActiveUser:(TTLUserModel *)user {
    if (user != nil) {
        NSDictionary *userDictionary = [user toDictionary];
        [[NSUserDefaults standardUserDefaults] setSecureObject:userDictionary forKey:TTL_PREFS_ACTIVE_USER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (TTLUserModel *)getActiveUser {
    NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_ACTIVE_USER valid:nil];
    
    if (userDictionary == nil) {
        return nil;
    }
    
    TTLUserModel *user = [[TTLUserModel alloc] initWithDictionary:userDictionary error:nil];
    return user;
}

+ (void)setAccessToken:(NSString *)accessToken expiryDate:(NSTimeInterval)expiryDate {
    accessToken = [TTLUtil nullToEmptyString:accessToken];
    
    [[NSUserDefaults standardUserDefaults] setSecureObject:accessToken forKey:TTL_PREFS_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setSecureDouble:expiryDate forKey:TTL_PREFS_ACCESS_TOKEN_EXPIRED_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAccessToken {
    return [TTLUtil nullToEmptyString:[[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_ACCESS_TOKEN valid:nil]];
}

+ (NSTimeInterval)getAccessTokenExpiryTime {
    NSTimeInterval expiryTime = [[NSUserDefaults standardUserDefaults] secureDoubleForKey:TTL_PREFS_ACCESS_TOKEN_EXPIRED_TIME valid:nil];
    return expiryTime;
}

+ (void)setRefreshToken:(NSString *)refreshToken expiryDate:(NSTimeInterval)expiryDate {
    refreshToken = [TTLUtil nullToEmptyString:refreshToken];
    
    [[NSUserDefaults standardUserDefaults] setSecureObject:refreshToken forKey:TTL_PREFS_REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] setSecureDouble:expiryDate forKey:TTL_PREFS_REFRESH_TOKEN_EXPIRED_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRefreshToken {
    return [TTLUtil nullToEmptyString:[[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_REFRESH_TOKEN valid:nil]];
}

#pragma mark - API Call
+ (void)callAPICreateUserWithFullName:(NSString *)fullName
                                email:(NSString *)email
                              success:(void (^)(TTLUserModel *user, NSString *ticket))success
                              failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeCreateUser];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:fullName forKey:@"fullName"];
    [parameterDictionary setObject:email forKey:@"email"];
    
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPICreateUserWithFullName:fullName email:email success:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success([TTLUserModel new], @"");
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSString *ticket = [dataDictionary objectForKey:@"ticket"];
        ticket = [TTLUtil nullToEmptyString:ticket];
        
        NSDictionary *userDictionary = [dataDictionary objectForKey:@"user"];
        userDictionary = [TTLUtil nullToEmptyDictionary:userDictionary];
        
        TTLUserModel *user = [TTLUserModel new];
        
        NSString *userID = [userDictionary objectForKey:@"userID"];
        userID = [TTLUtil nullToEmptyString:userID];
        user.userID = userID;
        
        NSString *fullName = [userDictionary objectForKey:@"fullName"];
        fullName = [TTLUtil nullToEmptyString:fullName];
        user.fullName = fullName;
        
        NSString *source = [userDictionary objectForKey:@"source"];
        source = [TTLUtil nullToEmptyString:source];
        user.source = source;
        
        NSString *customerUserID = [userDictionary objectForKey:@"customerUserID"];
        customerUserID = [TTLUtil nullToEmptyString:customerUserID];
        user.customerUserID = customerUserID;
        
        NSString *whatsappUserID = [userDictionary objectForKey:@"whatsappUserID"];
        whatsappUserID = [TTLUtil nullToEmptyString:whatsappUserID];
        user.whatsappUserID = whatsappUserID;
        
        NSString *telegramUserID = [userDictionary objectForKey:@"telegramUserID"];
        telegramUserID = [TTLUtil nullToEmptyString:telegramUserID];
        user.telegramUserID = telegramUserID;
        
        NSString *lineUserID = [userDictionary objectForKey:@"lineUserID"];
        lineUserID = [TTLUtil nullToEmptyString:lineUserID];
        user.lineUserID = lineUserID;

        NSString *twitterUserID = [userDictionary objectForKey:@"twitterUserID"];
        twitterUserID = [TTLUtil nullToEmptyString:twitterUserID];
        user.twitterUserID = twitterUserID;
        
        NSString *facebookPSID = [userDictionary objectForKey:@"facebookPSID"];
        facebookPSID = [TTLUtil nullToEmptyString:facebookPSID];
        user.facebookPSID = facebookPSID;
        
        NSString *email = [userDictionary objectForKey:@"email"];
        email = [TTLUtil nullToEmptyString:email];
        user.email = email;
        
        BOOL isEmailVerified = [[userDictionary objectForKey:@"isEmailVerified"] boolValue];
        user.isEmailVerified = isEmailVerified;
        
        NSString *phone = [userDictionary objectForKey:@"phone"];
        phone = [TTLUtil nullToEmptyString:phone];
        user.phone = phone;
        
        BOOL isPhoneVerified = [[userDictionary objectForKey:@"isPhoneVerified"] boolValue];
        user.isPhoneVerified = isPhoneVerified;
        
        NSString *photoURL = [userDictionary objectForKey:@"photoURL"];
        photoURL = [TTLUtil nullToEmptyString:photoURL];
        user.photoURL = photoURL;
        
        NSString *mergedToUserID = [userDictionary objectForKey:@"mergedToUserID"];
        mergedToUserID = [TTLUtil nullToEmptyString:mergedToUserID];
        user.mergedToUserID = mergedToUserID;
        
        NSNumber *mergedTime = [userDictionary objectForKey:@"mergedTime"];
        mergedTime = [TTLUtil nullToEmptyNumber:mergedTime];
        user.mergedTime = mergedTime;
        
        NSNumber *createdTime = [userDictionary objectForKey:@"createdTime"];
        createdTime = [TTLUtil nullToEmptyNumber:createdTime];
        user.createdTime = createdTime;
        
        NSNumber *updatedTime = [userDictionary objectForKey:@"updatedTime"];
        updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
        user.updatedTime = updatedTime;
        
        NSNumber *deletedTime = [userDictionary objectForKey:@"deletedTime"];
        deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
        user.deletedTime = deletedTime;
    
        success(user, ticket);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetCurrentUserProfileSuccess:(void (^)(TTLUserModel *user))success
                                    failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeCreateUser];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPIGetCurrentUserProfileSuccess:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success([TTLUserModel new]);
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSDictionary *userDictionary = [dataDictionary objectForKey:@"user"];
        userDictionary = [TTLUtil nullToEmptyDictionary:userDictionary];
        
        TTLUserModel *user = [TTLUserModel new];
        
        NSString *userID = [userDictionary objectForKey:@"userID"];
        userID = [TTLUtil nullToEmptyString:userID];
        user.userID = userID;
        
        NSString *fullName = [userDictionary objectForKey:@"fullName"];
        fullName = [TTLUtil nullToEmptyString:fullName];
        user.fullName = fullName;
        
        NSString *source = [userDictionary objectForKey:@"source"];
        source = [TTLUtil nullToEmptyString:source];
        user.source = source;
        
        NSString *customerUserID = [userDictionary objectForKey:@"customerUserID"];
        customerUserID = [TTLUtil nullToEmptyString:customerUserID];
        user.customerUserID = customerUserID;
        
        NSString *whatsappUserID = [userDictionary objectForKey:@"whatsappUserID"];
        whatsappUserID = [TTLUtil nullToEmptyString:whatsappUserID];
        user.whatsappUserID = whatsappUserID;
        
        NSString *telegramUserID = [userDictionary objectForKey:@"telegramUserID"];
        telegramUserID = [TTLUtil nullToEmptyString:telegramUserID];
        user.telegramUserID = telegramUserID;
        
        NSString *lineUserID = [userDictionary objectForKey:@"lineUserID"];
        lineUserID = [TTLUtil nullToEmptyString:lineUserID];
        user.lineUserID = lineUserID;

        NSString *twitterUserID = [userDictionary objectForKey:@"twitterUserID"];
        twitterUserID = [TTLUtil nullToEmptyString:twitterUserID];
        user.twitterUserID = twitterUserID;
        
        NSString *facebookPSID = [userDictionary objectForKey:@"facebookPSID"];
        facebookPSID = [TTLUtil nullToEmptyString:facebookPSID];
        user.facebookPSID = facebookPSID;
        
        NSString *email = [userDictionary objectForKey:@"email"];
        email = [TTLUtil nullToEmptyString:email];
        user.email = email;
        
        BOOL isEmailVerified = [[userDictionary objectForKey:@"isEmailVerified"] boolValue];
        user.isEmailVerified = isEmailVerified;
        
        NSString *phone = [userDictionary objectForKey:@"phone"];
        phone = [TTLUtil nullToEmptyString:phone];
        user.phone = phone;
        
        BOOL isPhoneVerified = [[userDictionary objectForKey:@"isPhoneVerified"] boolValue];
        user.isPhoneVerified = isPhoneVerified;
        
        NSString *photoURL = [userDictionary objectForKey:@"photoURL"];
        photoURL = [TTLUtil nullToEmptyString:photoURL];
        user.photoURL = photoURL;
        
        NSString *mergedToUserID = [userDictionary objectForKey:@"mergedToUserID"];
        mergedToUserID = [TTLUtil nullToEmptyString:mergedToUserID];
        user.mergedToUserID = mergedToUserID;
        
        NSNumber *mergedTime = [userDictionary objectForKey:@"mergedTime"];
        mergedTime = [TTLUtil nullToEmptyNumber:mergedTime];
        user.mergedTime = mergedTime;
        
        NSNumber *createdTime = [userDictionary objectForKey:@"createdTime"];
        createdTime = [TTLUtil nullToEmptyNumber:createdTime];
        user.createdTime = createdTime;
        
        NSNumber *updatedTime = [userDictionary objectForKey:@"updatedTime"];
        updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
        user.updatedTime = updatedTime;
        
        NSNumber *deletedTime = [userDictionary objectForKey:@"deletedTime"];
        deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
        user.deletedTime = deletedTime;
    
        success(user);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetAccessTokenWithTicket:(NSString *)ticket
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetAccessToken];
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [[TTLNetworkManager sharedManager] post:requestURL authTicket:ticket parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
                
        if ([self isDataEmpty:responseObject]) {
            success();
            return;
        }
            
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSString *accessToken = [dataDictionary objectForKey:@"accessToken"];
        accessToken = [TTLUtil nullToEmptyString:accessToken];
        
        NSTimeInterval accessTokenExpiry = [[dataDictionary objectForKey:@"accessTokenExpiry"] longLongValue];
        
        NSTimeInterval refreshTokenExpiry = [[dataDictionary objectForKey:@"refreshTokenExpiry"] longLongValue];
        
        NSString *refreshToken = [dataDictionary objectForKey:@"refreshToken"];
        refreshToken = [TTLUtil nullToEmptyString:refreshToken];
        
        NSDictionary *userDictionary = [dataDictionary objectForKey:@"user"];
        userDictionary = [TTLUtil nullToEmptyDictionary:userDictionary];
        
        TTLUserModel *user = [TTLUserModel new];
        
        NSString *userID = [userDictionary objectForKey:@"userID"];
        userID = [TTLUtil nullToEmptyString:userID];
        user.userID = userID;
        
        NSString *fullName = [userDictionary objectForKey:@"fullName"];
        fullName = [TTLUtil nullToEmptyString:fullName];
        user.fullName = fullName;
        
        NSString *source = [userDictionary objectForKey:@"source"];
        source = [TTLUtil nullToEmptyString:source];
        user.source = source;
        
        NSString *customerUserID = [userDictionary objectForKey:@"customerUserID"];
        customerUserID = [TTLUtil nullToEmptyString:customerUserID];
        user.customerUserID = customerUserID;
        
        NSString *whatsappUserID = [userDictionary objectForKey:@"whatsappUserID"];
        whatsappUserID = [TTLUtil nullToEmptyString:whatsappUserID];
        user.whatsappUserID = whatsappUserID;
        
        NSString *telegramUserID = [userDictionary objectForKey:@"telegramUserID"];
        telegramUserID = [TTLUtil nullToEmptyString:telegramUserID];
        user.telegramUserID = telegramUserID;
        
        NSString *lineUserID = [userDictionary objectForKey:@"lineUserID"];
        lineUserID = [TTLUtil nullToEmptyString:lineUserID];
        user.lineUserID = lineUserID;

        NSString *twitterUserID = [userDictionary objectForKey:@"twitterUserID"];
        twitterUserID = [TTLUtil nullToEmptyString:twitterUserID];
        user.twitterUserID = twitterUserID;
        
        NSString *facebookPSID = [userDictionary objectForKey:@"facebookPSID"];
        facebookPSID = [TTLUtil nullToEmptyString:facebookPSID];
        user.facebookPSID = facebookPSID;
        
        NSString *email = [userDictionary objectForKey:@"email"];
        email = [TTLUtil nullToEmptyString:email];
        user.email = email;
        
        BOOL isEmailVerified = [[userDictionary objectForKey:@"isEmailVerified"] boolValue];
        user.isEmailVerified = isEmailVerified;
        
        NSString *phone = [userDictionary objectForKey:@"phone"];
        phone = [TTLUtil nullToEmptyString:phone];
        user.phone = phone;
        
        BOOL isPhoneVerified = [[userDictionary objectForKey:@"isPhoneVerified"] boolValue];
        user.isPhoneVerified = isPhoneVerified;
        
        NSString *photoURL = [userDictionary objectForKey:@"photoURL"];
        photoURL = [TTLUtil nullToEmptyString:photoURL];
        user.photoURL = photoURL;
        
        NSString *mergedToUserID = [userDictionary objectForKey:@"mergedToUserID"];
        mergedToUserID = [TTLUtil nullToEmptyString:mergedToUserID];
        user.mergedToUserID = mergedToUserID;
        
        NSNumber *mergedTime = [userDictionary objectForKey:@"mergedTime"];
        mergedTime = [TTLUtil nullToEmptyNumber:mergedTime];
        user.mergedTime = mergedTime;
        
        NSNumber *createdTime = [userDictionary objectForKey:@"createdTime"];
        createdTime = [TTLUtil nullToEmptyNumber:createdTime];
        user.createdTime = createdTime;
        
        NSNumber *updatedTime = [userDictionary objectForKey:@"updatedTime"];
        updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
        user.updatedTime = updatedTime;
        
        NSNumber *deletedTime = [userDictionary objectForKey:@"deletedTime"];
        deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
        user.deletedTime = deletedTime;
        
        [TTLDataManager setAccessToken:accessToken expiryDate:accessTokenExpiry];
        [TTLDataManager setRefreshToken:refreshToken expiryDate:refreshTokenExpiry];
        [TTLDataManager setActiveUser:user];
        
        success();
            
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

- (void)callAPIRefreshAccessTokenSuccess:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            _isShouldRefreshToken = YES;
            
            [self.refreshTokenLock lock];
            
            if (self.isShouldRefreshToken) {
                NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeRefreshAccessToken];
                NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
                NSString *refreshToken = [TTLDataManager getRefreshToken];
                
                [[TTLNetworkManager sharedManager] post:requestURL refreshToken:refreshToken parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
                    
                } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
                    if (![TTLDataManager isResponseSuccess:responseObject]) {
                        NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
                        NSString *errorMessage = [errorDictionary objectForKey:@"message"];
                        errorMessage = [TTLUtil nullToEmptyString:errorMessage];
                        
                        NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
                        
                        if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                            errorCode = 999;
                        }
                        
                        if (errorCode >= 40103 && errorCode <= 40106) {
                            //Refresh token is invalid, ask business side to refresh auth ticket
                            
                        }
                        
                        _isShouldRefreshToken = NO;
                        [self.refreshTokenLock unlock];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
                            failure(error);
                        });
                        
                        return;
                    }
                    
                    if ([TTLDataManager isDataEmpty:responseObject]) {
                        _isShouldRefreshToken = NO;
                        [self.refreshTokenLock unlock];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success();
                        });
                        
                        return;
                    }
                    
                    NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
                    dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
                    
                    NSString *accessToken = [dataDictionary objectForKey:@"accessToken"];
                    accessToken = [TTLUtil nullToEmptyString:accessToken];
                    
                    NSTimeInterval accessTokenExpiry = [[dataDictionary objectForKey:@"accessTokenExpiry"] longLongValue];
                    
                    NSTimeInterval refreshTokenExpiry = [[dataDictionary objectForKey:@"refreshTokenExpiry"] longLongValue];
                    
                    NSString *refreshToken = [dataDictionary objectForKey:@"refreshToken"];
                    refreshToken = [TTLUtil nullToEmptyString:refreshToken];
                    
                    NSDictionary *userDictionary = [dataDictionary objectForKey:@"user"];
                    userDictionary = [TTLUtil nullToEmptyDictionary:userDictionary];
                    
                    TTLUserModel *user = [TTLUserModel new];
                    
                    NSString *userID = [userDictionary objectForKey:@"userID"];
                    userID = [TTLUtil nullToEmptyString:userID];
                    user.userID = userID;
                    
                    NSString *fullName = [userDictionary objectForKey:@"fullName"];
                    fullName = [TTLUtil nullToEmptyString:fullName];
                    user.fullName = fullName;
                    
                    NSString *source = [userDictionary objectForKey:@"source"];
                    source = [TTLUtil nullToEmptyString:source];
                    user.source = source;
                    
                    NSString *customerUserID = [userDictionary objectForKey:@"customerUserID"];
                    customerUserID = [TTLUtil nullToEmptyString:customerUserID];
                    user.customerUserID = customerUserID;
                    
                    NSString *whatsappUserID = [userDictionary objectForKey:@"whatsappUserID"];
                    whatsappUserID = [TTLUtil nullToEmptyString:whatsappUserID];
                    user.whatsappUserID = whatsappUserID;
                    
                    NSString *telegramUserID = [userDictionary objectForKey:@"telegramUserID"];
                    telegramUserID = [TTLUtil nullToEmptyString:telegramUserID];
                    user.telegramUserID = telegramUserID;
                    
                    NSString *lineUserID = [userDictionary objectForKey:@"lineUserID"];
                    lineUserID = [TTLUtil nullToEmptyString:lineUserID];
                    user.lineUserID = lineUserID;

                    NSString *twitterUserID = [userDictionary objectForKey:@"twitterUserID"];
                    twitterUserID = [TTLUtil nullToEmptyString:twitterUserID];
                    user.twitterUserID = twitterUserID;
                    
                    NSString *facebookPSID = [userDictionary objectForKey:@"facebookPSID"];
                    facebookPSID = [TTLUtil nullToEmptyString:facebookPSID];
                    user.facebookPSID = facebookPSID;
                    
                    NSString *email = [userDictionary objectForKey:@"email"];
                    email = [TTLUtil nullToEmptyString:email];
                    user.email = email;
                    
                    BOOL isEmailVerified = [[userDictionary objectForKey:@"isEmailVerified"] boolValue];
                    user.isEmailVerified = isEmailVerified;
                    
                    NSString *phone = [userDictionary objectForKey:@"phone"];
                    phone = [TTLUtil nullToEmptyString:phone];
                    user.phone = phone;
                    
                    BOOL isPhoneVerified = [[userDictionary objectForKey:@"isPhoneVerified"] boolValue];
                    user.isPhoneVerified = isPhoneVerified;
                    
                    NSString *photoURL = [userDictionary objectForKey:@"photoURL"];
                    photoURL = [TTLUtil nullToEmptyString:photoURL];
                    user.photoURL = photoURL;
                    
                    NSString *mergedToUserID = [userDictionary objectForKey:@"mergedToUserID"];
                    mergedToUserID = [TTLUtil nullToEmptyString:mergedToUserID];
                    user.mergedToUserID = mergedToUserID;
                    
                    NSNumber *mergedTime = [userDictionary objectForKey:@"mergedTime"];
                    mergedTime = [TTLUtil nullToEmptyNumber:mergedTime];
                    user.mergedTime = mergedTime;
                    
                    NSNumber *createdTime = [userDictionary objectForKey:@"createdTime"];
                    createdTime = [TTLUtil nullToEmptyNumber:createdTime];
                    user.createdTime = createdTime;
                    
                    NSNumber *updatedTime = [userDictionary objectForKey:@"updatedTime"];
                    updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
                    user.updatedTime = updatedTime;
                    
                    NSNumber *deletedTime = [userDictionary objectForKey:@"deletedTime"];
                    deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
                    user.deletedTime = deletedTime;
                    
                    [TTLDataManager setAccessToken:accessToken expiryDate:accessTokenExpiry];
                    [TTLDataManager setRefreshToken:refreshToken expiryDate:refreshTokenExpiry];
                    [TTLDataManager setActiveUser:user];
                    _isShouldRefreshToken = NO;
                    [self.refreshTokenLock unlock];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success();
                    });
                } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                    [TTLDataManager logErrorStringFromError:error];
                    
    #ifdef DEBUG
                    NSString *errorDomain = error.domain;
                    NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
                    
                    NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
                    
                    _isShouldRefreshToken = NO;
                    [self.refreshTokenLock unlock];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(newError);
                    });
    #else
                    NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
                    
                    _isShouldRefreshToken = NO;
                    [self.refreshTokenLock unlock];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(localizedError);
                    });
    #endif
                }];
            }
            else {
                [self.refreshTokenLock unlock];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
            }
        });
}

+ (void)callAPIGetTapTalkLiveProjectConfigsSuccess:(void (^)(NSDictionary *tapTalkConfigsDictionary))success
                                           failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetProjectConfigs];
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPIGetTapTalkLiveProjectConfigsSuccess:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
                
        if ([self isDataEmpty:responseObject]) {
            success([NSDictionary dictionary]);
            return;
        }
            
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSDictionary *tapTalkConfigsDictionary = [dataDictionary objectForKey:@"tapTalk"];
        tapTalkConfigsDictionary = [TTLUtil nullToEmptyDictionary:tapTalkConfigsDictionary];
        
        NSString *tapTalkAPIURLString = [tapTalkConfigsDictionary objectForKey:@"apiURL"];
        tapTalkAPIURLString = [TTLUtil nullToEmptyString:tapTalkAPIURLString];
        
        NSString *tapTalkAppKeyID = [tapTalkConfigsDictionary objectForKey:@"appKeyID"];
        tapTalkAppKeyID = [TTLUtil nullToEmptyString:tapTalkAppKeyID];
        
        NSString *tapTalkAppKeySecret = [tapTalkConfigsDictionary objectForKey:@"appKeySecret"];
        tapTalkAppKeySecret = [TTLUtil nullToEmptyString:tapTalkAppKeySecret];
        
        [[NSUserDefaults standardUserDefaults] setSecureObject:tapTalkAPIURLString forKey:TTL_PREFS_TAPTALK_API_URL];
        [[NSUserDefaults standardUserDefaults] setSecureObject:tapTalkAppKeyID forKey:TTL_PREFS_TAPTALK_APP_KEY_ID];
        [[NSUserDefaults standardUserDefaults] setSecureObject:tapTalkAppKeySecret forKey:TTL_PREFS_TAPTALK_APP_KEY_SECRET];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success(tapTalkConfigsDictionary);
            
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetTapTalkAuthTicketSuccess:(void (^)(NSString *tapTalkAuthTicket))success
                                   failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetTapTalkAuthTicket];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success(@"");
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSString *ticket = [dataDictionary objectForKey:@"ticket"];
        ticket = [TTLUtil nullToEmptyString:ticket];
        
        success(ticket);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetTopicListSuccess:(void (^)(NSArray<TTLTopicModel *> *topicListArray))success
                           failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetTopicList];
        
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPIGetTopicListSuccess:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success([NSArray array]);
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSArray *topicArray = [dataDictionary objectForKey:@"topics"];
        topicArray = [TTLUtil nullToEmptyArray:topicArray];
        
        NSMutableArray *topicResultArray = [[NSMutableArray alloc] init];
        for (NSDictionary *topicDataDictionary in topicArray) {

            TTLTopicModel *topic = [TTLTopicModel new];
            
            NSString *topicIDRaw = [topicDataDictionary objectForKey:@"id"];
            topicIDRaw = [TTLUtil nullToEmptyString:topicIDRaw];
            NSString *topicID = [NSString stringWithFormat:@"%li", (long)[topicIDRaw integerValue]];
            topic.topicID = topicID;

            NSString *topicName = [topicDataDictionary objectForKey:@"name"];
            topicName = [TTLUtil nullToEmptyString:topicName];
            topic.topicName = topicName;
            
            NSNumber *createdTime = [topicDataDictionary objectForKey:@"createdTime"];
            createdTime = [TTLUtil nullToEmptyNumber:createdTime];
            topic.createdTime = createdTime;
            
            NSNumber *updatedTime = [topicDataDictionary objectForKey:@"updatedTime"];
            updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
            topic.updatedTime = updatedTime;
            
            NSNumber *deletedTime = [topicDataDictionary objectForKey:@"deletedTime"];
            deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
            topic.deletedTime = deletedTime;
            
            [topicResultArray addObject:topic];
        }
        
        success(topicResultArray);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetCaseListSuccess:(void (^)(NSArray<TTLCaseModel *> *caseListArray))success
                          failure:(void (^)(NSError *error))failure {
        NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetCaseList];
            
        NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
        [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
            if (![self isResponseSuccess:responseObject]) {
                NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
                NSString *errorMessage = [errorDictionary objectForKey:@"message"];
                errorMessage = [TTLUtil nullToEmptyString:errorMessage];
                
                NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
                errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
                NSInteger errorStatusCode = [errorStatusCodeString integerValue];
                
                if (errorStatusCode == 401) {
                    //Call refresh token
                    [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                        [TTLDataManager callAPIGetCaseListSuccess:success failure:failure];
                    } failure:^(NSError *error) {
                        failure(error);
                    }];
                    return;
                }
                
                NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
                
                if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                    errorCode = 999;
                }
                
                NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
                failure(error);
                return;
            }
            
            if ([self isDataEmpty:responseObject]) {
                success([NSArray array]);
                return;
            }
            
            NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
            dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
                            
            NSArray *caseListArray = [dataDictionary objectForKey:@"cases"];
            caseListArray = [TTLUtil nullToEmptyArray:caseListArray];
            
            NSMutableArray *caseListResultArray = [[NSMutableArray alloc] init];
            for (NSDictionary *caseDictionary in caseListArray) {
            
                TTLCaseModel *caseData = [TTLCaseModel new];
                
                NSString *caseIDRaw = [caseDictionary objectForKey:@"id"];
                caseIDRaw = [TTLUtil nullToEmptyString:caseIDRaw];
                NSString *caseID = [NSString stringWithFormat:@"%li", (long)[caseIDRaw integerValue]];
                caseData.caseID = caseID;
                
                NSString *stringID = [caseDictionary objectForKey:@"stringID"];
                stringID = [TTLUtil nullToEmptyString:stringID];
                caseData.stringID = stringID;
                
                NSString *userID = [caseDictionary objectForKey:@"userID"];
                userID = [TTLUtil nullToEmptyString:userID];
                caseData.userID = userID;
                
                NSString *userFullName = [caseDictionary objectForKey:@"userFullName"];
                userFullName = [TTLUtil nullToEmptyString:userFullName];
                caseData.userFullName = userFullName;
                
                NSString *topicIDRaw = [caseDictionary objectForKey:@"topicID"];
                topicIDRaw = [TTLUtil nullToEmptyString:topicIDRaw];
                NSString *topicID = [NSString stringWithFormat:@"%li", (long)[topicIDRaw integerValue]];
                caseData.topicID = topicID;
                
                NSString *topicName = [caseDictionary objectForKey:@"topicName"];
                topicName = [TTLUtil nullToEmptyString:topicName];
                caseData.topicName = topicName;
                
                NSString *agentAccountIDRaw = [caseDictionary objectForKey:@"agentAccountID"];
                agentAccountIDRaw = [TTLUtil nullToEmptyString:agentAccountIDRaw];
                NSString *agentAccountID = [NSString stringWithFormat:@"%li", (long)[agentAccountIDRaw integerValue]];
                caseData.agentAccountID = agentAccountID;
                
                NSString *agentFullName = [caseDictionary objectForKey:@"agentFullName"];
                agentFullName = [TTLUtil nullToEmptyString:agentFullName];
                caseData.agentFullName = agentFullName;
                
                NSString *tapTalkXCRoomID = [caseDictionary objectForKey:@"tapTalkXCRoomID"];
                tapTalkXCRoomID = [TTLUtil nullToEmptyString:tapTalkXCRoomID];
                caseData.tapTalkXCRoomID = tapTalkXCRoomID;
                
                NSString *medium = [caseDictionary objectForKey:@"medium"];
                medium = [TTLUtil nullToEmptyString:medium];
                caseData.medium = medium;
                
                NSString *firstMessage = [caseDictionary objectForKey:@"firstMessage"];
                firstMessage = [TTLUtil nullToEmptyString:firstMessage];
                caseData.firstMessage = firstMessage;
                
                NSNumber *firstResponseTime = [caseDictionary objectForKey:@"firstResponseTime"];
                firstResponseTime = [TTLUtil nullToEmptyNumber:firstResponseTime];
                caseData.firstResponseTime = firstResponseTime;
                
                NSString *firstResponseAgentAccountIDRaw = [caseDictionary objectForKey:@"firstResponseAgentAccountID"];
                firstResponseAgentAccountIDRaw = [TTLUtil nullToEmptyString:firstResponseAgentAccountIDRaw];
                NSString *firstResponseAgentAccountID = [NSString stringWithFormat:@"%li", (long)[firstResponseAgentAccountIDRaw integerValue]];
                caseData.firstResponseAgentAccountID = firstResponseAgentAccountID;
                
                NSString *firstResponseAgentFullName = [caseDictionary objectForKey:@"firstResponseAgentFullName"];
                firstResponseAgentFullName = [TTLUtil nullToEmptyString:firstResponseAgentFullName];
                caseData.firstResponseAgentFullName = firstResponseAgentFullName;
            
                BOOL isClosed = [[caseDictionary objectForKey:@"isClosed"] boolValue];
                caseData.isClosed = isClosed;
                
                NSNumber *closedTime = [caseDictionary objectForKey:@"closedTime"];
                closedTime = [TTLUtil nullToEmptyNumber:closedTime];
                caseData.closedTime = closedTime;
                
                NSNumber *createdTime = [caseDictionary objectForKey:@"createdTime"];
                createdTime = [TTLUtil nullToEmptyNumber:createdTime];
                caseData.createdTime = createdTime;
                
                NSNumber *updatedTime = [caseDictionary objectForKey:@"updatedTime"];
                updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
                caseData.updatedTime = updatedTime;
                
                NSNumber *deletedTime = [caseDictionary objectForKey:@"deletedTime"];
                deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
                caseData.deletedTime = deletedTime;
                
                [caseListResultArray addObject:caseData];
            }
            
            success(caseListResultArray);
            
        } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
            [TTLDataManager logErrorStringFromError:error];
            
    #ifdef DEBUG
            NSString *errorDomain = error.domain;
            NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
            
            NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
            
            failure(newError);
    #else
            NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
            
            failure(localizedError);
    #endif
        }];
}

+ (void)callAPICreateCaseWithTopicID:(NSString *)topicID
                             message:(NSString *)message
                             success:(void (^)(TTLCaseModel *caseData))success
                             failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeCreateCase];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    NSInteger topicIDInteger = [topicID integerValue];
    [parameterDictionary setObject:[NSNumber numberWithInteger:topicIDInteger] forKey:@"topicID"];
    [parameterDictionary setObject:message forKey:@"message"];
    
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPICreateCaseWithTopicID:topicID message:message success:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success([TTLCaseModel new]);
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSDictionary *caseDictionary = [dataDictionary objectForKey:@"case"];
        caseDictionary = [TTLUtil nullToEmptyDictionary:caseDictionary];
        
        TTLCaseModel *caseData = [TTLCaseModel new];
        
        NSString *caseIDRaw = [caseDictionary objectForKey:@"id"];
        caseIDRaw = [TTLUtil nullToEmptyString:caseIDRaw];
        NSString *caseID = [NSString stringWithFormat:@"%li", (long)[caseIDRaw integerValue]];
        caseData.caseID = caseID;
        
        NSString *stringID = [caseDictionary objectForKey:@"stringID"];
        stringID = [TTLUtil nullToEmptyString:stringID];
        caseData.stringID = stringID;
        
        NSString *userID = [caseDictionary objectForKey:@"userID"];
        userID = [TTLUtil nullToEmptyString:userID];
        caseData.userID = userID;
        
        NSString *userFullName = [caseDictionary objectForKey:@"userFullName"];
        userFullName = [TTLUtil nullToEmptyString:userFullName];
        caseData.userFullName = userFullName;
        
        NSString *topicIDRaw = [caseDictionary objectForKey:@"topicID"];
        topicIDRaw = [TTLUtil nullToEmptyString:topicIDRaw];
        NSString *topicID = [NSString stringWithFormat:@"%li", (long)[topicIDRaw integerValue]];
        caseData.topicID = topicID;
        
        NSString *topicName = [caseDictionary objectForKey:@"topicName"];
        topicName = [TTLUtil nullToEmptyString:topicName];
        caseData.topicName = topicName;
        
        NSString *agentAccountIDRaw = [caseDictionary objectForKey:@"agentAccountID"];
        agentAccountIDRaw = [TTLUtil nullToEmptyString:agentAccountIDRaw];
        NSString *agentAccountID = [NSString stringWithFormat:@"%li", (long)[agentAccountIDRaw integerValue]];
        caseData.agentAccountID = agentAccountID;
        
        NSString *agentFullName = [caseDictionary objectForKey:@"agentFullName"];
        agentFullName = [TTLUtil nullToEmptyString:agentFullName];
        caseData.agentFullName = agentFullName;
        
        NSString *tapTalkXCRoomID = [caseDictionary objectForKey:@"tapTalkXCRoomID"];
        tapTalkXCRoomID = [TTLUtil nullToEmptyString:tapTalkXCRoomID];
        caseData.tapTalkXCRoomID = tapTalkXCRoomID;
        
        NSString *medium = [caseDictionary objectForKey:@"medium"];
        medium = [TTLUtil nullToEmptyString:medium];
        caseData.medium = medium;
        
        NSString *firstMessage = [caseDictionary objectForKey:@"firstMessage"];
        firstMessage = [TTLUtil nullToEmptyString:firstMessage];
        caseData.firstMessage = firstMessage;
        
        NSNumber *firstResponseTime = [caseDictionary objectForKey:@"firstResponseTime"];
        firstResponseTime = [TTLUtil nullToEmptyNumber:firstResponseTime];
        caseData.firstResponseTime = firstResponseTime;
        
        NSString *firstResponseAgentAccountIDRaw = [caseDictionary objectForKey:@"firstResponseAgentAccountID"];
        firstResponseAgentAccountIDRaw = [TTLUtil nullToEmptyString:firstResponseAgentAccountIDRaw];
        NSString *firstResponseAgentAccountID = [NSString stringWithFormat:@"%li", (long)[firstResponseAgentAccountIDRaw integerValue]];
        caseData.firstResponseAgentAccountID = firstResponseAgentAccountID;
        
        NSString *firstResponseAgentFullName = [caseDictionary objectForKey:@"firstResponseAgentFullName"];
        firstResponseAgentFullName = [TTLUtil nullToEmptyString:firstResponseAgentFullName];
        caseData.firstResponseAgentFullName = firstResponseAgentFullName;
    
        BOOL isClosed = [[caseDictionary objectForKey:@"isClosed"] boolValue];
        caseData.isClosed = isClosed;
        
        NSNumber *closedTime = [caseDictionary objectForKey:@"closedTime"];
        closedTime = [TTLUtil nullToEmptyNumber:closedTime];
        caseData.closedTime = closedTime;
        
        NSNumber *createdTime = [caseDictionary objectForKey:@"createdTime"];
        createdTime = [TTLUtil nullToEmptyNumber:createdTime];
        caseData.createdTime = createdTime;
        
        NSNumber *updatedTime = [caseDictionary objectForKey:@"updatedTime"];
        updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
        caseData.updatedTime = updatedTime;
        
        NSNumber *deletedTime = [caseDictionary objectForKey:@"deletedTime"];
        deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
        caseData.deletedTime = deletedTime;
    
        success(caseData);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPICloseCaseWithCaseID:(NSString *)caseID
                           success:(void (^)(BOOL isSuccess))success
                           failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeCloseCase];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    NSInteger caseIDInteger = [caseID integerValue];
    [parameterDictionary setObject:[NSNumber numberWithInteger:caseIDInteger] forKey:@"id"];
    
    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPICloseCaseWithCaseID:caseID success:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success(true);
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
    
        NSString *message = [dataDictionary objectForKey:@"message"];
        message = [TTLUtil nullToEmptyString:message];
        
        BOOL isSuccess = [[dataDictionary objectForKey:@"isSuccess"] boolValue];
    
        success(isSuccess);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}

+ (void)callAPIGetCaseDetailWithCaseID:(NSString *)caseID
                               success:(void (^)(TTLCaseModel *caseData))success
                               failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [[TTLAPIManager sharedManager] urlForType:TTLAPIManagerTypeGetCaseDetails];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    NSInteger caseIDInteger = [caseID integerValue];
    [parameterDictionary setObject:[NSNumber numberWithInteger:caseIDInteger] forKey:@"caseID"];

    [[TTLNetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        if (![self isResponseSuccess:responseObject]) {
            NSDictionary *errorDictionary = [responseObject objectForKey:@"error"];
            NSString *errorMessage = [errorDictionary objectForKey:@"message"];
            errorMessage = [TTLUtil nullToEmptyString:errorMessage];
            
            NSString *errorStatusCodeString = [responseObject objectForKey:@"status"];
            errorStatusCodeString = [TTLUtil nullToEmptyString:errorStatusCodeString];
            NSInteger errorStatusCode = [errorStatusCodeString integerValue];
            
            if (errorStatusCode == 401) {
                //Call refresh token
                [[TTLDataManager sharedManager] callAPIRefreshAccessTokenSuccess:^{
                    [TTLDataManager callAPIGetCaseDetailWithCaseID:caseID success:success failure:failure];
                } failure:^(NSError *error) {
                    failure(error);
                }];
                return;
            }
            
            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
            
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) {
                errorCode = 999;
            }
            
            NSError *error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:@{@"message": errorMessage}];
            failure(error);
            return;
        }
        
        if ([self isDataEmpty:responseObject]) {
            success([TTLCaseModel new]);
            return;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
        dataDictionary = [TTLUtil nullToEmptyDictionary:dataDictionary];
        
        NSDictionary *caseDictionary = [dataDictionary objectForKey:@"case"];
        caseDictionary = [TTLUtil nullToEmptyDictionary:caseDictionary];
        
        TTLCaseModel *caseData = [TTLCaseModel new];
        
        NSString *caseIDRaw = [caseDictionary objectForKey:@"id"];
        caseIDRaw = [TTLUtil nullToEmptyString:caseIDRaw];
        NSString *caseID = [NSString stringWithFormat:@"%li", (long)[caseIDRaw integerValue]];
        caseData.caseID = caseID;
        
        NSString *stringID = [caseDictionary objectForKey:@"stringID"];
        stringID = [TTLUtil nullToEmptyString:stringID];
        caseData.stringID = stringID;
        
        NSString *userID = [caseDictionary objectForKey:@"userID"];
        userID = [TTLUtil nullToEmptyString:userID];
        caseData.userID = userID;
        
        NSString *userFullName = [caseDictionary objectForKey:@"userFullName"];
        userFullName = [TTLUtil nullToEmptyString:userFullName];
        caseData.userFullName = userFullName;
        
        NSString *topicIDRaw = [caseDictionary objectForKey:@"topicID"];
        topicIDRaw = [TTLUtil nullToEmptyString:topicIDRaw];
        NSString *topicID = [NSString stringWithFormat:@"%li", (long)[topicIDRaw integerValue]];
        caseData.topicID = topicID;
        
        NSString *topicName = [caseDictionary objectForKey:@"topicName"];
        topicName = [TTLUtil nullToEmptyString:topicName];
        caseData.topicName = topicName;
        
        NSString *agentAccountIDRaw = [caseDictionary objectForKey:@"agentAccountID"];
        agentAccountIDRaw = [TTLUtil nullToEmptyString:agentAccountIDRaw];
        NSString *agentAccountID = [NSString stringWithFormat:@"%li", (long)[agentAccountIDRaw integerValue]];
        caseData.agentAccountID = agentAccountID;
        
        NSString *agentFullName = [caseDictionary objectForKey:@"agentFullName"];
        agentFullName = [TTLUtil nullToEmptyString:agentFullName];
        caseData.agentFullName = agentFullName;
        
        NSString *tapTalkXCRoomID = [caseDictionary objectForKey:@"tapTalkXCRoomID"];
        tapTalkXCRoomID = [TTLUtil nullToEmptyString:tapTalkXCRoomID];
        caseData.tapTalkXCRoomID = tapTalkXCRoomID;
        
        NSString *medium = [caseDictionary objectForKey:@"medium"];
        medium = [TTLUtil nullToEmptyString:medium];
        caseData.medium = medium;
        
        NSString *firstMessage = [caseDictionary objectForKey:@"firstMessage"];
        firstMessage = [TTLUtil nullToEmptyString:firstMessage];
        caseData.firstMessage = firstMessage;
        
        NSNumber *firstResponseTime = [caseDictionary objectForKey:@"firstResponseTime"];
        firstResponseTime = [TTLUtil nullToEmptyNumber:firstResponseTime];
        caseData.firstResponseTime = firstResponseTime;
        
        NSString *firstResponseAgentAccountIDRaw = [caseDictionary objectForKey:@"firstResponseAgentAccountID"];
        firstResponseAgentAccountIDRaw = [TTLUtil nullToEmptyString:firstResponseAgentAccountIDRaw];
        NSString *firstResponseAgentAccountID = [NSString stringWithFormat:@"%li", (long)[firstResponseAgentAccountIDRaw integerValue]];
        caseData.firstResponseAgentAccountID = firstResponseAgentAccountID;
        
        NSString *firstResponseAgentFullName = [caseDictionary objectForKey:@"firstResponseAgentFullName"];
        firstResponseAgentFullName = [TTLUtil nullToEmptyString:firstResponseAgentFullName];
        caseData.firstResponseAgentFullName = firstResponseAgentFullName;
    
        BOOL isClosed = [[caseDictionary objectForKey:@"isClosed"] boolValue];
        caseData.isClosed = isClosed;
        
        NSNumber *closedTime = [caseDictionary objectForKey:@"closedTime"];
        closedTime = [TTLUtil nullToEmptyNumber:closedTime];
        caseData.closedTime = closedTime;
        
        NSNumber *createdTime = [caseDictionary objectForKey:@"createdTime"];
        createdTime = [TTLUtil nullToEmptyNumber:createdTime];
        caseData.createdTime = createdTime;
        
        NSNumber *updatedTime = [caseDictionary objectForKey:@"updatedTime"];
        updatedTime = [TTLUtil nullToEmptyNumber:updatedTime];
        caseData.updatedTime = updatedTime;
        
        NSNumber *deletedTime = [caseDictionary objectForKey:@"deletedTime"];
        deletedTime = [TTLUtil nullToEmptyNumber:deletedTime];
        caseData.deletedTime = deletedTime;
    
        success(caseData);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [TTLDataManager logErrorStringFromError:error];
        
#ifdef DEBUG
        NSString *errorDomain = error.domain;
        NSString *newDomain = [NSString stringWithFormat:@"%@ ~ %@", requestURL, errorDomain];
        
        NSError *newError = [NSError errorWithDomain:newDomain code:error.code userInfo:error.userInfo];
        
        failure(newError);
#else
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
#endif
    }];
}


@end
