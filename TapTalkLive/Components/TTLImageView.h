//
//  TTLImageView.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 03/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kMaxCacheAge = 60 * 60 * 24 * 7; // 1 Week in Seconds
static const NSInteger kMaxDiskCountLimit = 1048576000; // 1GB in B

@class TTLImageView;

@protocol TTLImageViewDelegate <NSObject>

@optional

- (void)imageViewDidFinishLoadImage:(TTLImageView *)imageView;

@end

@interface TTLImageView : UIImageView

@property (weak, nonatomic) id<TTLImageViewDelegate> delegate;

@property (strong, nonatomic) NSString *imageURLString;

+ (void)saveImageToCache:(UIImage *)image withKey:(NSString *)key;
+ (void)imageFromCacheWithKey:(NSString *)key success:(void (^)(UIImage *savedImage))success; //Run in background thread, async
+ (UIImage *)imageFromCacheWithKey:(NSString *)key; //Run in main thread
+ (void)removeImageFromCacheWithKey:(NSString *)key;

- (void)setImageWithURLString:(NSString *)urlString;
- (void)setAsTintedWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
