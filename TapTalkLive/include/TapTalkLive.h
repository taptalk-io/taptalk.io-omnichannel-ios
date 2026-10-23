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
#import "TTLCaseListViewController.h"
#import "TTLHomeLauncherViewController.h"
#import "TTLCaseModel.h"
#import "TTLFaqModel.h"
#import "TTLTopicModel.h"

//! Project version number for TapTalkLive.
FOUNDATION_EXPORT double TapTalkLiveVersionNumber;

//! Project version string for TapTalkLive.
FOUNDATION_EXPORT const unsigned char TapTalkLiveVersionString[];

@protocol TapTalkLiveDelegate <NSObject>

@optional

/**
 Called when user tapped the close button in create case view
*/
- (void)didTappedCloseButtonInCreateCaseViewWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the close button in case list view
*/
- (void)didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the close button in homepage view
*/
- (void)didTappedCloseButtonInHomePageViewWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the see all message button in homepage view
*/
- (void)seeAllMessagesButtonDidTappedWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the create message button in homepage view
*/
- (void)createNewMessageButtonDidTappedWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the case list item in case list view
*/
- (void)caseListItemDidTappedWithCurrentShownNavigationController:(UINavigationController *_Nullable)navigationController lastMessage:(TAPMessageModel *_Nullable)lastMessage;

/**
 Called when user tapped the faq child list item in faq view
*/
- (void)faqChildDidTapped:(TTLFaqModel *_Nullable)faqModel currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the close button in faq details view
*/
- (void)closeButtonInFaqDetailsViewDidTapped:(TTLFaqModel *_Nullable)faqModel currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped the talk to agent button in faq details view
*/
- (void)talkToAgentButtonDidTapped:(TTLFaqModel *_Nullable)faqModel currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped a url in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentUrlDidTapped:(NSURL *_Nullable)url currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user long pressed a url in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentUrlDidLongPressed:(NSURL *_Nullable)url currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped an email  in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentEmailAddressDidTapped:(NSURL *_Nullable)emailAddress currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user long pressed an email address  in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentEmailAddressDidLongPressed:(NSURL *_Nullable)emailAddress currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user tapped a phone number   in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentPhoneNumberDidTapped:(NSURL *_Nullable)phoneNumber currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

/**
 Called when user long pressed a phone number  in faq content
*/
- (void)faq:(TTLFaqModel *_Nullable)faqModel contentPhoneNumberDidLongPressed:(NSURL *_Nullable)phoneNumber currentShownNavigationController:(UINavigationController *_Nullable)navigationController;

@end

@interface TapTalkLive : NSObject

@property (weak, nonatomic) id<TapTalkLiveDelegate> _Nullable delegate;
@property (strong, nonatomic) NSMutableDictionary<NSString * /*xcRoomID*/, TTLCaseModel *> *_Nullable caseDictionary;
@property (strong, nonatomic) NSMutableDictionary<NSString * /*apiUrl*/, NSString * /*contentResponse*/> *_Nullable contentResponseDictionary;
@property (strong, nonatomic) NSMutableArray<NSString *> *_Nullable loadingContentResponseArray;
@property (weak, nonatomic) UIWindow *activeWindow;
@property (nonatomic) BOOL isTapTalkLiveInitialized;

//Initalization
+ (TapTalkLive *_Nonnull)sharedInstance;

//Property
- (TTLCaseListViewController *_Nullable)roomListViewController;
- (TTLHomeLauncherViewController *_Nullable)getHomeLauncherVC;

//==========================================================
//            UIApplicationDelegate Handling
//==========================================================
/**
 Tells the delegate that the launch process is almost done and the app is almost ready to run.
 */
- (void)application:(UIApplication *_Nonnull)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions;

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
- (void)handleException:(NSException *_Nonnull)exception;

//==========================================================
//                 Windows & View Controllers
//==========================================================
/**
 Set current active window to TapTalkLive
 */
- (void)setCurrentActiveWindow:(UIWindow *_Nonnull)activeWindow;

/**
 Obtain current active navigation controller
 */
- (UINavigationController *_Nullable)getCurrentTapTalkLiveActiveNavigationController;

/**
 Obtain current active view controller
 */
- (UIViewController *_Nullable)getCurrentTapTalkLiveActiveViewController;

//==========================================================
//                  General Setup & Methods
//==========================================================
/**
 Initialize app to TapTalk.io Omnichannel by providing app key secret
 */
- (void)initWithSecretKey:(NSString *_Nonnull)secretKey;

- (void)initWithSecretKey:(NSString *_Nonnull)secretKey
                  success:(void (^_Nonnull)(void))success
                  failure:(void (^_Nonnull)(NSString *_Nullable errorMessage))failure;

- (void)initWithSecretKey:(NSString *_Nonnull)secretKey
                   apiURL:(NSString *_Nonnull)apiURLString
                  success:(void (^_Nonnull)(void))success
                  failure:(void (^_Nonnull)(NSString *_Nullable errorMessage))failure;
/**
 Set Google Places API Key to pick and obtain location when send location chat
 */
- (void)initializeGooglePlacesAPIKey:(NSString *_Nonnull)apiKey;

/**
 Trigger when user click close button from create case form
 */
- (void)didCloseCreateCaseViewController;

/**
 Trigger when user click close button from case list form
 */
- (void)didCloseCaseListViewController;

//==========================================================
//                   TapTalk Live View
//==========================================================
/**
Call to show TapTalk Live view with present animation

 @param navigationController (UINavigationController *) your current navigation controller
 @param animated (BOOL) make the present animated or not
*/

- (void)presentTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                     animated:(BOOL)animated;

- (void)presentCaseListViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                     animated:(BOOL)animated;

- (void)presentCreateCaseViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                    animated:(BOOL)animated;

- (void)presentHomeLauncherViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                      animated:(BOOL)animated;

- (void)openCaseChatRoomWithXCRoomID:(NSString *_Nonnull)tapTalkXCRoomID
                navigationController:(UINavigationController *_Nonnull)navigationController
                            animated:(BOOL)animated
                             success:(void (^_Nonnull)(NSString *_Nullable successMessage))success
                             failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

/**
Call to show TapTalk Live view with push animation

 @param navigationController (UINavigationController *) your current navigation controller
 @param animated (BOOL) make the present animated or not
*/

- (void)pushTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                  animated:(BOOL)animated;

- (void)pushCaseListViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                  animated:(BOOL)animated;

- (void)pushHomeLauncherViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController
                                                   animated:(BOOL)animated;

/**
Obtain main view controller of TapTalk Live
*/
- (TTLCaseListViewController *_Nonnull)getTapTalkLiveViewMainController;

/**
Authenticate and log in user with name and email
*/
- (void)authenticateUserWithFullName:(NSString *_Nonnull)fullName
                               email:(NSString *_Nonnull)email
                             success:(void (^_Nonnull)(NSString *_Nullable message))success
                             failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

/**
Authenticate with existing auth ticket
*/
- (void)requestAccessTokenWithAuthTicket:(NSString *_Nonnull)authTicket
                                 success:(void (^_Nonnull)(NSString *_Nullable message))success
                                 failure:(void (^_Nonnull)(NSError *_Nullable error))failure;
    
/**
Manage case and topic
*/
- (void)getTopicListWithSuccess:(void (^_Nonnull)(NSArray<TTLTopicModel *> *_Nonnull topicListArray))success
                        failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

- (void)getUserCaseListListWithSuccess:(void (^_Nonnull)(NSArray<TTLCaseModel *> *_Nullable caseListArray))success
                               failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

- (void)createNewCaseWithTopicID:(NSString *_Nonnull)topicID
                    firstMessage:(NSString *_Nonnull)firstMessage
                         success:(void (^_Nonnull)(TTLCaseModel *_Nullable caseModel))success
                         failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

/**
Logout from TapTalk Live and clear all existing TapTalk Live data
*/
- (void)logout:(void (^_Nonnull)(NSString *_Nullable message))success
       failure:(void (^_Nonnull)(NSError *_Nullable error))failure;
    
/**
Clear user data from TapTalk Live when user logs out
*/
- (void)logoutAndClearAllTapLiveData:(void (^_Nonnull)(NSString *_Nullable message))success
                             failure:(void (^_Nonnull)(NSError *_Nullable error))failure;

/**
Clear all data from TapTalk Live
*/
- (void)clearUserData;

- (void)clearAllTapLiveData;

@end
