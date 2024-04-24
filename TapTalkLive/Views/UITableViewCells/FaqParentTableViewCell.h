//
//  FaqParentTableViewCell.h
//  TapTalkLive
//
//  Created by Fikri on 3/8/23.
//

#import "TTLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FaqParentTableViewCellDelegate <NSObject>

@optional

- (void)faqParentBackButtonDidTapped;
- (void)faqParentTalkToAgentButtonDidTapped;
- (void)faqParentUrlDidTapped:(NSURL *)url;
- (void)faqParentUrlDidLongPressed:(NSURL *)url;
- (void)faqParentEmailDidTapped:(NSURL *)email;
- (void)faqParentEmailDidLongPressed:(NSURL *)email;
- (void)faqParentPhoneDidTapped:(NSString *)phone;
- (void)faqParentPhoneDidLongPressed:(NSString *)phone;

@end

@interface FaqParentTableViewCell : TTLBaseTableViewCell

@property (weak, nonatomic) id<FaqParentTableViewCellDelegate> delegate;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)hideHeaderView;
- (void)setFaqParentData:(TTLFaqModel *)faqModel;
- (void)hideFaqLabel;
- (void)setTopRadius;
- (void)setAllRoundRadius;

@end

NS_ASSUME_NONNULL_END
