//
//  FaqParentTableViewCell.h
//  TapTalkLive
//
//  Created by Fikri on 3/8/23.
//

#import "TTLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FaqParentTableViewCellDelegate <NSObject>

- (void)faqParentBackButtonDidTapped;
- (void)faqParentTalkToAgentButtonDidTapped;

@end

@interface FaqParentTableViewCell : TTLBaseTableViewCell
@property (weak, nonatomic) id<FaqParentTableViewCellDelegate> delegate;
- (void)hideHeaderView;
- (void)setFaqParentData:(TTLFaqModel *)faqModel;
- (void)hideFaqLabel;
- (void)setTopRadius;
- (void)setAllRoundRadius;
@end

NS_ASSUME_NONNULL_END
