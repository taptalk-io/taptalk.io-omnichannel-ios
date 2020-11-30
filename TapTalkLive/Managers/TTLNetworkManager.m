//
//  TTLNetworkManager.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLNetworkManager.h"

static const NSInteger kAPITimeOut = 60;

@interface TTLNetworkManager ()

@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSMutableDictionary *currentDownloadTaskDictionary;

- (AFHTTPSessionManager *)defaultManager;
- (NSString *)urlEncodeForString:(NSString *)stringToEncode;

@end

@implementation TTLNetworkManager

#pragma mark - Lifecycle
+ (TTLNetworkManager *)sharedManager {
    static TTLNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSDictionary *statusDictionary = @{@"AFNetworkReachabilityNotificationStatusItem" : [NSNumber numberWithInteger:status]};
            [[NSNotificationCenter defaultCenter] postNotificationName:TTL_NOTIFICATION_REACHABILITY_STATUS_CHANGED object:statusDictionary userInfo:statusDictionary];
            
            switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"Connected via mobile network");
                    break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"Connected via Wifi");
                    break;
                    case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"Disconnected");
                    break;
                default:
                    break;
            }
        }];
        _currentDownloadTaskDictionary = [[NSMutableDictionary alloc] init];
        _secretKey = [NSString string];
    }
    
    return self;
}

#pragma mark - Custom Method
- (AFHTTPSessionManager *)defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Secret-Key"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forHTTPHeaderField:@"Device-Identifier"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"Device-Model"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Device-Platform"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"Device-OS-Version"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"SDK-Version"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    
    [manager.requestSerializer setTimeoutInterval:kAPITimeOut];
    
    if ([TTLDataManager getAccessToken] != nil && ![[TTLDataManager getAccessToken] isEqualToString:@""]) {
        NSString *authorizationValueString = [NSString stringWithFormat:@"Bearer %@", [TTLDataManager getAccessToken]];
        [manager.requestSerializer setValue:authorizationValueString forHTTPHeaderField:@"Authorization"];
    }
    
#ifdef DEBUG
    NSLog(@"Secret Key: %@", self.secretKey);
    NSLog(@"Device Identifier: %@", [[UIDevice currentDevice] identifierForVendor].UUIDString);
    NSLog(@"Device Model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"Device-OS-Version: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"App-Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
#endif
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    return manager;
}

- (void)get:(NSString *)urlString
 parameters:(NSDictionary *)parameters
   progress:(void (^)(NSProgress *))progress
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    [[self defaultManager] GET:urlString
                    parameters:parameters headers: nil
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                          progress(downloadProgress);
                      }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)post:(NSString *)urlString
  parameters:(NSDictionary *)parameters
    progress:(void (^)(NSProgress *))progress
     success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    [[self defaultManager] POST:urlString
                     parameters:parameters headers: nil
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           progress(uploadProgress);
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            success(task, (NSDictionary *)responseObject);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            failure(task, error);
                        }];
}

- (void)put:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] PUT:urlString
                    parameters:parameters headers: nil
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)delete:(NSString *)urlString
    parameters:(NSDictionary *)parameters
       success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] DELETE:urlString
                       parameters:parameters headers: nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              success(task, (NSDictionary *)responseObject);
    }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              failure(task, error);
    }];
}

- (NSString *)urlEncodedStringFromDictionary:(NSDictionary *)parameterDictionary {
    NSMutableString *parameterString = [NSMutableString stringWithString:@""];
    
    NSArray *parameterKeyArray = [parameterDictionary allKeys];
    
    for (NSInteger count = 0; count < [parameterKeyArray count]; count++) {
        NSString *parameterKey = [parameterKeyArray objectAtIndex:count];
        
        if (count > 0) {
            [parameterString appendString:@"&"];
        }
        
        NSString *parameterValue = [parameterDictionary objectForKey:parameterKey];
        NSString *encodedParameterValue = [self urlEncodeForString:parameterValue];
        
        [parameterString appendFormat:@"%@=%@", parameterKey, encodedParameterValue];
    }
    
    return parameterString;
}

- (NSString *)urlEncodeForString:(NSString *)stringToEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[stringToEncode UTF8String];
    
    NSInteger sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - TapTalkLive
- (void)post:(NSString *)urlString
  authTicket:(NSString *)authTicket
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    AFHTTPSessionManager *manager = [[TTLNetworkManager sharedManager] defaultManager];
    NSString *authorizationValueString = [NSString stringWithFormat:@"Bearer %@", authTicket];
    [manager.requestSerializer setValue:authorizationValueString forHTTPHeaderField:@"Authorization"];
    
    [manager POST:urlString
                     parameters:parameters headers: nil
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           progress(uploadProgress);
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            success(task, (NSDictionary *)responseObject);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            failure(task, error);
                        }];
}

- (void)post:(NSString *)urlString
refreshToken:(NSString *)refreshToken
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure {
    if (urlString == nil) {
        urlString = @"";
    }
    
    if (parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    AFHTTPSessionManager *manager = [[TTLNetworkManager sharedManager] defaultManager];
    NSString *authorizationValueString = [NSString stringWithFormat:@"Bearer %@", refreshToken];
    [manager.requestSerializer setValue:authorizationValueString forHTTPHeaderField:@"Authorization"];
    
    [manager POST:urlString
       parameters:parameters headers: nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             progress(uploadProgress);
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(task, (NSDictionary *)responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(task, error);
          }];
}


- (void)setSecretKey:(NSString *)secretKey {
    _secretKey = secretKey;
}

- (NSString *)getSecretKey {
    return self.secretKey;
}

@end
