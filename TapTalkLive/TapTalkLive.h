//
//  TapTalkLive.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 11/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "TTLCreateCaseViewController.h"

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

//==========================================================
//            UIApplicationDelegate Handling
//==========================================================
/**
 Tells the delegate that the launch process is almost done and the app is almost ready to run.
 */
- (void)application:(UIApplication *_Nonnull)application didFinishLaunchingWithOptions:(NSDictionary *_Nonnull)launchOptions;

/**
 Tells the delegate that the app is about to become inactive.
 */
- (void)applicationWillResignActive:(UIApplication *_Nonnull)application;

/**
 Tells the delegate that the app is now in the background.
 */
- (void)applicationDidEnterBackground:(UIApplication *_Nonnull)application;

/**
 Tells the delegate that the app is about to enter the foreground.
 */
- (void)applicationWillEnterForeground:(UIApplication *_Nonnull)application;

/**
 Tells the delegate that the app has become active.
 */
- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application;

/**
 Tells the delegate when the app is about to terminate.
 */
- (void)applicationWillTerminate:(UIApplication *_Nonnull)application;

/**
 Tells the delegate that the app successfully registered with Apple Push Notification service (APNs).
 */
- (void)application:(UIApplication *_Nonnull)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)deviceToken;

/**
 Tells the app that a remote notification arrived that indicates there is data to be fetched.
 */
- (void)application:(UIApplication *_Nonnull)application didReceiveRemoteNotification:(NSDictionary *_Nonnull)userInfo fetchCompletionHandler:(void (^_Nonnull)(UIBackgroundFetchResult result))completionHandler;

//Push Notification
/**
 Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *_Nonnull)center willPresentNotification:(UNNotification *_Nonnull)notification withCompletionHandler:(void (^_Nonnull)(UNNotificationPresentationOptions options))completionHandler;

/**
 Asks the delegate to process the user's response to a delivered notification.
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *_Nonnull)center didReceiveNotificationResponse:(UNNotificationResponse *_Nonnull)response withCompletionHandler:(void(^_Nonnull)(void))completionHandler;

//Exception Handling
/**
 Called when the application throws the exception
 */
- (void)handleException:(NSException * _Nonnull)exception;

//==========================================================
//            Create Case View
//==========================================================

/**
Called to show case form view from your application.

@param navigationController (UINavigationController *) your current navigation controller
*/
- (void)openCreateCaseFormWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController;

/**
Called to obtain create case form view controller object
*/
- (TTLCreateCaseViewController *)getCreateCaseFormViewController;

@end
