//
//  FaqChildTableViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/9/23.
//

#import "TTLFaqChildTableViewCell.h"
#import "OneTalkLiveChat.h"

@interface TTLFaqChildTableViewCell() <ZSWTappableLabelTapDelegate, ZSWTappableLabelLongPressDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet TappableLabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIconImageView;
@property (strong, nonatomic) IBOutlet UIView *faqChildContainerView;
@property (strong, nonatomic) IBOutlet UIView *bottomBackgroundView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomBackgroundViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqChildContentHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqChildContentZeroHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqChildContainerViewBottomConstraint;

@end

@implementation TTLFaqChildTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqChildTitleLabel];
    self.titleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqChildTitleLabel];
    
    self.detailLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFaqChildContentLabel];
    self.detailLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFaqChildContentLabel];
    
    self.detailLabel.tapDelegate = self;
    self.detailLabel.longPressDelegate = self;
    self.detailLabel.longPressDuration = 0.2f;
    
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

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(TappableLabel *)tappableLabel
        tappedAtIndex:(NSInteger)idx
       withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes {
    
    NSTextCheckingResult *result = attributes[@"NSTextCheckingResult"];
    if (result) {
        switch (result.resultType) {
            case NSTextCheckingTypePhoneNumber:
                if ([self.delegate respondsToSelector:@selector(faqChild:phoneDidTapped:)]) {
                    [self.delegate faqChild:self.faqChildModel phoneDidTapped:result.phoneNumber];
                }
                break;
            case NSTextCheckingTypeLink:
                if ([result.URL.scheme.lowercaseString isEqualToString:@"mailto"]) {
                    if ([self.delegate respondsToSelector:@selector(faqChild:emailDidTapped:)]) {
                        [self.delegate faqChild:self.faqChildModel emailDidTapped:result.URL];
                    }
                }
                else {
                    if ([self.delegate respondsToSelector:@selector(faqChild:urlDidTapped:)]) {
                        [self.delegate faqChild:self.faqChildModel urlDidTapped:result.URL];
                    }
                }
                break;
            default:
                break;
        }
    }
}

- (void)tappableLabel:(TappableLabel *)tappableLabel longPressedAtIndex:(NSInteger)idx withAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    
    NSTextCheckingResult *result = attributes[@"NSTextCheckingResult"];
    if (result) {
        switch (result.resultType) {
            case NSTextCheckingTypePhoneNumber:
                if ([self.delegate respondsToSelector:@selector(faqChild:phoneDidLongPressed:)]) {
                    [self.delegate faqChild:self.faqChildModel phoneDidLongPressed:result.phoneNumber];
                }
                break;
            case NSTextCheckingTypeLink:
                if ([result.URL.scheme.lowercaseString isEqualToString:@"mailto"]) {
                    if ([self.delegate respondsToSelector:@selector(faqChild:emailDidLongPressed:)]) {
                        [self.delegate faqChild:self.faqChildModel emailDidLongPressed:result.URL];
                    }
                }
                else {
                    if ([self.delegate respondsToSelector:@selector(faqChild:urlDidLongPressed:)]) {
                        [self.delegate faqChild:self.faqChildModel urlDidLongPressed:result.URL];
                    }
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Custom Methods

- (void)setFaqChildWithData:(TTLFaqModel *)faqSequenceModel {
    _faqChildModel = faqSequenceModel;
    
    self.titleLabel.text = faqSequenceModel.title;
    
    if (![TTLUtil isEmptyString:faqSequenceModel.content]) {
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSDataDetector *phoneNumberDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:NULL];
        UIColor *highlightedUrlColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLeftBubbleMessageBodyURLHighlighted];
        UIColor *defaultUrlColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
        NSString *contentText = faqSequenceModel.content;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentText attributes:nil];
        [linkDetector enumerateMatchesInString:contentText options:0 range:NSMakeRange(0, contentText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[ZSWTappableLabelTappableRegionAttributeName] = @YES;
            attributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
            attributes[NSForegroundColorAttributeName] = defaultUrlColor;
            attributes[ZSWTappableLabelHighlightedBackgroundAttributeName] = highlightedUrlColor;
            attributes[@"NSTextCheckingResult"] = result;
            [attributedString addAttributes:attributes range:result.range];
        }];
        [phoneNumberDetector enumerateMatchesInString:contentText options:0 range:NSMakeRange(0, contentText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[ZSWTappableLabelTappableRegionAttributeName] = @YES;
            attributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
            attributes[NSForegroundColorAttributeName] = defaultUrlColor;
            attributes[ZSWTappableLabelHighlightedBackgroundAttributeName] = highlightedUrlColor;
            attributes[@"NSTextCheckingResult"] = result;
            [attributedString addAttributes:attributes range:result.range];
        }];
        self.detailLabel.attributedText = attributedString;
        
        self.detailLabelTopConstraint.constant = 2.0f;
        self.faqChildContentHeightConstraint.constant = 21.0f;
//        self.faqChildContentHeightConstraint.active = YES;
//        self.faqChildContentZeroHeightConstraint.active = NO;
    }
    else {
        self.detailLabelTopConstraint.constant = 0.0f;
        self.faqChildContentHeightConstraint.constant = 0.0f;
//        self.faqChildContentHeightConstraint.active = NO;
//        self.faqChildContentZeroHeightConstraint.active = YES;
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
