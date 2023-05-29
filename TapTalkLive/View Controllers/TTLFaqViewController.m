//
//  TTLFaqViewController.m
//  TapTalkLive
//
//  Created by Fikri on 3/13/23.
//

#import "TTLFaqViewController.h"
#import "FaqParentTableViewCell.h"
#import "FaqChildTableViewCell.h"

@interface TTLFaqViewController ()<UITableViewDataSource, UITableViewDelegate, FaqParentTableViewCellDelegate, TTLCreateCaseViewControllerDelegate, TTLFaqViewControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isClose;
@end

@implementation TTLFaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [TTLUtil getColor:@"FAFAFA"];
    
    [self showFooterView:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewController) name:TTL_NOTIFICATION_CREATE_CASE_SUCCEED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if(self.isClose) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark FaqParentTableViewCellDelegate
- (void)faqParentBackButtonDidTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(closeButtonInFaqDetailsViewDidTapped:currentShownNavigationController:)]) {
            [tapTalkLiveDelegate closeButtonInFaqDetailsViewDidTapped:self.faqPathModel currentShownNavigationController:self.navigationController];
        }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)faqParentTalkToAgentButtonDidTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(talkToAgentButtonDidTapped:currentShownNavigationController:)]) {
            [tapTalkLiveDelegate talkToAgentButtonDidTapped:self.faqPathModel currentShownNavigationController:self.navigationController];
        }
    else {
        [self openNewMessageForm];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UINib *cellNib = [UINib nibWithNibName:@"FaqParentTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[FaqParentTableViewCell description]];
        FaqParentTableViewCell *cell = (FaqParentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[FaqParentTableViewCell description] forIndexPath:indexPath];
        //[cell hideHeaderView];
        cell.delegate = self;
        [cell setFaqParentData:self.faqPathModel];
        [cell hideFaqLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.faqPathModel.childItems.count > 0) {
            [cell setTopRadius];
        }
        else {
            [cell setAllRoundRadius];
        }
        return cell;
    }
    else {
        UINib *cellNib = [UINib nibWithNibName:@"FaqChildTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[FaqChildTableViewCell description]];
        FaqChildTableViewCell *cell = (FaqChildTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[FaqChildTableViewCell description] forIndexPath:indexPath];
        NSDictionary *faqSequenceDict = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 1];
        [cell setFaqChildWithData:[TTLDataManager dictionaryToFaqModel:faqSequenceDict]];
        
        if(indexPath.row == self.faqPathModel.childItems.count) {
            [cell setLastChildCellView];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [self.faqPathModel.childItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0) {
        NSDictionary *faqSequenceDict = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 1];
        id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
        if ([tapTalkLiveDelegate respondsToSelector:@selector(faqChildDidTapped:currentShownNavigationController:)]) {
                [tapTalkLiveDelegate faqChildDidTapped:[TTLDataManager dictionaryToFaqModel:faqSequenceDict] currentShownNavigationController:self.navigationController];
            }
        else {
            TTLFaqViewController *faqViewController = [[TTLFaqViewController alloc] initWithNibName:@"TTLFaqViewController" bundle:[TTLUtil currentBundle]];
            faqViewController.faqPathModel = [TTLDataManager dictionaryToFaqModel:faqSequenceDict];
            faqViewController.delegate = self;
            [self.navigationController pushViewController:faqViewController animated:YES];
        }
    }
}

- (void)closeViewController {
    self.isClose = YES;
}

- (void)openNewMessageForm {
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = self.navigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeDefault];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    createCaseViewController.closeRoomListWhenCreateCaseIsClosed = NO;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    createCaseViewController.delegate = self;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
    /**
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    TTLUserModel *currentActiveUser = [TTLDataManager getActiveUser];
    NSString *currentActiveUserID = currentActiveUser.userID;
    currentActiveUserID = [TTLUtil nullToEmptyString:currentActiveUserID];
    if (![currentAccessToken isEqualToString:@""] && ![currentActiveUserID isEqualToString:@""]) {
       // [self handleSubmitCaseFormFlowAfterLogin];
        [[TapTalkLive sharedInstance] presentCreateCaseViewWithCurrentNavigationController:self.navigationController animated:NO];
    }
    else {
        //[self handleSubmitCaseFormFlow];
        [[TapTalkLive sharedInstance] presentCaseListViewWithCurrentNavigationController:self.navigationController animated:NO];
    }
    */
    
}

- (void)createCaseViewControllercreateCaseSucceed {
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(faqViewControllercreateCaseSucceed)]) {
        [self.delegate faqViewControllercreateCaseSucceed];
    }
}

- (void)faqViewControllercreateCaseSucceed {
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(faqViewControllercreateCaseSucceed)]) {
        [self.delegate faqViewControllercreateCaseSucceed];
    }
}

@end
