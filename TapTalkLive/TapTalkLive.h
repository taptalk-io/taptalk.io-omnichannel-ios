//
//  TapTalkLive.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 11/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for TapTalkLive.
FOUNDATION_EXPORT double TapTalkLiveVersionNumber;

//! Project version string for TapTalkLive.
FOUNDATION_EXPORT const unsigned char TapTalkLiveVersionString[];

@interface TapTalkLive : NSObject

//Initalization
+ (TapTalkLive *_Nonnull)sharedInstance;

////==========================================================
////                     Authentication
////==========================================================
///**
// Authenticate user to TapTalk.io server by providing the auth ticket
// set connectWhenSuccess to YES if you want to connect to TapTalk.io automatically after authentication
// */
//- (void)authenticateWithAuthTicket:(NSString *_Nonnull)authTicket
//                connectWhenSuccess:(BOOL)connectWhenSuccess
//                           success:(void (^_Nonnull)(void))success
//                           failure:(void (^_Nonnull)(NSError * _Nonnull error))failure;
//
///**
// To check if user authenticated to TapTalk.io server or not
// return YES if the user is authenticated to TapTalk.io server
// */
//- (BOOL)isAuthenticated;
//
///**
// Logout from TapTalk.io and clear all local cached data
// */
//- (void)logoutAndClearAllTapTalkLiveDataWithSuccess:(void (^_Nonnull)(void))success
//                                            failure:(void (^_Nonnull)(NSError *_Nonnull error))failure;
//
///**
// Clear all local cached data
// */
//- (void)clearAllTapTalkLiveData;



@end
