//
//  TTLRoomListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 22/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLRoomListViewController.h"
#import "TTLCreateCaseViewController.h"

@interface TTLRoomListViewController ()

@end

@implementation TTLRoomListViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
    
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Custom Method
- (void)openCreateCaseFormViewIfNeeded {
    BOOL isContainCaseList = [[NSUserDefaults standardUserDefaults] secureBoolForKey:TTL_PREFS_IS_CONTAIN_CASE_LIST valid:nil];
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    currentAccessToken = [TTLUtil nullToEmptyString:currentAccessToken];
    
    if ([currentAccessToken isEqualToString:@""]) {
        [self performSelector:@selector(showCreateCaseFormView) withObject:nil afterDelay:0.3f];
    }
    else if (![currentAccessToken isEqualToString:@""] && !isContainCaseList) {
        [self performSelector:@selector(showCreateCaseFormView) withObject:nil afterDelay:0.3f];
    }
}

- (void)showCreateCaseFormView {
    
    [self hideSetupView];
    
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = self.navigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeDefault];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
}

@end
