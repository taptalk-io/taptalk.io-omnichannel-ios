//
//  TTLReviewBubbleTableViewCell.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 23/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <TapTalk/TAPBaseGeneralBubbleTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTLReviewBubbleType) {
    TTLReviewBubbleTypeNotReviewed = 0,
    TTLReviewBubbleTypeDoneReviewed = 1,
};

@protocol TTLReviewBubbleTableViewCellDelegate <NSObject>

- (void)reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:(TAPMessageModel *)message;

@end

@interface TTLReviewBubbleTableViewCell : TAPBaseGeneralBubbleTableViewCell

@property (weak, nonatomic) id<TTLReviewBubbleTableViewCellDelegate> delegate;
@property (nonatomic) TTLReviewBubbleType reviewBubbleType;
@property (strong, nonatomic) TAPMessageModel *message;

- (void)setReviewBubbleType:(TTLReviewBubbleType)reviewBubbleType;

@end

NS_ASSUME_NONNULL_END
