//
//  TTLCreateCaseViewController.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 09/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTLCreateCaseViewControllerType) {
    TTLCreateCaseViewControllerTypeDefault = 0,
    TTLCreateCaseViewControllerTypeAlreadyLogin = 1
};

@protocol TTLCreateCaseViewControllerDelegate <NSObject>
- (void)createCaseViewControllercreateCaseSucceed;
@optional
@end

@interface TTLCreateCaseViewController : TTLBaseViewController

@property (strong, nonatomic) UINavigationController *previousNavigationController;
@property (nonatomic) TTLCreateCaseViewControllerType createCaseViewControllerType;
@property (nonatomic) BOOL closeRoomListWhenCreateCaseIsClosed;
@property (weak, nonatomic) id<TTLCreateCaseViewControllerDelegate> delegate;


- (void)setCreateCaseViewControllerType:(TTLCreateCaseViewControllerType)createCaseViewControllerType;

@end

NS_ASSUME_NONNULL_END
