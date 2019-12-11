//
//  TAPContactRealmModel.m
//  TapTalk
//
//  Created by Dominic Vedericho on 19/10/18.
//  Copyright © 2018 Moselo. All rights reserved.
//

#import "TAPContactRealmModel.h"

@implementation TAPContactRealmModel

+ (NSString *)primaryKey {
    NSString *primaryKey = @"userID";
    return primaryKey;
}

+ (NSArray<NSString *> *)indexedProperties {
    NSArray *indexedPropertiesArray = [NSArray arrayWithObjects:@"userRoleCode", nil];
    return indexedPropertiesArray;
}

@end
