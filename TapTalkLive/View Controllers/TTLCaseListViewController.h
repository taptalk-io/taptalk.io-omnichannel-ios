//
//  TTLCaseListViewController.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 10/02/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseViewController.h"
#import "TAPRoomListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTLCaseListViewControllerNavigationType) {
    TTLCaseListViewControllerNavigationTypePresent = 0,
    TTLCaseListViewControllerNavigationTypePush = 1
};

@interface TTLCaseListViewController : TTLBaseViewController

@property (strong, atomic) NSMutableArray<TAPRoomListModel *> *caseListArray;
@property (strong, atomic) NSMutableDictionary<NSString *, TAPRoomListModel *> *caseListDictionary;

@property (nonatomic) TTLCaseListViewControllerNavigationType navigationType;
@property (nonatomic) BOOL isViewAppear;
@property (nonatomic) BOOL isShouldNotLoadFromAPI;

- (void)viewLoadedSequence;
- (void)openCreateCaseFormViewIfNeeded;

@end

NS_ASSUME_NONNULL_END
