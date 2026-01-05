//
//  HomeLauncherViewController.m
//  TapTalkLive
//
//  Created by Fikri on 3/1/23.
//

#import "TTLHomeLauncherViewController.h"
#import "TTLHomeHeaderTableViewCell.h"
#import "TTLFaqViewController.h"
#import "FaqParentTableViewCell.h"
#import "FaqChildTableViewCell.h"
#import "TTLCaseListViewController.h"
#import <TapTalk/TAPChatManager.h>
#import <TapTalk/TapUI.h>

@interface TTLHomeLauncherViewController () <UITableViewDataSource, UITableViewDelegate, TAPChatManagerDelegate, TTLHomeHeaderTableViewCellDelegate, FaqParentTableViewCellDelegate, FaqChildTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showCaseListSection;
@property (nonatomic, strong) TTLFaqModel *faqPathModel;
@end

@implementation TTLHomeLauncherViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[TAPChatManager sharedManager] addDelegate:self];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorHomeBackground];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    [self showFooterView:YES];
    
    NSDictionary *faqDictionary = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_FAQ valid:nil];
    _faqPathModel = [TTLDataManager dictionaryToFaqModel:faqDictionary];
    [TTLUtil fetchScfPathContentResponse:self.faqPathModel fetchChildContents:YES success:^(NSString *apiUrl, NSString *contentResponse) {
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scfPathUpdated:) name:TTL_NOTIFICATION_SCF_PATH_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scfPathContentResponseFetched:) name:TTL_NOTIFICATION_SCF_PATH_CONTENT_RESPONSE_FETCHED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewAppear = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewAppear = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TTL_NOTIFICATION_SCF_PATH_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TTL_NOTIFICATION_SCF_PATH_CONTENT_RESPONSE_FETCHED object:nil];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        UINib *cellNib = [UINib nibWithNibName:@"HomeHeaderTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[TTLHomeHeaderTableViewCell description]];
        TTLHomeHeaderTableViewCell *cell = (TTLHomeHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[TTLHomeHeaderTableViewCell description] forIndexPath:indexPath];
        cell.navigationController = self.navigationController;
        
        _showCaseListSection = [self isContainCaseList];
        if(!self.showCaseListSection) {
            [cell hideMessageHistoryView];
        }
        else {
            [cell hideSendDirectly];
        }
        NSArray *channelListDictionary = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_CHANNEL_LIST valid:nil];
        NSArray *channelList = [TTLDataManager dictionaryToChannelModelList:channelListDictionary];
        BOOL hasChannelLink = NO;
        if (channelListDictionary.count > 0) {
            for (TTLChannelModel *channel in channelList) {
                if (channel.isEnabled) {
                    hasChannelLink = YES;
                    break;
                }
            }
        }
        if (!hasChannelLink) {
            [cell hideChannelList];
            if (self.showCaseListSection) {
                [cell hideChannelContainer];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 1) {
        UINib *cellNib = [UINib nibWithNibName:@"FaqParentTableViewCell" bundle:[TTLUtil currentBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:[FaqParentTableViewCell description]];
        FaqParentTableViewCell *cell = (FaqParentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[FaqParentTableViewCell description] forIndexPath:indexPath];
        [cell hideHeaderView];
        [cell setFaqParentData:self.faqPathModel];
        cell.navigationController = self.navigationController;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
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
        TTLFaqModel *faqChild = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 2];
        [cell setFaqChildWithData:faqChild];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if(indexPath.row == self.faqPathModel.childItems.count + 1) {
            [cell setLastChildCellView];
        }
        return cell;
    }
    
    return nil;
    
   // CGRect cellFrame = cell.frame;
    //cellFrame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
   // cell.frame = cellFrame;
   // [cell layoutIfNeeded];
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.faqPathModel != nil) {
        if ([TTLUtil isEmptyString:self.faqPathModel.title] &&
            [TTLUtil isEmptyString:self.faqPathModel.content] &&
            [TTLUtil isEmptyArray:self.faqPathModel.childItems]
        ) {
            return 1;
        }
        return 2 + [self.faqPathModel.childItems count];
    }
    else {
        return 1;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 1) {
        TTLFaqModel *faqChild = [self.faqPathModel.childItems objectAtIndex:indexPath.row - 2];
        id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
        if ([tapTalkLiveDelegate respondsToSelector:@selector(faqChildDidTapped:currentShownNavigationController:)]) {
                [tapTalkLiveDelegate faqChildDidTapped:faqChild currentShownNavigationController:self.navigationController];
            }
        else {
            TTLFaqViewController *faqViewController = [[TTLFaqViewController alloc] initWithNibName:@"TTLFaqViewController" bundle:[TTLUtil currentBundle]];
            faqViewController.faqPathModel = faqChild;
            [self.navigationController pushViewController:faqViewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - TTLHomeHeaderTableViewCellDelegate

- (void)homeHeaderCellSeeAllMessagesButtonTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(seeAllMessagesButtonDidTappedWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate seeAllMessagesButtonDidTappedWithCurrentShownNavigationController:self.navigationController];
    }
    else {
        [self openCaseList];
    }
}

- (void)homeHeaderOpenNewMessageForm {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
        if ([tapTalkLiveDelegate respondsToSelector:@selector(createNewMessageButtonDidTappedWithCurrentShownNavigationController:)]) {
            [tapTalkLiveDelegate createNewMessageButtonDidTappedWithCurrentShownNavigationController:self.navigationController];
        }
        else {
            [self openNewMessageForm];
        }
}

- (void)homeHeaderCellCloseButtonTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInHomePageViewWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate didTappedCloseButtonInHomePageViewWithCurrentShownNavigationController:self.navigationController];
    }
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)homeHeaderCaseListTapped:(TAPMessageModel *)lastMessage cell:(id)cell {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(caseListItemDidTappedWithCurrentShownNavigationController:lastMessage:)]) {
            [tapTalkLiveDelegate caseListItemDidTappedWithCurrentShownNavigationController:self.navigationController lastMessage:lastMessage];
        }
    else {
        [[TapUI sharedInstance] createRoomWithRoom:lastMessage.room success:^(TapUIChatViewController * _Nonnull chatViewController) {
            if (cell != nil && [cell isKindOfClass:[TTLHomeHeaderTableViewCell class]]) {
                chatViewController.delegate = cell;
            }
            chatViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatViewController animated:YES];
        }];
    }
}

#pragma mark - FaqParentTableViewCellDelegate

- (void)faqParentBackButtonDidTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInHomePageViewWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate didTappedCloseButtonInHomePageViewWithCurrentShownNavigationController:self.navigationController];
    }
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark - FaqChildTableViewCellDelegate

- (void)faqChildUrlDidTapped:(NSURL *)url {
    [self faqParentUrlDidTapped:url];
}

- (void)faqChildUrlDidLongPressed:(NSURL *)url {
    [self faqParentUrlDidLongPressed:url];
}

#pragma mark - TAPChatManagerDelegate

- (void)chatManagerDidReceiveNewMessageOnOtherRoom:(TAPMessageModel *)message {
    [self updateLatestCaseCellView:message];
    [self checkCaseClosedMessage:message];
}

- (void)chatManagerDidReceiveUpdateMessageOnOtherRoom:(TAPMessageModel *)message {
    [self updateLatestCaseCellView:message];
}

- (void)chatManagerDidReceiveNewMessageInActiveRoom:(TAPMessageModel *)message {
    [self updateLatestCaseCellView:message];
    [self checkCaseClosedMessage:message];
}

- (void)chatManagerDidReceiveUpdateMessageInActiveRoom:(TAPMessageModel *)message {
    [self updateLatestCaseCellView:message];
}

- (void)chatManagerDidSendNewMessage:(TAPMessageModel *)message {
    [self updateLatestCaseCellView:message];
}

#pragma mark - Custom Methods

- (void)updateLatestCaseCellView:(TAPMessageModel *)message {
    if (message == nil || message.isHidden) {
        return;
    }
    TTLHomeHeaderTableViewCell *cell = (TTLHomeHeaderTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell updateLatestCaseCellView:message];
}

- (void)openCaseList {
    [[TapTalkLive sharedInstance] presentCaseListViewWithCurrentNavigationController:self.navigationController animated:YES];
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
        TTLCreateCaseViewController *createCaseViewController = [[TTLCreateCaseViewController alloc] init];
        createCaseViewController.previousNavigationController = self.navigationController;
        [createCaseViewController setCreateCaseViewControllerType:TTLCreateCaseViewControllerTypeDefault];
        createCaseViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        createCaseViewController.closeRoomListWhenCreateCaseIsClosed = NO;
        UINavigationController *createCaseNavigationController = [[UINavigationController alloc] initWithRootViewController:createCaseViewController];
        createCaseNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [createCaseNavigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController presentViewController:createCaseNavigationController animated:YES completion:nil];
    }
    */
    
}

- (BOOL)isContainCaseList {
    BOOL isContainCaseList = [[NSUserDefaults standardUserDefaults] secureBoolForKey:TTL_PREFS_IS_CONTAIN_CASE_LIST valid:nil];
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    currentAccessToken = [TTLUtil nullToEmptyString:currentAccessToken];
    
   // if ([currentAccessToken isEqualToString:@""] || (![currentAccessToken isEqualToString:@""] && !isContainCaseList)) {
     //   _closeRoomListWhenCreateCaseIsClosed = YES;
    //    [self performSelector:@selector(showCreateCaseFormView) withObject:nil afterDelay:0.05f];
 //   }
    return isContainCaseList;
}

- (void)scfPathUpdated:(NSNotification *)notification {
    [self.tableView reloadData];
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
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    });
}

- (void)checkCaseClosedMessage:(TAPMessageModel *)message {
    if (message.type == MESSAGE_TYPE_CLOSE_CASE || message.type == MESSAGE_TYPE_REOPEN_CASE || message.type == MESSAGE_TYPE_CASE_CREATED) {
        // Refresh case list count
        [TTLDataManager callAPIGetCaseListSuccess:^(NSArray<TTLCaseModel *> * _Nonnull caseListArray) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

@end
