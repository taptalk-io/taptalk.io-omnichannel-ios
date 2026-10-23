//
//  TTLUtil.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
#import "TTLFaqModel.h"
#import "TTLBaseViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#pragma mark - Math
#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0f)
#define RADIANS_TO_DEGREES(x) ((x) * 180.0f / M_PI)

#pragma mark - Device
#define IS_IPHONE_4_INCH_AND_ABOVE ([[UIScreen mainScreen] bounds].size.height >= 568)?YES:NO
#define IS_IPHONE_4_7_INCH_AND_ABOVE ([[UIScreen mainScreen] bounds].size.width >= 375)?YES:NO
#define IS_IPHONE_5_5_INCH_AND_ABOVE ([[UIScreen mainScreen] bounds].size.height >= 736)?YES:NO
#define IS_IPHONE_3_5_INCH ([[UIScreen mainScreen] bounds].size.height == 480)?YES:NO
#define IS_IPHONE_4_INCH ([[UIScreen mainScreen] bounds].size.height == 568)?YES:NO
#define IS_IPHONE_4_7_INCH ([[UIScreen mainScreen] bounds].size.height == 667)?YES:NO
#define IS_IPHONE_5_5_INCH ([[UIScreen mainScreen] bounds].size.height == 736)?YES:NO
//#define IS_IPHONE_X_FAMILY ([TTLUtil safeAreaBottomPadding] > 0)?YES:NO

#define IS_BELOW_IOS_11 ([[[[UIDevice currentDevice] systemVersion] substringWithRange:NSMakeRange(0, 2)] integerValue] < 11)?YES:NO
#define IS_BELOW_IOS_12 ([[[[UIDevice currentDevice] systemVersion] substringWithRange:NSMakeRange(0, 2)] integerValue] < 12)?YES:NO
#define IS_BELOW_IOS_13 ([[[[UIDevice currentDevice] systemVersion] substringWithRange:NSMakeRange(0, 2)] integerValue] < 13)?YES:NO
#define IS_IOS_11_OR_ABOVE (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
#define IS_IOS_12_OR_ABOVE (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0"))
#define IS_IOS_13_OR_ABOVE (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0"))

#define SYSTEM_VERSION ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_EQUAL_TO(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - App Version
#define APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define APP_VERSION_EQUAL_TO(version) ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedSame)
#define APP_VERSION_GREATER_THAN(version) ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedDescending)
#define APP_VERSION_GREATER_THAN_OR_EQUAL_TO(version) ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define APP_VERSION_LESS_THAN(version) ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define APP_VERSION_LESS_THAN_OR_EQUAL_TO(version) ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - String
#define STRING_FROM_BOOL(BOOL) ((BOOL) ? @"YES" : @"NO")

@interface TTLUtil : NSObject {
    
}

#pragma mark - Date
+ (BOOL)date:(NSDate *_Nonnull)date isBetweenDate:(NSDate *_Nonnull)beginDate andDate:(NSDate *_Nonnull)endDate;
+ (NSInteger)daysDifferentBetweenDate:(NSDate *_Nonnull)date1 fromDate:(NSDate *_Nonnull)date2;

#pragma mark - Time
+ (NSString *_Nonnull)stringFromTimeInterval:(NSTimeInterval)interval;

#pragma mark - Null Handler
+ (NSString *_Nonnull)nullToEmptyString:(id _Nullable)value;
+ (NSDictionary *_Nonnull)nullToEmptyDictionary:(id _Nullable)value;
+ (NSArray *_Nonnull)nullToEmptyArray:(id _Nullable)value;
+ (NSNumber *_Nonnull)nullToEmptyNumber:(id _Nullable)value;

#pragma mark - Color
+ (UIColor *_Nonnull)getColor:(NSString *_Nonnull)hexColor;
+ (UIColor *_Nonnull)randomPastelColor;

#pragma mark - Image Processing
+ (UIImage *_Nullable)makeRoundCornerImage:(UIImage *_Nonnull)img width:(int)cornerWidth height:(int)cornerHeight;
+ (UIImage *_Nullable)resizedImage:(UIImage *_Nonnull)inImage frame:(CGRect)thumbRect;
+ (UIImage *_Nullable)imageByScaling:(BOOL)isScaling cropping:(BOOL)isCropping sourceImage:(UIImage *_Nonnull)sourceImage frame:(CGRect)targetFrame;

#pragma mark - Encoding
+ (NSString *_Nonnull)urlEncodeFromString:(NSString *_Nonnull)sourceString;
+ (NSString *_Nonnull)sha1:(NSString *_Nonnull)input;
+ (NSString *_Nonnull)md5:(NSString *_Nonnull)input;

#pragma mark - String
+ (NSString *_Nonnull)generateRandomStringWithLength:(NSInteger)length;
+ (NSString *_Nullable)ordinalNumberWithInteger:(NSInteger)number;
+ (NSString *_Nonnull)formattedCurrencyWithCurrencySign:(NSString *_Nonnull)currencySign value:(CGFloat)value;
+ (NSString *_Nullable)hexadecimalStringFromData:(NSData *_Nonnull)data;

#pragma mark - Location
+ (CGFloat)getDistanceFromLong:(double)longitude lat:(double)latitude andLong2:(double)longitude2 lat2:(double)latitude2;

#pragma mark - JSON
+ (NSString *_Nonnull)jsonStringFromObject:(id _Nullable)json;
+ (id _Nullable)jsonObjectFromString:(NSString *_Nullable)string;
+ (void)fetchJsonFromUrl:(NSString *_Nonnull)jsonUrl
                 success:(void (^_Nonnull)(NSString *_Nullable jsonString))success
                 failure:(void (^_Nonnull)(NSError *_Nullable error))failure;
+ (void)fetchScfPathContentResponse:(TTLFaqModel *_Nonnull)scfPath
                 fetchChildContents:(BOOL)fetchChildContents
                            success:(void (^_Nonnull)(NSString *_Nullable apiUrl, NSString *_Nullable contentResponse))success;

#pragma mark - Rect
+ (CGFloat)lineMinimumHeight;
+ (CGFloat)screenAdjustedHeight:(CGFloat)currentHeight;
+ (CGFloat)screenAdjustedWidth:(CGFloat)currentWidth;
+ (CGRect)getStringConstrainedSizeWithString:(NSString *_Nonnull)string withFont:(UIFont *_Nonnull)font withConstrainedSize:(CGSize)size;

#pragma mark - View
+ (void)addSpinAnimation:(UIView *_Nonnull)view;
+ (void)removeSpinAnimation:(UIView *_Nonnull)view;
+ (UIViewController *_Nullable)topViewController;
+ (UIViewController *_Nullable)topViewControllerWithRootViewController:(UIViewController *_Nonnull)rootViewController;

#pragma mark - Device
+ (NSString *_Nonnull)hardwareModel;
+ (NSString *_Nonnull)hardwareString;

#pragma mark - Validation
+ (BOOL)isAlphabetCharactersOnlyFromText:(NSString *_Nonnull)text;
+ (BOOL)isEmptyString:(NSString *_Nullable)string;
+ (BOOL)isEmptyArray:(NSArray *_Nullable)array;
+ (BOOL)validatePhoneNumber:(NSString *_Nonnull)candidate;
+ (BOOL)validateAllNumber:(NSString *_Nonnull)candidate;
+ (BOOL)validateEmail:(NSString *_Nonnull)candidate;
+ (BOOL)validateUsername:(NSString *_Nonnull)candidate;
+ (BOOL)validatePassword:(NSString *_Nonnull)candidate;

#pragma mark - Taptic Feedback
+ (void)tapticImpactFeedbackGenerator;
+ (void)tapticSelectionFeedbackGenerator;
+ (void)tapticNotificationFeedbackGeneratorWithType:(UINotificationFeedbackType)type;

#pragma mark - Others
+ (void)logAllFontFamiliesAndName;
+ (void)log:(NSString *_Nullable)string;
+ (NSDictionary *_Nonnull)parameterFromURLString:(NSString *_Nullable)urlString;
+ (CGFloat)currentDeviceStatusBarHeight;
+ (CGFloat)currentDeviceNavigationBarHeightWithStatusBar:(BOOL)statusBar iPhoneXLargeLayout:(BOOL)iPhoneXLargeLayout;
+ (NSString *_Nullable)mimeTypeForFileAtPath:(NSString *_Nonnull)path;
+ (NSString *_Nullable)mimeTypeForData:(NSData *_Nonnull)data;
+ (NSString *_Nullable)getNewFileAndCheckExistingFilePath:(NSString *_Nonnull)path fileNameCounterStart:(NSInteger)counter;
+ (CGFloat)safeAreaBottomPadding;
+ (CGFloat)safeAreaTopPadding;
+ (CGFloat)topGapPresentingViewController;
+ (void)performBlock:(void (^_Nonnull)(void))block afterDelay:(NSTimeInterval)delay;
+ (void)openUrl:(NSURL *_Nullable)url fromNavigationController:(UINavigationController *_Nullable)navigationController;
+ (void)openUrl:(NSURL *_Nullable)url fromNavigationController:(UINavigationController *_Nullable)navigationController options:(NSDictionary *_Nullable)options;
+ (NSString *_Nonnull)getDefaultMessageFromError:(NSError *_Nullable)error;
+ (void)showErrorSnackBar:(NSError *_Nullable)error fromViewController:(TTLBaseViewController *_Nonnull)viewController;
+ (void)showErrorSnackBarWithMessage:(NSString *_Nonnull)errorMessage fromViewController:(TTLBaseViewController *_Nonnull)viewController;

#pragma mark - TapTalk
+ (NSBundle *_Nullable)currentBundle;

@end

