//
//  TTLUserModel.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 19/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLUserModel : TTLBaseModel

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *customerUserID;
@property (nonatomic, strong) NSString *whatsappUserID;
@property (nonatomic, strong) NSString *telegramUserID;
@property (nonatomic, strong) NSString *lineUserID;
@property (nonatomic, strong) NSString *twitterUserID;
@property (nonatomic, strong) NSString *facebookPSID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic) BOOL isEmailVerified;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic) BOOL isPhoneVerified;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *mergedToUserID;
@property (nonatomic, strong) NSNumber *mergedTime;
@property (nonatomic, strong) NSNumber *createdTime;
@property (nonatomic, strong) NSNumber *updatedTime;
@property (nonatomic, strong) NSNumber *deletedTime;

@end

NS_ASSUME_NONNULL_END
