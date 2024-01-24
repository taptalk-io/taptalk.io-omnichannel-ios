//
//  TTLBaseTableViewCell.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLBaseTableViewCell : UITableViewCell

- (UITableView * _Nullable)getTableView;

- (void)refreshCellHeight;

@end

NS_ASSUME_NONNULL_END
