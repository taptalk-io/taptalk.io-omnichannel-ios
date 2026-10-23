//
//  TTLChannelModel.h
//  TapTalkLive
//
//  Created by Fikri on 3/2/23.
//

#import "TTLBaseModel.h"

@interface TTLChannelModel : TTLBaseModel

@property (nonatomic, strong) NSNumber *channelID;
@property (nonatomic, strong) NSNumber *sequence;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) BOOL sendPageURL;
@property (nonatomic) BOOL isEnabled;

@end


