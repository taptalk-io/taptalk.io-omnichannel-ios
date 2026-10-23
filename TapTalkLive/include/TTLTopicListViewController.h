//
//  TapTalkLive
//
//  Created by Dominic Vedericho on 17/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseViewController.h"
#import "TTLTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTLTopicListViewControllerDelegate <NSObject>

- (void)topicListViewControllerDidSelectTopicWithData:(TTLTopicModel *)selectedTopic;

@end

@interface TTLTopicListViewController : TTLBaseViewController

@property (weak, nonatomic) id<TTLTopicListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *topicListArray;
@property (strong, nonatomic) TTLTopicModel *selectedTopic;

@end

NS_ASSUME_NONNULL_END
