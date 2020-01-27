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
#import "TTLRoomListViewController.h"

//! Project version number for TapTalkLive.
FOUNDATION_EXPORT double TapTalkLiveVersionNumber;

//! Project version string for TapTalkLive.
FOUNDATION_EXPORT const unsigned char TapTalkLiveVersionString[];

@interface TapTalkLive : NSObject

@property (weak, nonatomic) UIWindow *activeWindow;

//Initalization
+ (TapTalkLive *_Nonnull)sharedInstance;

//Property
- (TTLRoomListViewController *_Nonnull)roomListViewController;

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
//                 Windows & View Controllers
//==========================================================
/**
 Set current active window to TapTalkLive
 */
- (void)setCurrentActiveWindow:(UIWindow *)activeWindow;

/**
 Obtain current active navigation controller
 */
- (UINavigationController *)getCurrentTapTalkLiveActiveNavigationController;

/**
 Obtain current active view controller
 */
- (UIViewController *)getCurrentTapTalkLiveActiveViewController;

//==========================================================
//                   TapTalk Live View
//==========================================================
/**
Called to show TapTalk Live view with present animation

 @param navigationController (UINavigationController *) your current navigation controller
 @param animated (BOOL) make the present animated or not
*/
- (void)presentTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                     animated:(BOOL)animated;

/**
Called to show TapTalk Live view with push animation

 @param navigationController (UINavigationController *) your current navigation controller
 @param animated (BOOL) make the present animated or not
*/
- (void)pushTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                  animated:(BOOL)animated;

/**
Obtain main view controller of TapTalk Live
*/
- (TTLRoomListViewController *_Nonnull)getTapTalkLiveViewMainController;

@end
