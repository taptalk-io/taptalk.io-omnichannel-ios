//
//  TTLRoomListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 22/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLRoomListViewController.h"
#import "TTLCreateCaseViewController.h"
#import <TapTalk/TAPRoomListModel.h>
#import <TapTalk/TapUIChatViewController.h>
#import <TapTalk/TapUI.h>

@interface TTLRoomListViewController ()

- (void)closeButtonDidTapped;

@property (nonatomic) BOOL closeRoomListWhenCreateCaseIsClosed;

@end

@implementation TTLRoomListViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TTLImage *buttonImage = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    buttonImage = [buttonImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconNavigationBarCloseButton]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 18.0f);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
//    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
//    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:)]) {
//        //Show Close Button
        button.alpha = 1.0f;
        button.userInteractionEnabled = YES;
//    }
//    else {
//        button.alpha = 0.0f;
//        button.userInteractionEnabled = NO;
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Delegates
#pragma mark TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TAPRoomListModel *selectedRoomList = [self.roomListArray objectAtIndex:indexPath.row];
    TAPMessageModel *selectedMessage = selectedRoomList.lastMessage;
    TAPRoomModel *selectedRoom = selectedMessage.room;
    
    [[TapUI sharedInstance] createRoomWithRoom:selectedRoom success:^(TapUIChatViewController * _Nonnull chatViewController) {
        chatViewController.delegate = self;
        chatViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }];
}

#pragma mark - Custom Method
- (void)openCreateCaseFormViewIfNeeded {
    BOOL isContainCaseList = [[NSUserDefaults standardUserDefaults] secureBoolForKey:TTL_PREFS_IS_CONTAIN_CASE_LIST valid:nil];
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    currentAccessToken = [TTLUtil nullToEmptyString:currentAccessToken];
    
    if ([currentAccessToken isEqualToString:@""] || (![currentAccessToken isEqualToString:@""] && !isContainCaseList)) {
        _closeRoomListWhenCreateCaseIsClosed = YES;
        [self performSelector:@selector(showCreateCaseFormView) withObject:nil afterDelay:0.05f];
    }
}

- (void)showCreateCaseFormView {
    [self hideSetupView];
    
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = self.navigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeDefault];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    createCaseViewController.closeRoomListWhenCreateCaseIsClosed = self.closeRoomListWhenCreateCaseIsClosed;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
}


- (void)closeButtonDidTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:self.navigationController];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
