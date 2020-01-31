//
//  TTLUserModel.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 19/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLUserModel.h"

@implementation TTLUserModel

//used to save model to preference
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.fullName forKey:@"fullName"];
    [encoder encodeObject:self.source forKey:@"source"];
    [encoder encodeObject:self.customerUserID forKey:@"customerUserID"];
    [encoder encodeObject:self.whatsappUserID forKey:@"whatsappUserID"];
    [encoder encodeObject:self.telegramUserID forKey:@"telegramUserID"];
    [encoder encodeObject:self.lineUserID forKey:@"lineUserID"];
    [encoder encodeObject:self.twitterUserID forKey:@"twitterUserID"];
    [encoder encodeObject:self.facebookPSID forKey:@"facebookPSID"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeBool:self.isEmailVerified forKey:@"isEmailVerified"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeBool:self.isPhoneVerified forKey:@"isPhoneVerified"];
    [encoder encodeObject:self.photoURL forKey:@"photoURL"];
    [encoder encodeObject:self.mergedToUserID forKey:@"mergedToUserID"];
    [encoder encodeObject:self.mergedTime forKey:@"mergedTime"];
    [encoder encodeObject:self.createdTime forKey:@"createdTime"];
    [encoder encodeObject:self.updatedTime forKey:@"updatedTime"];
    [encoder encodeObject:self.deletedTime forKey:@"deletedTime"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.fullName = [decoder decodeObjectForKey:@"fullName"];
        self.source = [decoder decodeObjectForKey:@"source"];
        self.customerUserID = [decoder decodeObjectForKey:@"customerUserID"];
        self.whatsappUserID = [decoder decodeObjectForKey:@"whatsappUserID"];
        self.telegramUserID = [decoder decodeObjectForKey:@"telegramUserID"];
        self.lineUserID = [decoder decodeObjectForKey:@"lineUserID"];
        self.twitterUserID = [decoder decodeObjectForKey:@"twitterUserID"];
        self.facebookPSID = [decoder decodeObjectForKey:@"facebookPSID"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.isEmailVerified = [decoder decodeBoolForKey:@"isEmailVerified"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.isPhoneVerified = [decoder decodeBoolForKey:@"isPhoneVerified"];
        self.photoURL = [decoder decodeObjectForKey:@"photoURL"];
        self.mergedToUserID = [decoder decodeObjectForKey:@"mergedToUserID"];
        self.mergedTime = [decoder decodeObjectForKey:@"mergedTime"];
        self.createdTime = [decoder decodeObjectForKey:@"createdTime"];
        self.updatedTime = [decoder decodeObjectForKey:@"updatedTime"];
        self.deletedTime = [decoder decodeObjectForKey:@"deletedTime"];
    }
    return self;
}

@end
