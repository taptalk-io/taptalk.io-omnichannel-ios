//
//  TapTalkLive.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 11/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import "TapTalkLive.h"
#import <CoreText/CoreText.h>
#import <TapTalk/TapTalk.h>
#import <TapTalk/TapUI.h>
#import <TapTalk/TapUIChatViewController.h>
#import <TapTalk/TAPUtil.h>

#import "TTLCaseListViewController.h"
#import "TTLPopUpHandlerViewController.h"
#import "TTLPopUpInfoViewController.h"
#import "TTLRatingViewController.h"
#import "TTLReviewBubbleTableViewCell.h"

@interface TapTalkLive () <TapUIRoomListDelegate, TapUICustomKeyboardDelegate, TapUIChatRoomDelegate, TTLReviewBubbleTableViewCellDelegate>

//@property (strong, nonatomic) TTLRoomListViewController *roomListViewController;
@property (strong, nonatomic) TTLCaseListViewController *caseListViewController;
@property (strong, nonatomic) NSMutableDictionary<NSString * /*xcRoomID*/, TTLCaseModel *> *caseDictionary;
@property (nonatomic) BOOL isTapTalkInitializationCompleted;
@property (nonatomic) BOOL isGetCaseListCompleted;

- (void)loadCustomFontData;

@end

@implementation TapTalkLive
#pragma mark - Lifecycle
+ (TapTalkLive *)sharedInstance {
    static TapTalkLive *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        //Set secret for NSSecureUserDefaults
        [NSUserDefaults setSecret:TTL_SECURE_KEY_NSUSERDEFAULTS];
        
        _activeWindow = [[UIWindow alloc] init];
        
        _caseDictionary = [NSMutableDictionary dictionary];
        
        //Hide setup loading view flow in room list
//        [[TapUI sharedInstance] hideSetupLoadingFlowInSetupRoomListView:YES];
        
//        Init TTLRoomListViewController
//        _roomListViewController = [[TTLRoomListViewController alloc] init];
//        _roomListViewController = [[TapUI sharedInstance] roomListViewController];
    }
    
    return self;
}

#pragma mark - Property
//- (TTLRoomListViewController *)roomListViewController {
//    return _roomListViewController;
//}

- (TTLCaseListViewController *)roomListViewController {
    if (self.caseListViewController == nil) {
        _caseListViewController = [[TTLCaseListViewController alloc] initWithNibName:@"TTLCaseListViewController" bundle:[TTLUtil currentBundle]];
        self.caseListViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self.caseListViewController;
}

#pragma mark - AppDelegate Handling
- (void)application:(UIApplication *_Nonnull)application didFinishLaunchingWithOptions:(NSDictionary *_Nonnull)launchOptions {
    // Override point for customization after application launch.
    [[TapTalk sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //Load custom font data
    [self loadCustomFontData];
    
    //Disable auto connect TapTalk because needs to wait Base URL called from init TapLive using API
    [[TapTalk sharedInstance] setAutoConnectEnabled:NO];
}

- (void)applicationWillResignActive:(UIApplication *_Nonnull)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[TapTalk sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *_Nonnull)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[TapTalk sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *_Nonnull)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[TapTalk sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[TapTalk sharedInstance] applicationDidBecomeActive:application];
    
    //Check to connect to socket
    if (self.isTapTalkInitializationCompleted) {
        [[TapTalk sharedInstance] connectWithSuccess:^{
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *_Nonnull)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[TapTalk sharedInstance] applicationWillTerminate:application];
}

- (void)application:(UIApplication *_Nonnull)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)deviceToken {
    //DV TODO - Implement lifecycle TapTalk
}

- (void)application:(UIApplication *_Nonnull)application didReceiveRemoteNotification:(NSDictionary *_Nonnull)userInfo fetchCompletionHandler:(void (^_Nonnull)(UIBackgroundFetchResult result))completionHandler {
    //DV TODO - Implement lifecycle TapTalk
}

#pragma mark - Exception Handling
- (void)handleException:(NSException * _Nonnull)exception {
    [[TapTalk sharedInstance] handleException:exception];
}

#pragma mark - TapTalk Live View
/**
Called to show TapTalk Live view with present animation

@param navigationController (UINavigationController *) your current navigation controller
*/
- (void)presentTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController animated:(BOOL)animated {
    if ([self roomListViewController].isViewAppear) {
        return;
    }
    [self roomListViewController].navigationType = TTLCaseListViewControllerNavigationTypePresent;
    UINavigationController *caseListNavigationController = [[UINavigationController alloc] initWithRootViewController:[self roomListViewController]];
    caseListNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [caseListNavigationController setNavigationBarHidden:YES animated:NO];
    [navigationController presentViewController:caseListNavigationController animated:animated completion:^{
    }];
    [[self roomListViewController] openCreateCaseFormViewIfNeeded];
}

/**
Called to show TapTalk Live view with push animation

@param navigationController (UINavigationController *) your current navigation controller
*/
- (void)pushTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController animated:(BOOL)animated {
    if ([self roomListViewController].isViewAppear) {
        return;
    }
    [self roomListViewController].navigationType = TTLCaseListViewControllerNavigationTypePush;
    [navigationController pushViewController:[self roomListViewController] animated:animated];
    [[self roomListViewController] openCreateCaseFormViewIfNeeded];
}

/**
Obtain main view controller of TapTalk Live
*/
//- (TTLRoomListViewController *_Nonnull)getTapTalkLiveViewMainController {
//    TTLRoomListViewController *roomListViewController = [TapTalkLive sharedInstance].roomListViewController;
//    roomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [roomListViewController openCreateCaseFormViewIfNeeded];
//    return roomListViewController;
//}

- (TTLCaseListViewController *_Nonnull)getTapTalkLiveViewMainController {
    return [self roomListViewController];
}

#pragma mark - TapTalk Delegate
#pragma mark TapUIChatRoom
- (void)tapTalkGroupMemberAvatarTappedWithRoom:(TAPRoomModel *)room
                            user:(TAPUserModel *)user
              currentShownNavigationController:(UINavigationController *)currentNavigationController {
    
}

#pragma mark TapUIRoomList
- (void)tapTalkNewChatButtonTapped:(UIViewController *)currentViewController
  currentShownNavigationController:(UINavigationController *)currentNavigationController {
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = currentNavigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeAlreadyLogin];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [currentNavigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
}

#pragma mark TapUICustomKeyboard
- (NSArray<TAPCustomKeyboardItemModel *> *)setCustomKeyboardItemsForRoom:(TAPRoomModel * _Nonnull)room sender:(TAPUserModel * _Nonnull)sender recipient:(TAPUserModel * _Nullable)recipient {
  //Set custom keyboard option items
    TTLImage *checkListImage = [UIImage imageNamed:@"TTLIconCheck" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    checkListImage = [checkListImage setImageTintColor:[TTLUtil getColor:@"191919"]];
    TAPCustomKeyboardItemModel *customKeyboardItem = [TAPCustomKeyboardItemModel createCustomKeyboardItemWithImage:checkListImage itemName:NSLocalizedStringFromTableInBundle(@"Mark as solved", nil, [TTLUtil currentBundle], @"") itemID:@"1"];
    return @[customKeyboardItem];
}

- (void)customKeyboardItemTappedWithRoom:(TAPRoomModel * _Nonnull)room
                                  sender:(TAPUserModel * _Nonnull)sender
                               recipient:(TAPUserModel * _Nullable)recipient
                            keyboardItem:(TAPCustomKeyboardItemModel * _Nonnull)keyboardItem {
    
    // Do an action when user taps a custom keyboard item
    if ([keyboardItem.itemID isEqualToString:@"1"]) {
        TTLPopUpHandlerViewController *popupHandlerViewController = [[TTLPopUpHandlerViewController alloc] init];
        popupHandlerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        popupHandlerViewController.room = room;
        popupHandlerViewController.sender = sender;
        popupHandlerViewController.recipient = recipient;
//        UIViewController *currentActiveController = [self getCurrentTapTalkLiveActiveViewController];
        UIViewController *currentActiveController = [TAPUtil topViewController];
        [currentActiveController presentViewController:popupHandlerViewController animated:NO completion:^{
            [popupHandlerViewController showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeInfoDefault popupIdentifier:@"Custom Keyboard - Close Case Tapped" title:NSLocalizedStringFromTableInBundle(@"Warning", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"This case will be closed and you wont be able to further send messages or receive assistance regarding this case. Would you like to proceed?", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [TTLUtil currentBundle], @"") singleOrRightOptionButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", nil, [TTLUtil currentBundle], @"")];
        }];
    }
}

#pragma mark - TapTalkLive Delegate
#pragma mark TTLReviewBubbleTableViewCell
- (void)reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:(TAPMessageModel *)message {
    UINavigationController *currentActiveNavigationController = [self getCurrentTapTalkLiveActiveNavigationController];
    TTLCaseModel *currentCase = [TTLDataManager caseDataModelFromDictionary:message.data];

    TTLRatingViewController *ratingViewController = [[TTLRatingViewController alloc] init];
    ratingViewController.currentCase = currentCase;
    UINavigationController *ratingNavigationController = [[UINavigationController alloc] initWithRootViewController:ratingViewController];
    ratingNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [currentActiveNavigationController presentViewController:ratingNavigationController animated:NO completion:nil];
}

#pragma mark - Custom Method
#pragma mark Windows & View Controllers
- (void)setCurrentActiveWindow:(UIWindow *)activeWindow {
    _activeWindow = activeWindow;
    [[TapUI sharedInstance] setCurrentActiveWindow:self.activeWindow];
    //Disable TapTalk In App Notification
    [[TapUI sharedInstance] activateTapTalkInAppNotification:NO];
}

- (UINavigationController *)getCurrentTapTalkLiveActiveNavigationController {
    return [[TapUI sharedInstance] getCurrentTapTalkActiveNavigationController];
}

- (UIViewController *)getCurrentTapTalkLiveActiveViewController {
    return [[TapUI sharedInstance] getCurrentTapTalkActiveViewController];
}

#pragma mark General Setup & Methods
/**
 Initialize app to TapTalk.io Omnichannel by providing app key secret
 */
- (void)initWithSecretKey:(NSString *_Nonnull)secretKey {
    [self initWithSecretKey:secretKey success:^{
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)initWithSecretKey:(NSString *_Nonnull)secretKey
                  success:(void (^)(void))success
                  failure:(void (^)(NSString *errorMessage))failure {

    NSString *apiURLString;
    // FIXME: DEBUG URL CALLED IN PRODUCTION BUILD
//#ifdef DEBUG
//    apiURLString = @"https://taplive-api-dev.taptalk.io/api/visitor";
//#else
    apiURLString = @"https://taplive-cstd.taptalk.io/api/visitor";
//#endif

    [[TTLNetworkManager sharedManager] setSecretKey:secretKey];
    [[TTLAPIManager sharedManager] setBaseAPIURLString:apiURLString];
    
    //Call API project configs
    [TTLDataManager callAPIGetTapTalkLiveProjectConfigsSuccess:^(NSDictionary * _Nonnull tapTalkConfigsDictionary) {
        //Obtain TapTalk.io Chat SDK credential configs
        NSString *tapTalkAPIURLString = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_TAPTALK_API_URL valid:nil];
        tapTalkAPIURLString = [TTLUtil nullToEmptyString:tapTalkAPIURLString];
        NSString *tapTalkAppKeyIDString = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_TAPTALK_APP_KEY_ID valid:nil];
        tapTalkAppKeyIDString = [TTLUtil nullToEmptyString:tapTalkAppKeyIDString];
        NSString *tapTalkAppKeySecretString = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_TAPTALK_APP_KEY_SECRET valid:nil];
        tapTalkAppKeySecretString = [TTLUtil nullToEmptyString:tapTalkAppKeySecretString];
        
        //Init TapTalk.io Chat SDK
        [[TapTalk sharedInstance] initWithAppKeyID:tapTalkAppKeyIDString
                                      appKeySecret:tapTalkAppKeySecretString
                                      apiURLString:tapTalkAPIURLString
                                implementationType:TapTalkImplentationTypeCore
                                           success:^{
            _isTapTalkInitializationCompleted = YES;
            if (self.isGetCaseListCompleted) {
                success();
            }
            
            // Remove disabled features from chat room
            [[TapUI sharedInstance] setHideReadStatus:YES];
            [[TapUI sharedInstance] setReplyMessageMenuEnabled:YES];
            [[TapUI sharedInstance] setForwardMessageMenuEnabled:NO];
            [[TapUI sharedInstance] setMentionUsernameEnabled:NO];
            [[TapUI sharedInstance] setStarMessageMenuEnabled:NO];
            [[TapUI sharedInstance] setSendVoiceNoteMenuEnabled:NO];
            [[TapUI sharedInstance] setEditMessageMenuEnabled:NO];
            
            //Add custom bubble cell
            [[TapUI sharedInstance] addCustomBubbleWithClassName:@"TTLCaseCloseBubbleTableViewCell" type:3001 delegate:self bundle:[TTLUtil currentBundle]];
            [[TapUI sharedInstance] addCustomBubbleWithClassName:@"TTLReviewBubbleTableViewCell" type:3003 delegate:self bundle:[TTLUtil currentBundle]];
            [[TapUI sharedInstance] addCustomBubbleWithClassName:@"TTLDoneReviewBubbleTableViewCell" type:3004 delegate:self bundle:[TTLUtil currentBundle]];
            
            //Set delegate for Room List TapTalk
            [[TapUI sharedInstance] setRoomListDelegate:self];
            [[TapUI sharedInstance] setCustomKeyboardDelegate:self];
            [[TapUI sharedInstance] setChatRoomDelegate:self];
            
            //Try to connect to TapTalk.io
            [[TapTalk sharedInstance] connectWithSuccess:^{
                
            } failure:^(NSError * _Nonnull error) {
                
            }];
        }];
    } failure:^(NSError * _Nonnull error) {
        // Failed get project configs
        failure(NSLocalizedString(@"Failed to get configs.", @""));
    }];
    
    // Call API get case list
    if ([TTLDataManager getAccessToken] != nil && ![[TTLDataManager getAccessToken] isEqualToString:@""]) {
        [TTLDataManager callAPIGetCaseListSuccess:^(NSArray<TTLCaseModel *> * _Nonnull caseListArray) {
            BOOL isContainCaseList = NO;
            if ([caseListArray count] > 0) {
                isContainCaseList = YES;
                for (TTLCaseModel *caseModel in caseListArray) {
                    [self.caseDictionary setObject:caseModel forKey:caseModel.tapTalkXCRoomID];
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setSecureBool:isContainCaseList forKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
            [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TAP_PREFS_IS_DONE_FIRST_SETUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _isGetCaseListCompleted = YES;
            if (self.isTapTalkInitializationCompleted) {
                success();
            }
            
        } failure:^(NSError * _Nonnull error) {
            _isGetCaseListCompleted = YES;
            if (self.isTapTalkInitializationCompleted) {
                success();
            }
        }];
    }
    else {
        _isGetCaseListCompleted = YES;
        if (self.isTapTalkInitializationCompleted) {
            success();
        }
    }
}

- (void)initializeGooglePlacesAPIKey:(NSString * _Nonnull)apiKey {
    [[TapTalk sharedInstance] initializeGooglePlacesAPIKey:apiKey];
}

#pragma mark Others
- (void)loadCustomFontData {
    NSArray *fontArray = @[@"DMSans-Italic", @"PTRootUI-Regular", @"PTRootUI-Medium", @"PTRootUI-Bold"];
    
    for (NSString *fontName in fontArray) {
        NSString *fontPath = [[TTLUtil currentBundle] pathForResource:fontName ofType:@"ttf"];
        NSData *inData = [NSData dataWithContentsOfFile:fontPath];
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

- (void)authenticateUserWithFullName:(NSString *)fullName
                               email:(NSString *)email
                             success:(void (^)(NSString *message))success
                             failure:(void (^)(NSError *error))failure {
 
    [TTLDataManager callAPICreateUserWithFullName:fullName email:email success:^(TTLUserModel * _Nonnull user, NSString * _Nonnull ticket) {
        // Get TapTalkLive access token
        [TTLDataManager callAPIGetAccessTokenWithTicket:ticket success:^{
            // Obtain TapTalk auth ticket
            [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:^(NSString * _Nonnull tapTalkAuthTicket) {
                // Authenticate TapTalk.io Chat SDK
                [[TapTalk sharedInstance] authenticateWithAuthTicket:tapTalkAuthTicket connectWhenSuccess:YES success:^{
                    success(NSLocalizedString(@"Successfully authenticated.", @""));
                } failure:^(NSError * _Nonnull error) {
                    // Error authenticate TapTalk.io Chat SDK
                    failure(error);
                }];
            } failure:^(NSError * _Nonnull error) {
                // Error get TapTalk auth ticket
                failure(error);
            }];
        } failure:^(NSError * _Nonnull error) {
            // Error get access token
            failure(error);
        }];
    } failure:^(NSError * _Nonnull error) {
        // Error create user
        failure(error);
    }];
}

- (void)clearAllTapLiveData {
    //Remove all preference
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_ACTIVE_USER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_REFRESH_TOKEN_EXPIRED_TIME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_ACCESS_TOKEN_EXPIRED_TIME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[TapTalk sharedInstance] clearAllTapTalkData];
}

@end
