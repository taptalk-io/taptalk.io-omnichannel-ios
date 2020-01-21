//
//  TTLTopicListView.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLTopicListView.h"
#import <TapTalk/TAPStyleManager.h>

@interface TTLTopicListView ()

@end

@implementation TTLTopicListView
#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorDefaultBackground];
        
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.tableView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorDefaultBackground];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setSectionIndexColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorTableViewSectionIndex]];
        [self addSubview:self.tableView];
    }
    
    return self;
}

#pragma mark - Custom Method

@end
