//
//  TTLTopicOptionTableViewCell.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLTopicOptionTableViewCell : TTLBaseTableViewCell

- (void)setTopicOptionWithName:(NSString *)topicName;
- (void)showAsLastOption:(BOOL)lastOption;
- (void)showAsSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
