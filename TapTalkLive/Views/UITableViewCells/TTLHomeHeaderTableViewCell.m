//
//  HomeHeaderTableViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/1/23.
//

#import "TTLHomeHeaderTableViewCell.h"
#import "TTLChannelCollectionViewCell.h"
#import <TapTalk/TAPRoomListTableViewCell.h>
#import <TapTalk/TAPChatManager.h>
#import <TapTalk/TAPDataManager.h>
#import <TapTalk/TapUtil.h>
#import <TapTalk/TAPMessageStatusManager.h>
#import <TapTalk/TapUIChatViewController.h>

@interface TTLHomeHeaderTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *closeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *needHelpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectChannelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickOneChannelTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIView *messageDirectlyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *messageDirectlyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageDirectlyImageView;

@property (weak, nonatomic) IBOutlet UIView *messageUserImageProfileContainerView;
@property (weak, nonatomic) IBOutlet UILabel *messageTopicLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *MessageUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *yourMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeAllMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeNewMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *homeNewMessageContainerView;
@property (weak, nonatomic) IBOutlet UIView *messageHistoryContainerView;
@property (weak, nonatomic) IBOutlet UIView *channelContainerView;
@property (weak, nonatomic) IBOutlet UIView *sendMessageDirectlyContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *channelCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *recentCaseListTableView;
@property (weak, nonatomic) IBOutlet UIImageView *messageUsButtonImageView;
@property (weak, nonatomic) IBOutlet UIView *orView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHistoryViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendMessageDirectlyViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelListCollectionTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHistoryContainerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orViewHeightConstraint;

@property (nonatomic) CGFloat cellSize;
@property (strong, nonatomic) NSMutableArray *filteredChannelList;
@property (strong, nonatomic) TAPMessageModel *latestMessage;
@property (nonatomic) BOOL isShouldNotLoadFromAPI;
@property (nonatomic) BOOL isViewAppear;

@end

@implementation TTLHomeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray *channelListDictionary = [[NSUserDefaults standardUserDefaults] secureObjectForKey:TTL_PREFS_CHANNEL_LIST valid:nil];
    _filteredChannelList = [NSMutableArray array];
    
    NSArray *channelList = [TTLDataManager dictionaryToChannelModelList:channelListDictionary];
    
    for(TTLChannelModel *channel in channelList) {
        if(channel.isEnabled) {
            [self.filteredChannelList addObject:channel];
        }
    }
    
    _cellSize = CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 16.0f - 40.0f;
    self.cellSize = self.cellSize / 5;
    self.cellSize = self.cellSize - 10;
    
    self.channelCollectionView.dataSource = self;
    self.channelCollectionView.delegate = self;
    self.recentCaseListTableView.dataSource = self;
    self.recentCaseListTableView.delegate = self;
    
    NSInteger channelrow = self.filteredChannelList.count / 5;
    
    if (self.filteredChannelList.count % 5 > 0) {
        channelrow += 1;
    }
    
    self.collectionViewHeightConstraint.constant = (channelrow * self.cellSize) + (channelrow * 10);
    
    self.headerBackgroundView.backgroundColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
    
    self.needHelpTitleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeTitleLabel];
    self.needHelpTitleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeTitleLabel];
    self.selectChannelTitleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeDescriptionLabel];
    self.selectChannelTitleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeDescriptionLabel];
    self.clickOneChannelTitleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeInfoLabel];
    self.clickOneChannelTitleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeInfoLabel];
    self.orLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeInfoLabel];
    self.orLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeInfoLabel];
    
    self.messageDirectlyContainerView.layer.cornerRadius = 8.0f;
    self.messageDirectlyContainerView.layer.borderWidth = 1.0f;
    self.messageDirectlyContainerView.layer.borderColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary].CGColor;
    
    TTLImage *messageDirectlyImage = self.messageDirectlyImageView.image;
    self.messageDirectlyImageView.image = [messageDirectlyImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary]];
    
    self.yourMessageLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeInfoLabel];
    self.yourMessageLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeInfoLabel];
    
    self.seeAllMessageLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeButtonLabel];
    self.seeAllMessageLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeButtonLabel];
    
    self.messageDirectlyLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorBorderedButtonLabel];
    self.messageDirectlyLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontBorderedButtonLabel];
    
    self.homeNewMessageContainerView.layer.cornerRadius = 8.0f;
    self.homeNewMessageContainerView.layer.borderWidth = 1.0f;
    self.homeNewMessageContainerView.layer.borderColor  = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary].CGColor;
    
    self.homeNewMessageLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorBorderedButtonLabel];
    self.homeNewMessageLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontBorderedButtonLabel];
    
    TTLImage *closeIconImage = self.closeIconImageView.image;
    self.closeIconImageView.image = [closeIconImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
    
    TTLImage *messageUsButtonImage = self.messageUsButtonImageView.image;
    self.messageUsButtonImageView.image = [messageUsButtonImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary]];
    
    //[self.channelCollectionView registerNib:[UINib nibWithNibName:@"TTLChannelCollectionViewCell" bundle:[TTLUtil currentBundle]]   forCellWithReuseIdentifier: @"TTLChannelCollectionViewCell"];
    
    // [self hideSendDirectly];
    // [self hideChannelList];
    // [self hideChannelContainer];
    
    [self addShadow];
    [self viewLoadedSequence];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageHistoryViewHeightConstraint.constant = 206.0f;
    self.messageHistoryContainerView.alpha = 1.0f;
    
    self.channelContainerView.alpha = 1.0f;
    self.messageHistoryContainerTopConstraint.constant = 16.0f;
    
    self.channelListCollectionTopConstraint.constant = 41.33f;
    _cellSize = CGRectGetWidth([UIScreen mainScreen].bounds) - 16.0f - 16.0f - 40.0f;
    self.cellSize = self.cellSize / 5;
    self.cellSize = self.cellSize - 10;
    
    self.collectionViewHeightConstraint.constant = (3 * self.cellSize) + (3 * 10);
    
    self.sendMessageDirectlyContainerView.alpha = 1.0f;
    self.sendMessageDirectlyViewHeightConstraint.constant = 123.67f;
    [self addShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)addShadow {
    [TTLUtil performBlock:^{
        self.channelContainerView.layer.cornerRadius = 8.0f;
        
        self.channelContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.channelContainerView.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.channelContainerView.layer.shadowRadius = 2.0f;
        self.channelContainerView.layer.shadowOpacity = 0.1f;
        self.channelContainerView.layer.masksToBounds = NO;
        self.channelContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.channelContainerView.bounds cornerRadius:self.channelContainerView.layer.cornerRadius].CGPath;
        
        self.messageHistoryContainerView.layer.cornerRadius = 8.0f;
        
        self.messageHistoryContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.messageHistoryContainerView.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.messageHistoryContainerView.layer.shadowRadius = 2.0f;
        self.messageHistoryContainerView.layer.shadowOpacity = 0.1f;
        self.messageHistoryContainerView.layer.masksToBounds = NO;
        self.messageHistoryContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.messageHistoryContainerView.bounds cornerRadius:self.messageHistoryContainerView.layer.cornerRadius].CGPath;
    } afterDelay:0.1f];
}

- (IBAction)seeAllMessagesButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeaderCellSeeAllMessagesButtonTapped)]) {
        [self.delegate homeHeaderCellSeeAllMessagesButtonTapped];
    }
}

- (IBAction)messageUsButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeaderOpenNewMessageForm)]) {
        [self.delegate homeHeaderOpenNewMessageForm];
    }
}

- (IBAction)newMessageButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeaderOpenNewMessageForm)]) {
        [self.delegate homeHeaderOpenNewMessageForm];
    }
}

- (void)hideMessageHistoryView {
    self.messageHistoryViewHeightConstraint.constant = 0.0f;
    self.messageHistoryContainerView.alpha = 0.0f;
}

- (void)hideChannelContainer {
    self.channelContainerView.alpha = 0.0f;
    self.messageHistoryContainerTopConstraint.constant = 0.0f;
}

- (void)hideChannelList {
    self.channelListCollectionTopConstraint.constant = 0.0f;
    self.collectionViewHeightConstraint.constant = 0.0f;
    self.clickOneChannelTitleLabel.alpha = 0.0f;
    self.orView.alpha = 0.0f;
    self.orViewHeightConstraint.constant = 15.0f;
    self.sendMessageDirectlyViewHeightConstraint.constant = 72.0f;
}

- (void)hideSendDirectly {
    self.sendMessageDirectlyContainerView.alpha = 0.0f;
    self.sendMessageDirectlyViewHeightConstraint.constant = 0.0f;
}

- (IBAction)closeButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeaderCellCloseButtonTapped)]) {
        [self.delegate homeHeaderCellCloseButtonTapped];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TTLChannelCollectionViewCell";
    UINib *cellNib = [UINib nibWithNibName:@"TTLChannelCollectionViewCell" bundle:[TTLUtil currentBundle]];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TTLChannelCollectionViewCell"];
    TTLChannelCollectionViewCell *headerTabCell = (TTLChannelCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TTLChannelModel *channel = [self.filteredChannelList objectAtIndex:indexPath.row];
    NSString *channelName = channel.channel;
    UIImage *channelImage;
    
    if ([channelName isEqualToString:CHANNEL_WHATSAPP]) {
        channelImage = [UIImage imageNamed:@"IconWhatsAppSME" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_WHATSAPP_BA]) {
        channelImage = [UIImage imageNamed:@"IconWhatsAppBA" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_INSTAGRAM]) {
        channelImage = [UIImage imageNamed:@"IconInstagram" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_TELEGRAM]) {
        channelImage = [UIImage imageNamed:@"IconTelegram" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_LINE]) {
        channelImage = [UIImage imageNamed:@"IconLine" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_TWITTER]) {
        channelImage = [UIImage imageNamed:@"IconTwitter" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_FACEBOOK]) {
        channelImage = [UIImage imageNamed:@"IconFacebookMessenger" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else if ([channelName isEqualToString:CHANNEL_GOOGLE_BUSINESS]) {
        channelImage = [UIImage imageNamed:@"IconGoogle" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else {
        channelImage = [UIImage imageNamed:@"IconTapTalkIo" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    
    [headerTabCell setChannelImage:channelImage];
    
    return headerTabCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredChannelList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellSize, self.cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTLChannelModel *channel = [self.filteredChannelList objectAtIndex:indexPath.row];
    NSString *channelLink = channel.url;
    NSURL *channelLinkUrl = [NSURL URLWithString:channelLink];
    
    if ([[UIApplication sharedApplication] canOpenURL: channelLinkUrl]) {
        [[UIApplication sharedApplication] openURL: channelLinkUrl];
        //[[UIApplication sharedApplication] openURL:channelLinkUrl options:nil completionHandler:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 74.0f;
    }
    return 0.0f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellID = @"TAPRoomListTableViewCell";
        
        TAPRoomListTableViewCell *cell = [[TAPRoomListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
       
        TAPRoomModel *room = self.latestMessage.room;
        NSString *roomID = room.roomID;
        roomID = [TAPUtil nullToEmptyString:roomID];
        
        TAPRoomListModel *roomList = [TAPRoomListModel new];
        roomList.lastMessage = self.latestMessage;
        
        cell.tableView = tableView;
        [cell setRoomListTableViewCellWithData:roomList updateUnreadBubble:NO];
        
        //        if (indexPath.row == [self.caseListArray count] - 1) {
        //            [cell setIsLastCellSeparator:YES];
        //        }
        //        else {
        [cell setIsLastCellSeparator:NO];
        //        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.latestMessage != nil){
        return 1;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(homeHeaderCaseListTapped:)]) {
        [self.delegate homeHeaderCaseListTapped:self.latestMessage];
    }
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

- (void)reloadLocalDataAndUpdateUILogicAnimated:(BOOL)animated {
    [TAPDataManager getRoomListSuccess:^(NSArray *resultArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TAP_PREFS_IS_DONE_FIRST_SETUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(resultArray.count > 0) {
                self.latestMessage = [resultArray objectAtIndex:0];
                [self.recentCaseListTableView reloadData];
            }
            //[self refreshViewAndQueryUnreadLogicWithMessageArray:resultArray animateReloadData:animated];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)runFullRefreshSequence {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //Save pending messages, new messages, waiting response messages, and waiting upload file messages to database
        [[TAPChatManager sharedManager] saveAllUnsentMessageInMainThread];
        
        [TAPDataManager getRoomListSuccess:^(NSArray *resultArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isShouldAnimate = YES;
                if(resultArray.count > 0) {
                    self.latestMessage = [resultArray objectAtIndex:0];
                    [self.recentCaseListTableView reloadData];
                }
                
               // [self refreshViewAndQueryUnreadLogicWithMessageArray:resultArray animateReloadData:NO];
                
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
           // for (TTLCaseModel *caseModel in caseListArray) {
             //   [messageArray addObject:caseModel.tapTalkRoom.lastMessage];
            //}
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

- (void)updateLatestCaseCellView:(TAPMessageModel *)message {
    self.latestMessage = message;
    [self.recentCaseListTableView reloadData];
}

@end
