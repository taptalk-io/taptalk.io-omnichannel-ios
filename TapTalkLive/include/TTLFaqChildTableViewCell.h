//
//  FaqChildTableViewCell.h
//  TapTalkLive
//
//  Created by Fikri on 3/9/23.
//

#import "TTLBaseTableViewCell.h"
#import "TTLFaqModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FaqChildTableViewCellDelegate <NSObject>

@optional

- (void)faqChild:(TTLFaqModel *)faqModel urlDidTapped:(NSURL *)url;
- (void)faqChild:(TTLFaqModel *)faqModel urlDidLongPressed:(NSURL *)url;
- (void)faqChild:(TTLFaqModel *)faqModel emailDidTapped:(NSURL *)email;
- (void)faqChild:(TTLFaqModel *)faqModel emailDidLongPressed:(NSURL *)email;
- (void)faqChild:(TTLFaqModel *)faqModel phoneDidTapped:(NSString *)phone;
- (void)faqChild:(TTLFaqModel *)faqModel phoneDidLongPressed:(NSString *)phone;

@end

@interface TTLFaqChildTableViewCell : TTLBaseTableViewCell

@property (weak, nonatomic) id<FaqChildTableViewCellDelegate> delegate;
@property (strong, nonatomic) TTLFaqModel *faqChildModel;

- (void)setFaqChildWithData:(TTLFaqModel *)faqSequenceModel;
- (void)setLastChildCellView;

@end

NS_ASSUME_NONNULL_END
