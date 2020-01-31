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
    TTLCreateCaseViewControllerTypeWithCloseButton = 1
};

@interface TTLCreateCaseViewController : TTLBaseViewController

@property (strong, nonatomic) UINavigationController *previousNavigationController;
@property (nonatomic) TTLCreateCaseViewControllerType createCaseViewControllerType;
- (void)setCreateCaseViewControllerType:(TTLCreateCaseViewControllerType)createCaseViewControllerType;

@end

NS_ASSUME_NONNULL_END
