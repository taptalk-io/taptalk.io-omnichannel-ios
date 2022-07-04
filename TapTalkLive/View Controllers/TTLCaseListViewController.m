//
//  TTLCaseListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 10/02/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCaseListViewController.h"
#import "TTLCreateCaseViewController.h"
#import <TapTalk/TapUI.h>
#import <TapTalk/TAPChatManager.h>
#import <TapTalk/TAPDataManager.h>
#import <TapTalk/TapUtil.h>
#import <TapTalk/TAPMessageStatusManager.h>
#import <TapTalk/TapUIChatViewController.h>
#import <TapTalk/TAPRoomListTableViewCell.h>
//#import <TapTalk/TapUIRoomListViewController.h>
//#import <TapTalk/TAPRoomListView.h>

@interface TTLCaseListViewController () <UITableViewDelegate, UITableViewDataSource, TAPChatManagerDelegate, TAPChatViewControllerDelegate>

@property IBOutlet UIView *brandBackgroundView;
@property IBOutlet TTLImageView *logoImageView;
@property IBOutlet UIImageView *backButtonImageView;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UIView *cancelView;
@property IBOutlet UIButton *cancelButton;
@property IBOutlet UIView *caseListTopBackgroundView;
@property IBOutlet UIView *caseListTopSeparatorView;
@property IBOutlet UIView *sendNewChatContainerView;
@property IBOutlet UIView *sendMessageButtonContainerView;
@property IBOutlet UILabel *sendNewChatLabel;
@property IBOutlet TTLImageView *sendNewChatImageView;
@property IBOutlet UIButton *sendNewChatButton;
//@property IBOutlet TAPRoomListView *caseListView;
@property IBOutlet UIView *caseListView;
@property IBOutlet UITableView *caseListTableView;

//@property (strong, nonatomic) NSMutableArray *unreadRoomIDs;
@property (strong, nonatomic) NSMutableDictionary *unreadMentionDictionary;
@property (strong, nonatomic) NSString *readUnreadStateString;
@property (strong, nonatomic) UIImage *readUnreadStateImage;
@property (nonatomic) NSInteger firstUnreadProcessCount;
@property (nonatomic) NSInteger firstUnreadTotalCount;
@property (nonatomic) BOOL isNeedRefreshOnNetworkDown;
@property (nonatomic) BOOL closeRoomListWhenCreateCaseIsClosed;

- (IBAction)cancelButtonDidTapped:(id)sender;
- (IBAction)sendNewChatButtonDidTapped:(id)sender;

@end

@implementation TTLCaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:TAP_NOTIFICATION_REACHABILITY_STATUS_CHANGED object:nil];
    
    //Add chat manager delegate
    [[TAPChatManager sharedManager] addDelegate:self];
    
    if (@available(iOS 15.0, *)) {
        [self.caseListTableView setSectionHeaderTopPadding:0.0f];
    }
    
    self.caseListTableView.delegate = self;
    self.caseListTableView.dataSource = self;
    self.caseListTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [self.caseListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    _caseListArray = [NSMutableArray array];
    _caseListDictionary = [NSMutableDictionary dictionary];
    _unreadMentionDictionary = [NSMutableDictionary dictionary];
    
    // Fetch unread room IDs from preference
//    _unreadRoomIDs = [TAPDataManager getUnreadRoomIDs];
    
    self.brandBackgroundView.backgroundColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
    
    if (self.navigationType == TTLCaseListViewControllerNavigationTypePresent) {
        self.backButtonImageView.image = [UIImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if (self.navigationType == TTLCaseListViewControllerNavigationTypePush) {
        self.backButtonImageView.image = [UIImage imageNamed:@"TTLIconBackArrow" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    self.backButtonImageView.image = [self.backButtonImageView.image imageWithTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.sendMessageButtonContainerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientLight].CGColor, (id)[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBackgroundGradientDark].CGColor, nil];
    gradient.startPoint = CGPointMake(0.0f, 0.0f);
    gradient.endPoint = CGPointMake(0.0f, 1.0f);
    [self.sendMessageButtonContainerView.layer insertSublayer:gradient atIndex:0];
    
    self.sendMessageButtonContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorButtonActiveBorder].CGColor;
    
    self.sendMessageButtonContainerView.layer.cornerRadius = 8.0f;
    self.sendMessageButtonContainerView.clipsToBounds = YES;
    
    self.caseListTopBackgroundView.clipsToBounds = YES;
    self.caseListTopBackgroundView.layer.cornerRadius = 8.0f;
    self.caseListTopBackgroundView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    self.caseListTopSeparatorView.clipsToBounds = YES;
    self.caseListTopSeparatorView.layer.cornerRadius = 8.0f;
    self.caseListTopSeparatorView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    // View appear sequence
    [self viewLoadedSequence];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewAppear = YES;
    
    if ([[TapTalk sharedInstance] getTapTalkSocketConnectionMode] == TapTalkSocketConnectionModeConnectIfNeeded) {
        [[TapTalk sharedInstance] connectWithSuccess:^{
                    
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewAppear = NO;
    
    if ([[TapTalk sharedInstance] getTapTalkSocketConnectionMode] == TapTalkSocketConnectionModeConnectIfNeeded) {
        [[TapTalk sharedInstance] disconnectWithCompletionHandler:^{
            
        }];
    }
}

- (void)dealloc {
    [[TAPChatManager sharedManager] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TAP_NOTIFICATION_REACHABILITY_STATUS_CHANGED object:nil];
}

#pragma mark - Data Source

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.caseListArray count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 74.0f;
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellID = @"TAPRoomListTableViewCell";
        
        TAPRoomListTableViewCell *cell = [[TAPRoomListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        TAPRoomListModel *roomList = [self.caseListArray objectAtIndex:indexPath.row];
        cell.tableView = tableView;
        [cell setRoomListTableViewCellWithData:roomList updateUnreadBubble:NO];
        
//        if (indexPath.row == [self.caseListArray count] - 1) {
//            [cell setIsLastCellSeparator:YES];
//        }
//        else {
            [cell setIsLastCellSeparator:NO];
//        }
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    return footer;
}

#pragma mark - Delegate

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TAPRoomListModel *selectedRoomList = [self.caseListArray objectAtIndex:indexPath.row];
    TAPRoomModel *selectedRoom = selectedRoomList.lastMessage.room;
    
    [[TapUI sharedInstance] createRoomWithRoom:selectedRoom success:^(TapUIChatViewController * _Nonnull chatViewController) {
        chatViewController.delegate = self;
        chatViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }];
}

#pragma mark TAPChatManagerDelegate
- (void)chatManagerDidReceiveNewMessageOnOtherRoom:(TAPMessageModel *)message {
    [self processMessageFromSocket:message isNewMessage:YES];
}

- (void)chatManagerDidReceiveUpdateMessageOnOtherRoom:(TAPMessageModel *)message {
    [self processMessageFromSocket:message isNewMessage:NO];
}

- (void)chatManagerDidReceiveNewMessageInActiveRoom:(TAPMessageModel *)message {
    [self processMessageFromSocket:message isNewMessage:YES];
}

- (void)chatManagerDidReceiveUpdateMessageInActiveRoom:(TAPMessageModel *)message {
    [self processMessageFromSocket:message isNewMessage:NO];
}

- (void)chatManagerDidSendNewMessage:(TAPMessageModel *)message {
    [self processMessageFromSocket:message isNewMessage:YES];
}

- (void)chatManagerDidReceiveStartTyping:(TAPTypingModel *)typing {
    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:typing.roomID];
    
    NSInteger index = [self.caseListArray indexOfObject:roomList];
    TAPRoomListTableViewCell *cell = (TAPRoomListTableViewCell *)[self.caseListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell setAsTyping:YES];
}

- (void)chatManagerDidReceiveStopTyping:(TAPTypingModel *)typing {
    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:typing.roomID];

    NSInteger index = [self.caseListArray indexOfObject:roomList];
    TAPRoomListTableViewCell *cell = (TAPRoomListTableViewCell *)[self.caseListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell setAsTyping:NO];
}

- (void)chatViewControllerDidLeaveOrDeleteGroupWithRoom:(TAPRoomModel *)room {
    //Delete room & refresh the UI
    TAPRoomListModel *deletedRoomList = [self.caseListDictionary objectForKey:room.roomID];
    if (deletedRoomList) {
        NSInteger deletedIndex = [self.caseListArray indexOfObject:deletedRoomList];
        [self.caseListArray removeObjectAtIndex:deletedIndex];
        [self.caseListDictionary removeObjectForKey:room.roomID];
        
        NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:deletedIndex inSection:0];
        [self.caseListTableView deleteRowsAtIndexPaths:@[deletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark TapUIChatViewControllerDelegate
- (void)chatViewControllerShouldUpdateUnreadBubbleForRoomID:(NSString *)roomID {
    NSInteger readCount = [[TAPMessageStatusManager sharedManager] getReadCountAndClearDictionaryForRoomID:roomID];
    NSInteger readMentionCount = [[TAPMessageStatusManager sharedManager] getReadMentionCountAndClearDictionaryForRoomID:roomID];
    
    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:roomID];
    roomList.numberOfUnreadMessages = roomList.numberOfUnreadMessages - readCount;
    roomList.numberOfUnreadMentions = roomList.numberOfUnreadMentions - readMentionCount;
    
    if (roomList.numberOfUnreadMessages < 0) {
        roomList.numberOfUnreadMessages = 0;
    }
    
    if (roomList.numberOfUnreadMentions < 0) {
        roomList.numberOfUnreadMentions = 0;
    }
    
//    TAPMessageModel *selectedMessage = roomList.lastMessage;
//    TAPRoomModel *selectedRoom = selectedMessage.room;
//    roomList.isMarkedAsUnread = NO;
//    [self.unreadRoomIDs removeObject:selectedRoom.roomID];
//    [self callApiGetMarkedUnreadIDs];
    
    NSInteger cellRow = [self.caseListArray indexOfObject:roomList];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellRow inSection:0];
    [self updateCellDataAtIndexPath:cellIndexPath updateUnreadBubble:YES];
}

- (void)chatViewControllerShouldClearUnreadBubbleForRoomID:(NSString *)roomID {
    //Force mark unread bubble and unread mention to 0
    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:roomID];
    TAPMessageModel *selectedMessage = roomList.lastMessage;
    TAPRoomModel *selectedRoom = selectedMessage.room;
    roomList.numberOfUnreadMessages = 0;
    roomList.numberOfUnreadMentions = 0;
    roomList.isMarkedAsUnread = NO;
//    [self.unreadRoomIDs removeObject:selectedRoom.roomID];
//    [self callApiGetMarkedUnreadIDs];
        
    NSInteger cellRow = [self.caseListArray indexOfObject:roomList];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellRow inSection:0];
    [self updateCellDataAtIndexPath:cellIndexPath updateUnreadBubble:YES];
}

- (void)chatViewControllerDidPressCloseButton {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Custom Method

- (IBAction)cancelButtonDidTapped:(id)sender {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate didTappedCloseButtonInCaseListViewWithCurrentShownNavigationController:self.navigationController];
    }
    else if (self.navigationType == TTLCaseListViewControllerNavigationTypePresent) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else if (self.navigationType == TTLCaseListViewControllerNavigationTypePush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)sendNewChatButtonDidTapped:(id)sender {
    [self showCreateCaseFormView];
}

- (void)mapMessagesToCaseListArrayAndDictionary:(NSArray *)messageArray {
    if (_caseListArray != nil) {
        [self.caseListArray removeAllObjects];
        _caseListArray = nil;
    }
    
    if (_caseListDictionary != nil) {
        [self.caseListDictionary removeAllObjects];
        _caseListDictionary = nil;
    }
    
    _caseListDictionary = [[NSMutableDictionary alloc] init];
    _caseListArray = [[NSMutableArray alloc] init];
    
//    NSArray *unreadRoomArray = [self.unreadRoomIDs copy];
    
    for (TAPMessageModel *message in messageArray) {
        TAPRoomModel *room = message.room;
        NSString *roomID = room.roomID;
        roomID = [TAPUtil nullToEmptyString:roomID];
        
        TAPRoomListModel *roomList = [TAPRoomListModel new];
        roomList.lastMessage = message;
//        if([unreadRoomArray containsObject:room.roomID]){
//            roomList.isMarkedAsUnread = YES;
//        }
        
        [self insertRoomListToArrayAndDictionary:roomList atIndex:[self.caseListArray count]];
    }
    
    [self getAndUpdateNumberOfUnreadToDelegate];
    
}

- (void)insertRoomListToArrayAndDictionary:(TAPRoomListModel *)roomList atIndex:(NSInteger)index {
    [self.caseListArray insertObject:roomList atIndex:index];
    [self.caseListDictionary setObject:roomList forKey:roomList.lastMessage.room.roomID];
}

- (void)viewLoadedSequence {
    if ([TAPChatManager sharedManager].activeUser == nil) {
        [[TAPChatManager sharedManager] disconnect];
        
        if ([TapTalk sharedInstance].isAuthenticated) {
            id<TapTalkDelegate> tapTalkDelegate = [TapTalk sharedInstance].delegate;
            if ([tapTalkDelegate respondsToSelector:@selector(tapTalkRefreshTokenExpired)]) {
                [tapTalkDelegate tapTalkRefreshTokenExpired];
            }
        }
        
        return; //User not logged in
    }
    
    if (self.isShouldNotLoadFromAPI) {
        //Load from database only
        [self reloadLocalDataAndUpdateUILogicAnimated:NO];
    }
    else {
        //Load from API and database
        _isShouldNotLoadFromAPI = YES;
        [self runFullRefreshSequence];
    }
}

- (void)runFullRefreshSequence {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //Save pending messages, new messages, waiting response messages, and waiting upload file messages to database
        [[TAPChatManager sharedManager] saveAllUnsentMessageInMainThread];
        
        [TAPDataManager getRoomListSuccess:^(NSArray *resultArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isShouldAnimate = YES;
                
                if (self.caseListArray == nil || [self.caseListArray count] <= 0) {
                    isShouldAnimate = NO;
                }
                
                [self refreshViewAndQueryUnreadLogicWithMessageArray:resultArray animateReloadData:isShouldAnimate];
                
                [self fetchDataFromAPI];
            });
        } failure:^(NSError *error) {
            
        }];
    });
    
    
}

- (void)fetchDataFromAPI {
    TAPUserModel *activeUser = [TAPChatManager sharedManager].activeUser;
    NSString *userID = activeUser.userID;
    userID = [TAPUtil nullToEmptyString:userID];
    
    BOOL isDoneFirstSetup = [[NSUserDefaults standardUserDefaults] secureBoolForKey:TAP_PREFS_IS_DONE_FIRST_SETUP valid:nil];
    if (!isDoneFirstSetup) {
        // Get case list on first setup
        [TTLDataManager callAPIGetCaseListSuccess:^(NSArray<TTLCaseModel *> * _Nonnull caseListArray) {
            NSMutableArray *messageArray = [NSMutableArray array];
            for (TTLCaseModel *caseModel in caseListArray) {
                [messageArray addObject:caseModel.tapTalkRoom.lastMessage];
            }
            [self handleGetCaseListSuccess:messageArray];
        } failure:^(NSError * _Nonnull error) {
            self.isShouldNotLoadFromAPI = NO;
        }];
        
        return;
    }
    
    //Not first setup, get new and updated message
    [TAPDataManager callAPIGetNewAndUpdatedMessageSuccess:^(NSArray *messageArray) {
        [self handleNewAndUpdatedSuccess:messageArray];
        
    } failure:^(NSError *error) {
        self.isShouldNotLoadFromAPI = NO;
    }];
}

- (void)handleGetCaseListSuccess:(NSArray *)messageArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TAP_PREFS_IS_DONE_FIRST_SETUP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
    [self insertReloadMessageAndUpdateUILogicWithMessageArray:messageArray];
}

- (void)handleNewAndUpdatedSuccess:(NSArray *)messageArray{
    [self insertReloadMessageAndUpdateUILogicWithMessageArray:messageArray];
    
    // Update leftover message status to delivered
    if ([messageArray count] != 0) {
        [[TAPMessageStatusManager sharedManager] filterAndUpdateBulkMessageStatusToDeliveredWithArray:messageArray];
    }
    
    // Delete physical files when isDeleted = 1 (message is deleted)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (TAPMessageModel *message in messageArray) {
            if (message.isDeleted) {
                [TAPDataManager deletePhysicalFilesInBackgroundWithMessage:message success:^{
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    });
}

- (void)insertReloadMessageAndUpdateUILogicWithMessageArray:(NSArray *)messageArray {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // Save messages to database
        [TAPDataManager updateOrInsertDatabaseMessageInMainThreadWithData:messageArray success:^{
            //Get room list data from database and refresh UI
            [self reloadLocalDataAndUpdateUILogicAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void)reloadLocalDataAndUpdateUILogicAnimated:(BOOL)animated {
    [TAPDataManager getRoomListSuccess:^(NSArray *resultArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TAP_PREFS_IS_DONE_FIRST_SETUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self refreshViewAndQueryUnreadLogicWithMessageArray:resultArray animateReloadData:animated];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)refreshViewAndQueryUnreadLogicWithMessageArray:(NSArray *)messageArray animateReloadData:(BOOL)animateReloadData {
    BOOL isDoneFirstSetup = [[NSUserDefaults standardUserDefaults] secureBoolForKey:TAP_PREFS_IS_DONE_FIRST_SETUP valid:nil];
    
    if (!isDoneFirstSetup) {
        
    }
    else if ([self.caseListArray count] <= 0 && [messageArray count] <= 0) {
        
    }
    else if ([self.caseListArray count] <= 0 && [messageArray count] > 0) {
        //Show data first before query unread message
        [self mapMessagesToCaseListArrayAndDictionary:messageArray];
        
        [UIView performWithoutAnimation:^{ //Try to remove table view reload data flicker
            [self.caseListTableView reloadData];
            [self.caseListTableView layoutIfNeeded];
        }];
    }
    else {
        //Save old sequence to array and database
        NSMutableArray *oldcaseListArray = [NSMutableArray arrayWithArray:self.caseListArray];
        NSMutableDictionary *oldcaseListDictionary = [NSMutableDictionary dictionaryWithDictionary:self.caseListDictionary];
        
        [self mapMessagesToCaseListArrayAndDictionary:messageArray];
        
        if (animateReloadData && self.isViewAppear) {
            //Update UI movement changes animation
            
            NSMutableArray *insertIndexArray = [NSMutableArray array];
            NSMutableArray *moveFromIndexArray = [NSMutableArray array];
            NSMutableArray *moveToIndexArray = [NSMutableArray array];
            
            for (NSInteger newIndex = 0; newIndex < [self.caseListArray count]; newIndex++) {
                TAPRoomListModel *newRoomList = [self.caseListArray objectAtIndex:newIndex];
                
                if (newRoomList == nil) {
                    continue;
                }
                
                TAPRoomListModel *oldRoomList = [oldcaseListDictionary objectForKey:newRoomList.lastMessage.room.roomID];
                
                if (oldRoomList == nil) {
                    //Room list not found in old data, so this is a new room
                    //Populate old data
                    [oldcaseListArray insertObject:newRoomList atIndex:newIndex];
                    [oldcaseListDictionary setObject:newRoomList forKey:newRoomList.lastMessage.room.roomID];
                    
                    [insertIndexArray addObject:[NSIndexPath indexPathForRow:newIndex inSection:0]];
                    continue;
                }
                
                NSInteger oldIndex = [oldcaseListArray indexOfObject:oldRoomList];
                
                if (newIndex == oldIndex) {
                    //Index is same, no need to move cell, just update data
                    [self updateCellDataAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0] updateUnreadBubble:NO];
                    continue;
                }
                
                //Move cell to new index
                //Populate old data
                [oldcaseListArray removeObjectAtIndex:oldIndex];
                [oldcaseListArray insertObject:oldRoomList atIndex:newIndex];
                
                [moveFromIndexArray addObject:[NSString stringWithFormat:@"%ld", oldIndex]];
                [moveToIndexArray addObject:[NSString stringWithFormat:@"%ld", newIndex]];
            }
            
            //Handle room insert
            if([insertIndexArray count] > 0) {
                [self.caseListTableView performBatchUpdates:^{
                    //changing beginUpdates and endUpdates with this because of deprecation
                    [self.caseListTableView insertRowsAtIndexPaths:insertIndexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:^(BOOL finished) {
                    [self.caseListTableView scrollsToTop];
                }];
            }
            
            //Handle room move
            if ([moveFromIndexArray count] > 0) {
                for (int count = 0; count < [moveFromIndexArray count]; count++) {
                    NSInteger oldIndex = [[moveFromIndexArray objectAtIndex:count] intValue];
                    NSInteger newIndex = [[moveToIndexArray objectAtIndex:count] intValue];
                    
                    [self updateCellDataAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0] updateUnreadBubble:NO];
                    [self.caseListTableView performBatchUpdates:^{
                        //changing beginUpdates and endUpdates with this because of deprecation
                        [self.caseListTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0]];
                    } completion:^(BOOL finished) {
                    }];
                }
            }
            
            //Handle room deletion
            NSArray *loopedcaseListArray = [NSArray arrayWithArray:oldcaseListArray];
            for (NSInteger index = 0; index < [loopedcaseListArray count]; index++) {
                TAPRoomListModel *oldRoomList = [oldcaseListArray objectAtIndex:index];
                
                if (oldRoomList == nil) {
                    continue;
                }
                
                //Check if room list exist in new response
                TAPRoomListModel *newRoomList = [self.caseListDictionary objectForKey:oldRoomList.lastMessage.room.roomID];
                
                if (newRoomList == nil) {
                    //Data not exist, delete cell
                    NSInteger oldIndex = [oldcaseListArray indexOfObject:oldRoomList];
                    [oldcaseListArray removeObjectAtIndex:oldIndex];
                    [self.caseListTableView performBatchUpdates:^{
                        //changing beginUpdates and endUpdates with this because of deprecation
                        [self.caseListTableView deleteRowsAtIndexPaths:[NSIndexPath indexPathForRow:oldIndex inSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } completion:^(BOOL finished) {
                    }];
                }
            }
        }
        else if (!self.isViewAppear) {
            //View not appear, just reload table view without animation
            [UIView performWithoutAnimation:^{ //Try to remove table view reload data flicker
                [self.caseListTableView reloadData];
                [self.caseListTableView layoutIfNeeded];
            }];
        }
    }
    
    //Query unread count and update UI
    [self queryNumberOfUnreadMessageInCaseListArrayInBackgroundAndUpdateUIAndReloadTableView:!animateReloadData];
}

- (void)queryNumberOfUnreadMessageInCaseListArrayInBackgroundAndUpdateUIAndReloadTableView:(BOOL)reloadTableView {
    NSArray *roomListLocalArray = [NSArray arrayWithArray:self.caseListArray];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        if ([roomListLocalArray count] == 0) {
            return;
        }
        
        _firstUnreadProcessCount = 0;
        _firstUnreadTotalCount = [roomListLocalArray count];
        NSMutableDictionary *unreadMentionDataDictionary = [NSMutableDictionary dictionary];
        
        for (TAPRoomListModel *roomList in roomListLocalArray) {
            TAPMessageModel *messageData = roomList.lastMessage;
            TAPRoomModel *roomData = messageData.room;
            NSString *roomIDString = roomData.roomID;
            roomIDString = [TAPUtil nullToEmptyString:roomIDString];
            
            NSString *usernameString = [TAPDataManager getActiveUser].username;
            usernameString = [TAPUtil nullToEmptyString:usernameString];
            NSString *activeUserID = [TAPDataManager getActiveUser].userID;
            activeUserID = [TAPUtil nullToEmptyString:activeUserID];
            
            [TAPDataManager getDatabaseUnreadMentionsInRoomWithUsername:usernameString roomID:roomIDString activeUserID:activeUserID success:^(NSArray *unreadMentionMessages) {
                NSInteger totalUnreadMention = [unreadMentionMessages count];
                [unreadMentionDataDictionary setObject:[NSNumber numberWithInteger:totalUnreadMention] forKey:roomIDString];
                
                [TAPDataManager getDatabaseUnreadMessagesInRoomWithRoomID:roomIDString activeUserID:[TAPChatManager sharedManager].activeUser.userID success:^(NSArray *unreadMessages) {
                    //Set number of unread messages to array and dictionary
                    NSInteger numberOfUnreadMessages = [unreadMessages count];
                    NSInteger numberOfUnreadMentions = [[unreadMentionDataDictionary objectForKey:roomIDString] integerValue];
                    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:roomIDString];
                    roomList.numberOfUnreadMessages = numberOfUnreadMessages;
                    roomList.numberOfUnreadMentions = numberOfUnreadMentions;
                    
                    if(roomList.numberOfUnreadMessages < 0) {
                        roomList.numberOfUnreadMessages = 0;
                    }
                    
                    if(roomList.numberOfUnreadMentions < 0) {
                        roomList.numberOfUnreadMentions = 0;
                    }
                    
                    _firstUnreadProcessCount++;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.firstUnreadProcessCount >= self.firstUnreadTotalCount) {
                            [self getAndUpdateNumberOfUnreadToDelegate];
                        }
                        
                        NSInteger cellRow = [self.caseListArray indexOfObject:roomList];
                        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellRow inSection:0];
                        [self updateCellDataAtIndexPath:cellIndexPath updateUnreadBubble:YES];
                    });
                } failure:^(NSError *error) {

                }];
            } failure:^(NSError *error) {
                
            }];
        }
        
        if (reloadTableView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView performWithoutAnimation:^{ //Try to remove table view reload data flicker
                    [self.caseListTableView reloadData];
                    [self.caseListTableView layoutIfNeeded];
                }];
            });
        }
    });
}

- (void)processMessageFromSocket:(TAPMessageModel *)message isNewMessage:(BOOL)isNewMessage {
    NSString *messageRoomID = message.room.roomID;
    
    TAPRoomListModel *roomList = [self.caseListDictionary objectForKey:messageRoomID];
    
    if (roomList != nil) {
        //Room is on the list
        TAPMessageModel *roomLastMessage = roomList.lastMessage;
        
        if (message.isHidden) {
            //Don't process last message that is hidden
            return;
        }
        
        if([roomLastMessage.created integerValue] > [message.created integerValue]) {
            //Don't process last message, current last message is newer that the incoming one
            return;
        }
        
        if ([roomLastMessage.localID isEqualToString:message.localID]) {
            //Last message is same, just updated, update the data only
            roomLastMessage.updated = message.updated;
            roomLastMessage.isDeleted = message.isDeleted;
            roomLastMessage.isSending = message.isSending;
            roomLastMessage.isFailedSend = message.isFailedSend;
            roomLastMessage.isRead = message.isRead;
            roomLastMessage.isDelivered = message.isDelivered;
            roomLastMessage.isHidden = message.isHidden;
            roomLastMessage.body = message.body;
            
            NSInteger cellRow = [self.caseListArray indexOfObject:roomList];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellRow inSection:0];
            [self updateCellDataAtIndexPath:indexPath updateUnreadBubble:NO];
        }
        else {
            //Last message is different, move cell to top and update last message
            roomList.lastMessage = message;

            if (![message.user.userID isEqualToString:[TAPChatManager sharedManager].activeUser.userID] && isNewMessage) {
                //Message from other recipient, increment number of unread message
                roomList.numberOfUnreadMessages++;
                
                BOOL hasMention = [TAPUtil isActiveUserMentionedWithMessage:message activeUser:[TAPDataManager getActiveUser]];
                if (hasMention) {
                    roomList.numberOfUnreadMentions++;
                }
            }

            NSInteger cellRow = [self.caseListArray indexOfObject:roomList];
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:cellRow inSection:0];

            [self updateCellDataAtIndexPath:currentIndexPath updateUnreadBubble:YES];

            if (currentIndexPath != 0 && isNewMessage) {
                //Move cell to top
                [self.caseListArray removeObject:roomList];
                [self.caseListArray insertObject:roomList atIndex:0];
                [self.caseListTableView performBatchUpdates:^{
                    //changing beginUpdates and endUpdates with this because of deprecation
                    [self.caseListTableView moveRowAtIndexPath:currentIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
    else {
        //Room is not on the list, create new room
        TAPRoomListModel *newRoomList = [TAPRoomListModel new];
        newRoomList.lastMessage = message;
        
        if (message.isHidden) {
            //Don't process last message that is hidden
            return;
        }
        
        if (![message.user.userID isEqualToString:[TAPChatManager sharedManager].activeUser.userID]) {
            //Message from other recipient, set unread as 1
            newRoomList.numberOfUnreadMessages = 1;
            
            BOOL hasMention = [TAPUtil isActiveUserMentionedWithMessage:message activeUser:[TAPDataManager getActiveUser]];
            if (hasMention) {
                newRoomList.numberOfUnreadMentions = 1;
            }
            else {
                newRoomList.numberOfUnreadMentions = 0;
            }
        }
        else {
            //Current user send new message, set unread to 0
            newRoomList.numberOfUnreadMessages = 0;
            newRoomList.numberOfUnreadMentions = 0;
        }
        
        [self insertRoomListToArrayAndDictionary:newRoomList atIndex:0];
        [self.caseListTableView performBatchUpdates:^{
            //changing beginUpdates and endUpdates with this because of deprecation
            [self.caseListTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } completion:^(BOOL finished) {

        }];
    }
    
    [self getAndUpdateNumberOfUnreadToDelegate];
}

- (void)updateCellDataAtIndexPath:(NSIndexPath *)indexPath updateUnreadBubble:(BOOL)updateUnreadBubble {
    if (indexPath.row >= [self.caseListArray count]) {
        return;
    }
    
    TAPRoomListTableViewCell *cell = [self.caseListTableView cellForRowAtIndexPath:indexPath];
    TAPRoomListModel *roomList = [self.caseListArray objectAtIndex:indexPath.row];
    [cell setRoomListTableViewCellWithData:roomList updateUnreadBubble:updateUnreadBubble];
    
    //Check message draft
    NSString *draftMessage = [[TAPChatManager sharedManager] getMessageFromDraftWithRoomID:roomList.lastMessage.room.roomID];
    draftMessage = [TAPUtil nullToEmptyString:draftMessage];
    if (![draftMessage isEqualToString:@""]) {
        [cell showMessageDraftWithMessage:draftMessage];
    }
}

- (void)reachabilityStatusChange:(NSNotification *)notification {
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        if (self.isNeedRefreshOnNetworkDown) {
            //Reload new data from API
            _isShouldNotLoadFromAPI = NO;
            [self viewLoadedSequence];
            
            _isNeedRefreshOnNetworkDown = NO;
        }
    }
    else {
        _isNeedRefreshOnNetworkDown = YES;
    }
}

- (void)clearAllData {
    [self.caseListArray removeAllObjects];
    [self.caseListDictionary removeAllObjects];
    [self.caseListTableView reloadData];
}

- (void)getAndUpdateNumberOfUnreadToDelegate {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSInteger unreadRoomCount = 0;
        for(TAPRoomListModel *roomList in self.caseListArray) {
            TAPMessageModel *selectedMessage = roomList.lastMessage;
            TAPRoomModel *room = selectedMessage.room;
            if(roomList.numberOfUnreadMessages > 0 || roomList.isMarkedAsUnread) {
                unreadRoomCount++;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Send delegate to be used to client side, update to delegate after check unread database
            if ([[TapTalk sharedInstance].delegate respondsToSelector:@selector(tapTalkUnreadChatRoomBadgeCountUpdated:)]) {
                [[TapTalk sharedInstance].delegate tapTalkUnreadChatRoomBadgeCountUpdated:unreadRoomCount];
            }
        });
        
    });
}

//- (void)callApiGetMarkedUnreadIDs{
//    [TAPDataManager callAPIGetMarkedAsUnreadChatRoomList:^(NSArray <NSString *> *roomIDs){
//        // Saved to preference
//    }
//    failure:^(NSError *error) {
//    }];
//}

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

@end
