//
//  TTLBaseModel.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

@import JSONModel;

NS_ASSUME_NONNULL_BEGIN

@interface TTLBaseModel : JSONModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName;

@end

NS_ASSUME_NONNULL_END
