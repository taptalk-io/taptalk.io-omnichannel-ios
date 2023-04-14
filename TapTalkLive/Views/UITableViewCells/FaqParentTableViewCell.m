//
//  FaqParentTableViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/8/23.
//

#import "FaqParentTableViewCell.h"
@interface FaqParentTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *topHeaderContainerView;
@property (weak, nonatomic) IBOutlet UIView *talkToAgentButtonView;
@property (weak, nonatomic) IBOutlet UIView *talkToAgentContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *faqLabel;
@property (weak, nonatomic) IBOutlet UIView *faqContainterView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkToAgentContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqContainerTopConstraint;

@end

@implementation FaqParentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.talkToAgentButtonView.layer.cornerRadius = 8.0f;
    self.talkToAgentButtonView.layer.borderWidth = 1.0f;
    self.talkToAgentButtonView.layer.borderColor = [TTLUtil getColor:@"FF7E00"].CGColor;
    self.backButton.imageView.image = [self.backButton.imageView.image imageWithTintColor:[UIColor whiteColor]];
    
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)setFaqParentData:(TTLFaqModel *)faqModel {
    self.titleLabel.text = faqModel.title;
    self.detailLabel.text = faqModel.content;
    if([faqModel.type isEqualToString:FAQ_TALK_TO_AGENT]) {
        [self showTalkToAgentView:YES];
    }
    else {
        [self showTalkToAgentView:NO];
    }
}

- (void)hideHeaderView {
    self.backButtonContainerHeightConstraint.constant = 0.0f;
    self.topHeaderContainerView.alpha = 0.0f;
    self.faqContainerTopConstraint.constant = 0.0f;
}

- (void)hideFaqLabel {
    self.faqLabel.text = @"";
}

- (void)setTopRadius {
    [TTLUtil performBlock:^{
        UIBezierPath *maskPath = [UIBezierPath
            bezierPathWithRoundedRect:self.faqContainterView.bounds
            byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft)
            cornerRadii:CGSizeMake(8.0f, 8.0f)
        ];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        self.faqContainterView.layer.mask = maskLayer;
    } afterDelay:0.05f];
}

- (void)setAllRoundRadius {
    [TTLUtil performBlock:^{
        self.faqContainterView.layer.cornerRadius = 8.0f;
    } afterDelay:0.05f];
}

- (void)showTalkToAgentView:(BOOL)isShow {
    if(isShow) {
        self.talkToAgentContainerHeightConstraint.constant = 60.0f;
        self.talkToAgentContainerView.alpha = 1.0f;
        
    }
    else {
        self.talkToAgentContainerHeightConstraint.constant = 0.0f;
        self.talkToAgentContainerView.alpha = 0.0f;
    }
}

- (IBAction)talkToAgentButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(faqParentTalkToAgentButtonDidTapped)]) {
        [self.delegate faqParentTalkToAgentButtonDidTapped];
    }
}

- (IBAction)backButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(faqParentBackButtonDidTapped)]) {
        [self.delegate faqParentBackButtonDidTapped];
    }
}



@end
