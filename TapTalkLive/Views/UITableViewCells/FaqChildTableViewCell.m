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
@property (weak, nonatomic) IBOutlet UIImageView *arrowIconImageView;
@property (weak, nonatomic) IBOutlet UIView *faqChildContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackgroundView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBackgroundViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqChildContentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqChildContentZeroHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqChildContainerViewBottomConstraint;

@end

@implementation FaqChildTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqChildTitleLabel];
    self.titleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqChildTitleLabel];
    
    self.detailLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqChildContentLabel];
    self.detailLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqChildContentLabel];
    
    self.arrowIconImageView.image = [self.arrowIconImageView.image imageWithTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary]];
    
    [self addShadow];
    
    self.faqChildContainerView.clipsToBounds = YES;
    self.faqChildContainerView.layer.cornerRadius = 0.0f;
    self.bottomBackgroundViewHeightConstraint.constant = 0.0f;
    self.faqChildContainerViewBottomConstraint.constant = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.faqChildContainerView.layer.mask = nil;
    self.faqChildContainerView.layer.cornerRadius = 0.0f;
    self.bottomBackgroundViewHeightConstraint.constant = 0.0f;
    self.faqChildContainerViewBottomConstraint.constant = 0.0f;
}

- (void)setFaqChildWithData:(TTLFaqModel *)faqSequenceModel {
    self.titleLabel.text = faqSequenceModel.title;
    self.detailLabel.text = faqSequenceModel.content;
    
    if (![TTLUtil isEmptyString:self.detailLabel.text]) {
        self.detailLabelTopConstraint.constant = 2.0f;
        self.faqChildContentHeightConstraint.active = YES;
        self.faqChildContentZeroHeightConstraint.active = NO;
    }
    else {
        self.detailLabelTopConstraint.constant = 0.0f;
        self.faqChildContentHeightConstraint.active = NO;
        self.faqChildContentZeroHeightConstraint.active = YES;
    }
    [self refreshCellHeight];
}

- (void)addShadow {
    [TTLUtil performBlock:^{
        self.faqChildContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.faqChildContainerView.layer.shadowOffset = CGSizeMake(0, 0.0f);
        self.faqChildContainerView.layer.shadowRadius = 2.0f;
        self.faqChildContainerView.layer.shadowOpacity = 0.1f;
        self.faqChildContainerView.layer.masksToBounds = NO;
        self.faqChildContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.faqChildContainerView.bounds cornerRadius:self.faqChildContainerView.layer.cornerRadius].CGPath;
    } afterDelay:0.1f];
}

- (void)setLastChildCellView {
//    [TTLUtil performBlock:^{
//        UIBezierPath *maskPath = [UIBezierPath
//            bezierPathWithRoundedRect:self.faqChildContainerView.bounds
//            byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft)
//            cornerRadii:CGSizeMake(8.0f, 8.0f)
//        ];
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.path = maskPath.CGPath;
//
//        self.faqChildContainerView.layer.mask = maskLayer;
        self.faqChildContainerView.layer.cornerRadius = 8.0f;
        self.faqChildContainerView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        self.bottomBackgroundViewHeightConstraint.constant = 16.0f;
        self.faqChildContainerViewBottomConstraint.constant = 16.0f;
        [self refreshCellHeight];
//    } afterDelay:0.05f];
}

@end
