//
//  TTLFaqViewController.m
//  TapTalkLive
//
//  Created by Fikri on 3/13/23.
//

#import "TTLFaqViewController.h"
#import "FaqParentTableViewCell.h"
#import "FaqChildTableViewCell.h"

@interface TTLFaqViewController ()<UITableViewDataSource, UITableViewDelegate, FaqParentTableViewCellDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TTLFaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [TTLUtil getColor:@"FAFAFA"];
    
    [self showFooterView:YES];
}

#pragma mark FaqParentTableViewCellDelegate
- (void)faqParentBackButtonDidTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)faqParentTalkToAgentButtonDidTapped {
    [self openNewMessageForm];
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
        TTLFaqViewController *faqViewController = [[TTLFaqViewController alloc] initWithNibName:@"TTLFaqViewController" bundle:[TTLUtil currentBundle]];
        NSDictionary *faqSequenceDict = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 1];
        faqViewController.faqPathModel = [TTLDataManager dictionaryToFaqModel:faqSequenceDict];
        [self.navigationController pushViewController:faqViewController animated:YES];
    }
}

- (void)openNewMessageForm {
    /**
    TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
    createCaseViewController.previousNavigationController = self.navigationController;
    [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeDefault];
    createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    createCaseViewController.closeRoomListWhenCreateCaseIsClosed = NO;
    UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
    createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
    */
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
        [[TapTalkLive sharedInstance] presentTapTalkLiveViewWithCurrentNavigationController:self.navigationController animated:NO];
    }
    
}

@end
