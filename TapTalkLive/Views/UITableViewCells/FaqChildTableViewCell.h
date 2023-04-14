//
//  FaqChildTableViewCell.h
//  TapTalkLive
//
//  Created by Fikri on 3/9/23.
//

#import "TTLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaqChildTableViewCell : TTLBaseTableViewCell
- (void)setFaqChildWithData:(TTLFaqModel *)faqSequenceModel;
- (void)setLastChildCellView;
@end

NS_ASSUME_NONNULL_END
