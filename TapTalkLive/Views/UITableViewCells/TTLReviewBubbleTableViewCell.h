//
//  TTLReviewBubbleTableViewCell.h
//  TapTalkLive
//
//  Created by Dominic Vedericho on 23/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import <TapTalk/TAPBaseGeneralBubbleTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTLReviewBubbleTableViewCellDelegate <NSObject>

- (void)reviewBubbleTableViewCellDidTappedReviewButtonWithMessage:(TAPMessageModel *)message;

@end

@interface TTLReviewBubbleTableViewCell : TAPBaseGeneralBubbleTableViewCell

@property (weak, nonatomic) id<TTLReviewBubbleTableViewCellDelegate> delegate;
@property (strong, nonatomic) TAPMessageModel *message;

@end

NS_ASSUME_NONNULL_END
