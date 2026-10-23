//
//  TTLFaqViewController.h
//  TapTalkLive
//
//  Created by Fikri on 3/13/23.
//

#import "TTLBaseViewController.h"
#import "TTLFaqModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTLFaqViewControllerDelegate <NSObject>

@optional

- (void)faqViewControllercreateCaseSucceed;

@end

@interface TTLFaqViewController : TTLBaseViewController
@property (nonatomic, strong) TTLFaqModel *faqPathModel;
@property (weak, nonatomic) id<TTLFaqViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
