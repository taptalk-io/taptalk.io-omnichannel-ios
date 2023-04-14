//
//  FaqChildTableViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/9/23.
//

#import "FaqChildTableViewCell.h"
@interface FaqChildTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *faqChildContainerView;

@end

@implementation FaqChildTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.faqChildContainerView.layer.mask = nil;
    self.faqChildContainerView.layer.cornerRadius = 0.0f;
}

- (void)setFaqChildWithData:(TTLFaqModel *)faqSequenceModel {
    self.titleLabel.text = faqSequenceModel.title;
    self.detailLabel.text = faqSequenceModel.content;
}

- (void)setLastChildCellView {
    [TTLUtil performBlock:^{
        UIBezierPath *maskPath = [UIBezierPath
            bezierPathWithRoundedRect:self.faqChildContainerView.bounds
            byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft)
            cornerRadii:CGSizeMake(8.0f, 8.0f)
        ];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        
        self.faqChildContainerView.layer.mask = maskLayer;
    } afterDelay:0.05f];
}

@end
