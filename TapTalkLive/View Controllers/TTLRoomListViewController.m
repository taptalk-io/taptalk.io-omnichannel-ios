//
//  TTLRoomListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 22/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLRoomListViewController.h"
#import "TapTalkLive.h"

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
- (void)presentCreateCaseFormViewIfNeeded {
    [[TapTalkLive sharedInstance] openCreateCaseFormWithCurrentNavigationController:self.navigationController];
}
@end
