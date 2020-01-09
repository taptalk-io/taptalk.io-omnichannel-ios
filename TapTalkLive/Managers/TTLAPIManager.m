//
//  TTLAPIManager.m
//  TapTalk
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 TapTalk. All rights reserved.
//

#import "TTLAPIManager.h"

static NSString * const kAPIVersionString = @"v1";

@interface TTLAPIManager ()

@property (strong, nonatomic) NSString *APIBaseURL;

@end

@implementation TTLAPIManager

#pragma mark - Lifecycle
+ (TTLAPIManager *)sharedManager {
    static TTLAPIManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[TTLAPIManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _APIBaseURL = [NSString string];
    }
    
    return self;
}

#pragma mark - Custom Method
- (void)setBaseAPIURLString:(NSString *)urlString {
    _APIBaseURL = urlString;
}

- (NSString *)urlForType:(TTLAPIManagerType)type {
    if (type == TTLAPIManagerTypeGet) {
        NSString *apiPath = @"";
        return [NSString stringWithFormat:@"%@/%@/%@", self.APIBaseURL, kAPIVersionString, apiPath];
    }
    
    return [NSString stringWithFormat:@"%@", self.APIBaseURL];
}

@end
