//
//  TTLBaseTableViewCell.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseTableViewCell.h"

@implementation TTLBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UITableView * _Nullable)getTableView {
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    if (view != nil && [view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        return tableView;
    }
    return nil;
}

- (void)refreshCellHeight {
    UITableView *tableView = [self getTableView];
    if (tableView != nil) {
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

@end
