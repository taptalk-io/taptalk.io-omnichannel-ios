//
//  TTLTopicModel.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 20/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLTopicModel : TTLBaseModel

@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSNumber *createdTime;
@property (nonatomic, strong) NSNumber *updatedTime;
@property (nonatomic, strong) NSNumber *deletedTime;

@end

NS_ASSUME_NONNULL_END
