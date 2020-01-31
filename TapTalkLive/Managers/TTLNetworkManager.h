//
//  TTLNetworkManager.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

#define NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY @"Prefs.NetworkManagerNoConnectionNotificationKey"

@interface TTLNetworkManager : NSObject

+ (TTLNetworkManager *)sharedManager;

- (void)get:(NSString *)urlString
 parameters:(NSMutableDictionary *)parameters
   progress:(void (^)(NSProgress *downloadProgress))progress
    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)post:(NSString *)urlString
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)put:(NSString *)urlString
 parameters:(NSMutableDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)delete:(NSString *)urlString
parameters:(NSMutableDictionary *)parameters
success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

//TapTalkLive
- (void)post:(NSString *)urlString
  authTicket:(NSString *)authTicket
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (void)post:(NSString *)urlString
refreshToken:(NSString *)refreshToken
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSString *)urlEncodedStringFromDictionary:(NSDictionary *)parameterDictionary;
- (void)setSecretKey:(NSString *)secretKey;
- (NSString *)getSecretKey;

@end


NS_ASSUME_NONNULL_END
