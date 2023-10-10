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
@property (weak, nonatomic) IBOutlet UIButton *talkToAgentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkToAgentContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqContainerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faqContainerBottomConstraint;

@end

@implementation FaqParentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topHeaderContainerView.backgroundColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
    
    self.faqLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorHomeInfoLabel];
    self.faqLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontHomeInfoLabel];
    
    self.titleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqTitleLabel];
    self.titleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqTitleLabel];
    
    self.detailLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqContentLabel];
    self.detailLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqContentLabel];
    
    [self.talkToAgentButton setTitleColor:[[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorBorderedButtonLabel] forState:UIControlStateNormal];
    self.talkToAgentButton.titleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontBorderedButtonLabel];
    TTLImage *talkToAgentIcon = [UIImage imageNamed:@"TTLIconMessage" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    talkToAgentIcon = [talkToAgentIcon setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary]];
    [self.talkToAgentButton setImage:talkToAgentIcon forState:UIControlStateNormal];
    
    self.talkToAgentButtonView.layer.cornerRadius = 8.0f;
    self.talkToAgentButtonView.layer.borderWidth = 1.0f;
    self.talkToAgentButtonView.layer.borderColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary].CGColor;
    
    TTLImage *backButtonImage = self.backButton.imageView.image;
    self.backButton.imageView.image = [backButtonImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
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
//        UIBezierPath *maskPath = [UIBezierPath
//            bezierPathWithRoundedRect:self.faqContainterView.bounds
//            byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft)
//            cornerRadii:CGSizeMake(8.0f, 8.0f)
//        ];
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.path = maskPath.CGPath;
//        self.faqContainterView.layer.mask = maskLayer;
        self.faqContainterView.layer.cornerRadius = 8.0f;
        self.faqContainterView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        self.faqContainerBottomConstraint.constant = 0.0f;
        [self addShadow];
    } afterDelay:0.05f];
}

- (void)setAllRoundRadius {
    [TTLUtil performBlock:^{
        self.faqContainterView.layer.cornerRadius = 8.0f;
        self.faqContainterView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        self.faqContainerBottomConstraint.constant = 2.0f;
        [self addShadow];
    } afterDelay:0.05f];
}

- (void)addShadow {
    self.faqContainterView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.faqContainterView.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.faqContainterView.layer.shadowRadius = 2.0f;
    self.faqContainterView.layer.shadowOpacity = 0.1f;
    self.faqContainterView.layer.masksToBounds = NO;
    self.faqContainterView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.faqContainterView.bounds cornerRadius:self.faqContainterView.layer.cornerRadius].CGPath;
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
