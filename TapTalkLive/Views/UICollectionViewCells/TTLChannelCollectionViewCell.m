//
//  TTLChannelCollectionViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/2/23.
//

#import "TTLChannelCollectionViewCell.h"

@interface TTLChannelCollectionViewCell()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *channelImageView;

@end

@implementation TTLChannelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.channelImageView.layer.cornerRadius = CGRectGetWidth(self.channelImageView.frame) / 2;
}

- (void)setChannelImage:(UIImage *)channelImage {
    self.channelImageView.image = channelImage;
    self.channelImageView.layer.cornerRadius = CGRectGetWidth(self.channelImageView.frame) / 2;
}

@end
