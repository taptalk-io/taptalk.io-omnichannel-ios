//
//  TTLFaqViewController.m
//  TapTalkLive
//
//  Created by Fikri on 3/13/23.
//

#import "TTLFaqViewController.h"
#import "TTLFaqParentTableViewCell.h"
#import "TTLFaqChildTableViewCell.h"
#import "OneTalkLiveChat.h"

@interface TTLFaqViewController ()<UITableViewDataSource, UITableViewDelegate, FaqParentTableViewCellDelegate, FaqChildTableViewCellDelegate, TTLCreateCaseViewControllerDelegate, TTLFaqViewControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isClose;
@end

@implementation TTLFaqViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorHomeBackground];
    
    [self showFooterView:YES];
    
    [TTLUtil fetchScfPathContentResponse:self.faqPathModel fetchChildContents:YES success:^(NSString *apiUrl, NSString *contentResponse) {
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scfPathContentResponseFetched:) name:TTL_NOTIFICATION_SCF_PATH_CONTENT_RESPONSE_FETCHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewController) name:TTL_NOTIFICATION_CREATE_CASE_SUCCEED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if(self.isClose) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TTL_NOTIFICATION_SCF_PATH_CONTENT_RESPONSE_FETCHED object:nil];
}

#pragma mark - FaqParentTableViewCellDelegate

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

- (void)faqParentUrlDidTapped:(NSURL *)url {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentUrlDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentUrlDidTapped:url currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:url fromNavigationController:self.navigationController options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @YES}];
    }
}

- (void)faqParentUrlDidLongPressed:(NSURL *)url {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentUrlDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentUrlDidLongPressed:url currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:url.absoluteString];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Link copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

- (void)faqParentEmailDidTapped:(NSURL *)email {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentEmailAddressDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentEmailAddressDidTapped:email currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:email fromNavigationController:self.navigationController];
    }
}

- (void)faqParentEmailDidLongPressed:(NSURL *)email {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentEmailAddressDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentEmailAddressDidLongPressed:email currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[email.absoluteString stringByReplacingOccurrencesOfString:@"mailto:" withString:@""]];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Email address copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

- (void)faqParentPhoneDidTapped:(NSString *)phone {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentPhoneNumberDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentPhoneNumberDidTapped:phoneURL currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:phoneURL fromNavigationController:self.navigationController];
    }
}

- (void)faqParentPhoneDidLongPressed:(NSString *)phone {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentPhoneNumberDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:self.faqPathModel contentPhoneNumberDidLongPressed:phoneURL currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:phone];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Phone number copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

#pragma mark - FaqChildTableViewCellDelegate

- (void)faqChild:(TTLFaqModel *)faqModel urlDidTapped:(NSURL *)url {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentUrlDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentUrlDidTapped:url currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:url fromNavigationController:self.navigationController options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @YES}];
    }
}

- (void)faqChild:(TTLFaqModel *)faqModel urlDidLongPressed:(NSURL *)url {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentUrlDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentUrlDidLongPressed:url currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:url.absoluteString];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Link copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

- (void)faqChild:(TTLFaqModel *)faqModel emailDidTapped:(NSURL *)email {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentEmailAddressDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentEmailAddressDidTapped:email currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:email fromNavigationController:self.navigationController];
    }
}

- (void)faqChild:(TTLFaqModel *)faqModel emailDidLongPressed:(NSURL *)email {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentEmailAddressDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentEmailAddressDidLongPressed:email currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[email.absoluteString stringByReplacingOccurrencesOfString:@"mailto:" withString:@""]];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Email address copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

- (void)faqChild:(TTLFaqModel *)faqModel phoneDidTapped:(NSString *)phone {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentPhoneNumberDidTapped:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentPhoneNumberDidTapped:phoneURL currentShownNavigationController:self.navigationController];
    }
    else {
        [TTLUtil openUrl:phoneURL fromNavigationController:self.navigationController];
    }
}

-(void)faqChild:(TTLFaqModel *)faqModel phoneDidLongPressed:(NSString *)phone {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(faq:contentPhoneNumberDidLongPressed:currentShownNavigationController:)]) {
        [tapTalkLiveDelegate faq:faqModel contentPhoneNumberDidLongPressed:phoneURL currentShownNavigationController:self.navigationController];
    }
    else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:phone];
        
        [self showSnackBar:TTLSnackBarTypeToast message:NSLocalizedStringFromTableInBundle(@"Phone number copied to clipboard.", nil, [TTLUtil currentBundle], @"") iconName:@""];
    }
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UINib *cellNib = [UINib nibWithNibName:@"TTLFaqParentTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[TTLFaqParentTableViewCell description]];
        TTLFaqParentTableViewCell *cell = (TTLFaqParentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TTLFaqParentTableViewCell description] forIndexPath:indexPath];
        cell.delegate = self;
        [cell setFaqParentData:self.faqPathModel];
        cell.navigationController = self.navigationController;
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
        UINib *cellNib = [UINib nibWithNibName:@"TTLFaqChildTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[TTLFaqChildTableViewCell description]];
        TTLFaqChildTableViewCell *cell = (TTLFaqChildTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TTLFaqChildTableViewCell description] forIndexPath:indexPath];
        TTLFaqModel *faqChild = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 1];
        cell.delegate = self;
        [cell setFaqChildWithData:faqChild];
        
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0) {
        TTLFaqModel *faqChild = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 1];
        id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
        if ([tapTalkLiveDelegate respondsToSelector:@selector(faqChildDidTapped:currentShownNavigationController:)]) {
                [tapTalkLiveDelegate faqChildDidTapped:faqChild currentShownNavigationController:self.navigationController];
            }
        else {
            TTLFaqViewController *faqViewController = [[TTLFaqViewController alloc] initWithNibName:@"TTLFaqViewController" bundle:[TTLUtil currentBundle]];
            faqViewController.faqPathModel = faqChild;
            faqViewController.delegate = self;
            [self.navigationController pushViewController:faqViewController animated:YES];
        }
    }
}

#pragma mark - Custom Methods

- (void)closeViewController {
    self.isClose = YES;
}

- (void)openNewMessageForm {
    if (![TTLUtil isEmptyString:[TTLDataManager getCreateNewCaseBlockingMessage]]) {
        [self showSnackBar:TTLSnackBarTypeWarning message:[TTLDataManager getCreateNewCaseBlockingMessage] iconName:@"TTLIconWarningTriangle"];
        return;
    }
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

- (void)scfPathContentResponseFetched:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *notificationParameterDictionary = (NSDictionary *)[notification object];
        notificationParameterDictionary = [TTLUtil nullToEmptyDictionary:notificationParameterDictionary];
        
        NSString *apiURL = [notificationParameterDictionary objectForKey:@"apiURL"];
        apiURL = [TTLUtil nullToEmptyString:apiURL];
        
        NSString *contentResponse = [notificationParameterDictionary objectForKey:@"contentResponse"];
        contentResponse = [TTLUtil nullToEmptyString:contentResponse];
        
        if ([self.faqPathModel.apiURL isEqualToString:apiURL] && ![TTLUtil isEmptyString:contentResponse]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    });
}

@end
