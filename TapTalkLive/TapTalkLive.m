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

@interface TapTalkLive () <TapUIRoomListDelegate, TapUICustomKeyboardDelegate>

@property (strong, nonatomic) TTLRoomListViewController *roomListViewController;
@property (nonatomic) BOOL isDoneTapTalkInitialization;

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
        
        //DV Temp
#ifdef STAGING
        [[TTLNetworkManager sharedManager] setSecretKey:@""];
#elif DEV
        [[TTLNetworkManager sharedManager] setSecretKey:@"8916d032524deb06e6d1b6ed5e6839abe08553c9bc117ce0e156a04ad946a882"];
#else
        [[TTLNetworkManager sharedManager] setSecretKey:@"8916d032524deb06e6d1b6ed5e6839abe08553c9bc117ce0e156a04ad946a882"];
#endif
        //END DV Temp
        
        //Init TTLRoomListViewController
        _roomListViewController = [[TTLRoomListViewController alloc] init];
                
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
            [[TapTalk sharedInstance] initWithAppKeyID:tapTalkAppKeyIDString appKeySecret:tapTalkAppKeySecretString apiURLString:tapTalkAPIURLString implementationType:TapTalkImplentationTypeCombine];
            
            _isDoneTapTalkInitialization = YES;
            
            //Try to connect to TapTalk.io
            [[TapTalk sharedInstance] connectWithSuccess:^{
                
            } failure:^(NSError * _Nonnull error) {
                
            }];
            
        } failure:^(NSError * _Nonnull error) {
            //Failed get project configs
        }];
        
        //Call API get case list
        [TTLDataManager callAPIGetCaseListSuccess:^(NSArray<TTLCaseModel *> * _Nonnull caseListArray) {
            BOOL isContainCaseList = NO;
            if ([caseListArray count] > 0) {
                isContainCaseList = YES;
            }
            
            [[NSUserDefaults standardUserDefaults] setSecureBool:isContainCaseList forKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } failure:^(NSError * _Nonnull error) {
            //Failed get case list
        }];
        
        //Set delegate for Room List TapTalk
        [[TapUI sharedInstance] setRoomListDelegate:self];
        [[TapUI sharedInstance] setCustomKeyboardDelegate:self];
    }
    
    return self;
}

#pragma mark - Property
- (TTLRoomListViewController *)roomListViewController {
    return _roomListViewController;
}

#pragma mark - AppDelegate Handling
- (void)application:(UIApplication *_Nonnull)application didFinishLaunchingWithOptions:(NSDictionary *_Nonnull)launchOptions {
    // Override point for customization after application launch.
    [[TapTalk sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //Load custom font data
    [self loadCustomFontData];
    
    //Disable auto connect TapTalk because needs to wait Base URL called from init TapLive using API
    [[TapTalk sharedInstance] setAutoConnectEnabled:NO];
    
    //Hide profile button in TapTalk Chat in chat room view
    [[TapUI sharedInstance] setProfileButtonInChatRoomVisible:NO];
    
    //Initialize Google Places API Key
    [[TapTalk sharedInstance] initializeGooglePlacesAPIKey:@"AIzaSyD0NlVEN0mdU9mLp05ZnTc_EEATMzFzvuc"];
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
    if (self.isDoneTapTalkInitialization) {
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
- (void)presentTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController {
    TTLRoomListViewController *roomListViewController = [[TTLRoomListViewController alloc] init];
    [roomListViewController openCreateCaseFormViewIfNeeded];
    roomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UINavigationController *roomListNavigationController = [[UINavigationController alloc] initWithRootViewController:roomListViewController];
    roomListNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [navigationController presentViewController:roomListNavigationController animated:YES completion:nil];
}

/**
Called to show TapTalk Live view with push animation

@param navigationController (UINavigationController *) your current navigation controller
*/
- (void)pushTapTalkLiveViewWithCurrentNavigationController:(UINavigationController *_Nonnull)navigationController {
    TTLRoomListViewController *roomListViewController = [TapTalkLive sharedInstance].roomListViewController;
    [roomListViewController openCreateCaseFormViewIfNeeded];
    roomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UINavigationController *roomListNavigationController = [[UINavigationController alloc] initWithRootViewController:roomListViewController];
    roomListNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [navigationController pushViewController:roomListNavigationController animated:YES];
}

/**
Obtain main view controller of TapTalk Live
*/
- (TTLRoomListViewController *_Nonnull)getTapTalkLiveViewMainController {
    TTLRoomListViewController *roomListViewController = [TapTalkLive sharedInstance].roomListViewController;
    [roomListViewController openCreateCaseFormViewIfNeeded];
    roomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return roomListViewController;
}

#pragma mark - TapTalk Delegate
#pragma mark TapUIRoomList
- (void)tapTalkNewChatButtonTapped:(UIViewController *)currentViewController
  currentShownNavigationController:(UINavigationController *)currentNavigationController {
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = currentNavigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeWithCloseButton];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [currentNavigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
}

#pragma mark TapUICustomKeyboard
- (NSArray<TAPCustomKeyboardItemModel *> *)setCustomKeyboardItemsForRoom:(TAPRoomModel * _Nonnull)room sender:(TAPUserModel * _Nonnull)sender recipient:(TAPUserModel * _Nullable)recipient {
  //Set custom keyboard option items
    TTLImage *checkListImage = [UIImage imageNamed:@"TTLIconCheck" inBundle:[TTLUtil currentBundle] withConfiguration:nil];
    checkListImage = [checkListImage setImageTintColor:[TTLUtil getColor:@"191919"]];
    TAPCustomKeyboardItemModel *customKeyboardItem = [TAPCustomKeyboardItemModel createCustomKeyboardItemWithImage:checkListImage itemName:NSLocalizedString(@"Mark as solved", @"") itemID:@"1"];
    return @[customKeyboardItem];
}

- (void)customKeyboardItemTappedWithRoom:(TAPRoomModel * _Nonnull)room
                                  sender:(TAPUserModel * _Nonnull)sender
                               recipient:(TAPUserModel * _Nullable)recipient
                            keyboardItem:(TAPCustomKeyboardItemModel * _Nonnull)keyboardItem {
  //Do an action when user taps a custom keyboard item
    
}

#pragma mark - Custom Method
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

@end
