//
//  TTLCaseListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLTopicListViewController.h"
#import "TTLTopicListView.h"
#import "TTLTopicOptionTableViewCell.h"

@interface TTLTopicListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) TTLTopicListView *topicListView;

@end

@implementation TTLTopicListViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    _topicListView = [[TTLTopicListView alloc] initWithFrame:[TTLBaseView frameWithNavigationBar]];
    [self.view addSubview:self.topicListView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showCustomCloseButton];
    self.title = NSLocalizedStringFromTableInBundle(@"Select Topic", nil, [TTLUtil currentBundle], @"");
    
    if (@available(iOS 15.0, *)) {
        [self.topicListView.tableView setSectionHeaderTopPadding:0.0f];
    }

    self.topicListView.tableView.delegate = self;
    self.topicListView.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Delegates
#pragma mark UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TTLTopicModel *currentTopic = [self.topicListArray objectAtIndex:indexPath.row];
    _selectedTopic = currentTopic;
    
    if ([self.delegate respondsToSelector:@selector(topicListViewControllerDidSelectTopicWithData:)]) {
        [self.delegate topicListViewControllerDidSelectTopicWithData:self.selectedTopic];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data Sources
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topicListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TTLTopicOptionTableViewCell";
    TTLTopicOptionTableViewCell *cell = [[TTLTopicOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    //DV Temp
    TTLTopicModel *currentTopic = [self.topicListArray objectAtIndex:indexPath.row];
    NSString *currentTopicName = currentTopic.topicName;
    NSString *currentTopicID = currentTopic.topicID;
    [cell setTopicOptionWithName:currentTopicName];
    
    if ([self.selectedTopic.topicID isEqualToString:currentTopicID]) {
        [cell showAsSelected:YES];
    }
    else {
        [cell showAsSelected:NO];
    }
    
    if (indexPath.row == [self.topicListArray count] - 1) {
        [cell showAsLastOption:YES];
    }
    else {
        [cell showAsLastOption:NO];
    }
    
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

#pragma mark - Custom Method

@end
