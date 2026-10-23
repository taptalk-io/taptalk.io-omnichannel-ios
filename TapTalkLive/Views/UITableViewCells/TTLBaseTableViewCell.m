//
//  TTLBaseTableViewCell.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseTableViewCell.h"

@interface TTLBaseTableViewCell ()

@property (strong, nonatomic) UITableView *tableView;

@end

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
    if (self.tableView != nil) {
        return self.tableView;
    }
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    if (view != nil && [view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        _tableView = tableView;
        return tableView;
    }
    return nil;
}

- (void)refreshCellHeight {
    UITableView *tableView = [self getTableView];
    if (tableView != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView beginUpdates];
            [tableView endUpdates];
//            [tableView reloadData];
        });
    }
}

@end
