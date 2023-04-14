//
//  TTLFaqModel.h
//  TapTalkLive
//
//  Created by Fikri on 3/8/23.
//

#import "TTLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLFaqModel : TTLBaseModel
@property (nonatomic, strong) NSNumber *itemID;
@property (nonatomic, strong) NSNumber *pathID;
@property (nonatomic, strong) NSNumber *parentID;
@property (nonatomic, strong) NSNumber *sequence;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray<NSDictionary *> *childItems;

@end

NS_ASSUME_NONNULL_END
