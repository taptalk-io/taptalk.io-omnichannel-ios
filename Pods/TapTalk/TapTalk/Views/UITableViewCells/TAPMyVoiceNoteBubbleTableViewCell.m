//
//  TAPMyVoiceNoteBubbleTableViewCell.m
//  AFNetworking
//
//  Created by TapTalk.io on 13/04/22.
//

#import "TAPMyVoiceNoteBubbleTableViewCell.h"

@interface TAPMyVoiceNoteBubbleTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) IBOutlet UIView *replyView;
@property (strong, nonatomic) IBOutlet UIView *replyInnerView;
@property (strong, nonatomic) IBOutlet UIView *quoteView;
@property (strong, nonatomic) IBOutlet UIView *replyDecorationView;
@property (strong, nonatomic) IBOutlet UIView *quoteDecorationView;
@property (strong, nonatomic) IBOutlet UIView *voiceNoteBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *bubbleHighlightView;
@property (strong, nonatomic) IBOutlet UILabel *bubbleLabel;
@property (strong, nonatomic) IBOutlet UILabel *voiceNoteDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *voiceNoteDescriptionSizePlaceholderLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteSubtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *forwardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *forwardFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioDurationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sendingIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *statusIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *retryIconImageView;
@property (strong, nonatomic) IBOutlet TAPImageView *quoteImageView;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retryButton;

@property (strong, nonatomic) IBOutlet UIView *progressContainerView;
@property (strong, nonatomic) IBOutlet UIView *innerBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *progressBarView;

@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (strong, nonatomic) IBOutlet UIView *downloadView;
@property (strong, nonatomic) IBOutlet UIView *doneDownloadView;
@property (strong, nonatomic) IBOutlet UIView *retryDownloadView;
@property (strong, nonatomic) IBOutlet UIImageView *cancelImageView;
@property (strong, nonatomic) IBOutlet UIImageView *downloadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *doneDownloadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *retryDownloadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *voiceNoteImageView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *downloadFileButton;
@property (strong, nonatomic) IBOutlet UIButton *doneDownloadButton;
@property (strong, nonatomic) IBOutlet UIButton *doneDownloadTitleAndDescriptionButton;
@property (strong, nonatomic) IBOutlet UIButton *retryDownloadButton;
@property (weak, nonatomic) IBOutlet UIImageView *starIconImageView;
@property (weak, nonatomic) IBOutlet UISlider *audioSlider;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *forwardCheckmarkButton;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatBubbleRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sendingIconLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sendingIconBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *statusIconRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyButtonRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewHeightContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewInnerViewLeadingContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyNameLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyNameLabelTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyMessageLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyMessageLabelTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyButtonLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyButtonTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *replyViewBottomConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forwardTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forwardFromLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forwardTitleLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forwardFromLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forwardTitleLabelTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *swipeReplyViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *swipeReplyViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelBottomConstraint;

@property (strong, nonatomic) UILongPressGestureRecognizer *bubbleViewLongPressGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) BOOL disableTriggerHapticFeedbackOnDrag;

@property (strong, nonatomic) NSString *statusLabelTimeString;

@property (strong, nonatomic) UIView *syncProgressSubView;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (nonatomic) CGFloat lastProgress;

@property (nonatomic) BOOL isDownloaded;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat pathWidth;
@property (nonatomic) CGFloat newProgress;
@property (nonatomic) NSInteger updateInterval;
@property (nonatomic) BOOL isPlaying;

@property (nonatomic) BOOL isOnSendingAnimation;
@property (nonatomic) BOOL isShouldChangeStatusAsDelivered;
@property (nonatomic) BOOL isShouldChangeStatusAsRead;
@property (nonatomic) BOOL isShowForwardView;

- (IBAction)replyButtonDidTapped:(id)sender;
- (IBAction)retryButtonDidTapped:(id)sender;
- (IBAction)quoteButtonDidTapped:(id)sender;
- (IBAction)retryUploadDownloadButtonDidTapped:(id)sender;
- (IBAction)downloadButtonDidTapped:(id)sender;
- (IBAction)doneDownloadButtonDidTapped:(id)sender;
- (IBAction)doneDownloadTitleAndDescriptionButtonDidTapped:(id)sender;
- (IBAction)cancelButtonDidTapped:(id)sender;
- (void)handleBubbleViewLongPress:(UILongPressGestureRecognizer *)recognizer;
- (void)showReplyView:(BOOL)show withMessage:(TAPMessageModel *)message;
- (void)showQuoteView:(BOOL)show;
- (void)showForwardView:(BOOL)show;

- (void)setForwardData:(TAPForwardFromModel *)forwardData;
- (void)setQuote:(TAPQuoteModel *)quote userID:(NSString *)userID;
- (void)setBubbleCellStyle;
@end

@implementation TAPMyVoiceNoteBubbleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _startAngle = M_PI * 1.5;
    _endAngle = self.startAngle + (M_PI * 2);
    _borderWidth = 0.0f;
    _pathWidth = 4.0f;
    _newProgress = 0.0f;
    _updateInterval = 1;
    _cellWidth = 0.0f;
    _cellHeight = 0.0f;
    
    self.bubbleView.clipsToBounds = YES;
    self.statusLabelTopConstraint.constant = 0.0f;
    self.statusLabelHeightConstraint.constant = 0.0f;
    self.statusLabel.alpha = 0.0f;
//    self.statusIconImageView.alpha = 0.0f;
    self.sendingIconImageView.alpha = 0.0f;
    
    self.progressContainerView.layer.cornerRadius = CGRectGetHeight(self.innerBackgroundView.frame) / 2.0f;
    self.progressBarView.layer.cornerRadius = CGRectGetHeight(self.progressBarView.frame) / 2.0f;
    
    _isDownloaded = NO;
    
    
    self.bubbleView.layer.cornerRadius = 16.0f;
    self.bubbleView.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    self.bubbleView.clipsToBounds = YES;
    
    self.bubbleHighlightView.layer.cornerRadius = 16.0f;
    self.bubbleHighlightView.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    self.bubbleHighlightView.clipsToBounds = YES;
    
    self.retryIconImageView.alpha = 0.0f;
    self.retryButton.alpha = 0.0f;
    
    self.replyView.layer.cornerRadius = 4.0f;
    self.replyView.clipsToBounds = YES;
    
    self.quoteView.layer.cornerRadius = 8.0f;
    self.quoteView.clipsToBounds = YES;
    
    self.quoteImageView.layer.cornerRadius = 4.0f;
    self.quoteImageView.delegate = self;
    
    self.voiceNoteBackgroundView.layer.cornerRadius = 24.0f;
    
    self.swipeReplyView.layer.cornerRadius = CGRectGetHeight(self.swipeReplyView.frame) / 2.0f;
    self.swipeReplyView.backgroundColor = [[[TAPStyleManager sharedManager] getDefaultColorForType:TAPDefaultColorPrimary] colorWithAlphaComponent:0.3f];
    
    self.starIconImageView.alpha = 0.0f;
    
    UIImage *swipeReplyImage;
    if (IS_BELOW_IOS_13) {
        swipeReplyImage = [UIImage imageNamed:@"TAPIconReplyChatOrange" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else {
        swipeReplyImage = [UIImage imageNamed:@"TAPIconReplyChatOrange" inBundle:[TAPUtil currentBundle] withConfiguration:nil];
    }
    
    swipeReplyImage = [swipeReplyImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorButtonIconPrimary]];
    self.swipeReplyImageView.image = swipeReplyImage;
    
    _bubbleViewLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleBubbleViewLongPress:)];
    self.bubbleViewLongPressGestureRecognizer.minimumPressDuration = 0.2f;
    [self.bubbleView addGestureRecognizer:self.bubbleViewLongPressGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureAction:)];
    self.panGestureRecognizer.delegate = self;
    //[self.contentView addGestureRecognizer:self.panGestureRecognizer];
    
    [self showQuoteView:NO];
    [self showForwardView:NO];
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeUploading];
    
    [self setBubbleCellStyle];
    
    self.swipeReplyViewHeightConstraint.constant = 30.0f;
    self.swipeReplyViewWidthConstraint.constant = 30.0f;
    self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;
    
    [self.contentView layoutIfNeeded];
    
    self.audioSlider.maximumTrackTintColor = [UIColor whiteColor];
    self.audioSlider.minimumTrackTintColor = [TAPUtil getColor:@"773B00"];
    self.audioSlider.thumbTintColor = [TAPUtil getColor:@"773B00"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.chatBubbleRightConstraint.constant = 16.0f;
    self.statusLabelTopConstraint.constant = 0.0f;
    self.statusLabelHeightConstraint.constant = 0.0f;
    self.statusLabel.alpha = 0.0f;
    self.sendingIconImageView.alpha = 0.0f;
    self.sendingIconLeftConstraint.constant = 4.0f;
    self.sendingIconBottomConstraint.constant = -5.0f;
    self.retryIconImageView.alpha = 0.0f;
    self.retryButton.alpha = 0.0f;
    self.starIconImageView.alpha = 0.0f;
    self.checkMarkIconImageView.alpha = 0.0f;
    
    [self showReplyView:NO withMessage:nil];
    [self showQuoteView:NO];
    
    self.swipeReplyViewHeightConstraint.constant = 30.0f;
    self.swipeReplyViewWidthConstraint.constant = 30.0f;
    self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;
    
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self.contentView layoutIfNeeded];
    
    self.bubbleLabel.text = @"";
    self.statusLabel.text = @"";
    
    UIImage *documentsImage = [UIImage imageNamed:@"TAPIconPlayMessageBubble" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    documentsImage = [documentsImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileWhite]];
    self.voiceNoteImageView.image = documentsImage;
    self.doneDownloadImageView.image = documentsImage;
    
}



#pragma mark - Delegate
- (IBAction)playerSliderDidChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteBubblePlayerSliderDidChange:message:)]) {
        [self.delegate myVoiceNoteBubblePlayerSliderDidChange:self.audioSlider.value message:self.message];
    }
}

- (IBAction)playerSliderDidEnd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteBubblePlayerSliderDidEnd)]) {
        [self.delegate myVoiceNoteBubblePlayerSliderDidEnd];
    }
}

- (IBAction)playerSliderDidEnd2:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteBubblePlayerSliderDidEnd)]) {
        [self.delegate myVoiceNoteBubblePlayerSliderDidEnd];
    }
}


#pragma mark UIGestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGestureRecognizer velocityInView:self];
        if (fabs(velocity.x) > fabs(velocity.y)) {
            return YES;
        }
    }

    return NO;
}

- (void)handlePanGestureAction:(UIPanGestureRecognizer *)recognizer {
    if (![[TapUI sharedInstance] isReplyMessageMenuEnabled]) {
        return;
    }
    
     if (recognizer.state == UIGestureRecognizerStateBegan) {
            _disableTriggerHapticFeedbackOnDrag = NO;
        }
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [recognizer translationInView:self];
            
            if (translation.x < 0) {
                //Cannot swipe left
                return;
            }
            
            if (translation.x > 50.0f && !self.disableTriggerHapticFeedbackOnDrag) {
                [TAPUtil tapticImpactFeedbackGenerator];
                
                [UIView animateWithDuration:0.075f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
                    self.swipeReplyView.alpha = 0.0f;
                    self.swipeReplyViewHeightConstraint.constant = 15.0f;
                    self.swipeReplyViewWidthConstraint.constant = 15.0f;
                    [self.contentView layoutIfNeeded];
                    self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
                        self.swipeReplyView.alpha = 1.0f;
                        self.swipeReplyViewHeightConstraint.constant = 30.0f;
                        self.swipeReplyViewWidthConstraint.constant = 30.0f;
                        [self.contentView layoutIfNeeded];
                        self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;
                    } completion:nil];
                }];
                
                _disableTriggerHapticFeedbackOnDrag = YES;
            }
            
            if (translation.x > 70.0f) {
                translation.x = 70.0f;
            }
            
            self.bubbleView.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            self.replyButton.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            self.statusLabel.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            self.swipeReplyView.transform = CGAffineTransformMakeTranslation(translation.x, 0);
//            self.statusIconImageView.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            self.sendingIconImageView.transform = CGAffineTransformMakeTranslation(translation.x, 0);
            
            self.swipeReplyView.alpha = translation.x / 50.0f;
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            CGPoint translation = [recognizer translationInView:self];
            if (translation.x > 50.0f) {
                if ([self.delegate respondsToSelector:@selector(myVoiceNoteBubbleDidTriggerSwipeToReplyWithMessage:)]) {
                    [self.delegate myVoiceNoteBubbleDidTriggerSwipeToReplyWithMessage:self.message];
                }
            }
            
            _disableTriggerHapticFeedbackOnDrag = NO;
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bubbleView.transform = CGAffineTransformIdentity;
                self.replyButton.transform = CGAffineTransformIdentity;
                self.statusLabel.transform = CGAffineTransformIdentity;
                self.swipeReplyView.transform = CGAffineTransformIdentity;
//                self.statusIconImageView.transform = CGAffineTransformIdentity;
                self.sendingIconImageView.transform = CGAffineTransformIdentity;
                
                self.swipeReplyView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.swipeReplyViewHeightConstraint.constant = 30.0f;
                self.swipeReplyViewWidthConstraint.constant = 30.0f;
                [self.contentView layoutIfNeeded];
                self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;
            }];
        }
        else if (recognizer.state == UIGestureRecognizerStateCancelled) {
            _disableTriggerHapticFeedbackOnDrag = NO;
            
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bubbleView.transform = CGAffineTransformIdentity;
                self.replyButton.transform = CGAffineTransformIdentity;
                self.statusLabel.transform = CGAffineTransformIdentity;
                self.swipeReplyView.transform = CGAffineTransformIdentity;
//                self.statusIconImageView.transform = CGAffineTransformIdentity;
                self.sendingIconImageView.transform = CGAffineTransformIdentity;
                
                self.swipeReplyView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.swipeReplyViewHeightConstraint.constant = 30.0f;
                self.swipeReplyViewWidthConstraint.constant = 30.0f;
                [self.contentView layoutIfNeeded];
                self.swipeReplyView.layer.cornerRadius = self.swipeReplyViewHeightConstraint.constant / 2.0f;
            }];
        }
}

#pragma mark - TAPImageViewDelegate

- (void)imageViewDidFinishLoadImage:(TAPImageView *)imageView {
    if (imageView == self.quoteImageView) {
        if (imageView.image == nil) {
            [self showQuoteView:NO];
            [self showReplyView:YES withMessage:self.message];
        }
    }
}

#pragma mark - Custom Method
- (void)setBubbleCellStyle {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bubbleView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightBubbleBackground];
    self.quoteView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightBubbleQuoteBackground];
    self.replyInnerView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightBubbleQuoteBackground];
    self.replyDecorationView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightBubbleQuoteDecorationBackground];
    self.quoteDecorationView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightBubbleQuoteDecorationBackground];
    self.voiceNoteBackgroundView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconQuotedFileBackgroundRight];
    self.progressContainerView.backgroundColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorRightVoiceNoteButtonBackground];
    
    UIFont *quoteTitleFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightBubbleQuoteTitle];
    UIColor *quoteTitleColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightBubbleQuoteTitle];

    UIFont *quoteContentFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightBubbleQuoteContent];
    UIColor *quoteContentColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightBubbleQuoteContent];

    UIFont *bubbleLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightBubbleMessageBody];
    UIColor *bubbleLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightBubbleMessageBody];

    UIFont *statusLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontBubbleMessageStatus];
    UIColor *statusLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorBubbleMessageStatus];

    UIFont *timestampLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightBubbleMessageTimestamp];
    UIColor *timestampLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightBubbleMessageTimestamp];

    UIFont *fileNameLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightFileBubbleName];
    UIColor *fileNameLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightFileBubbleName];
    
    UIFont *fileInfoLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightFileBubbleInfo];
    UIColor *fileInfoLabelColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorRightFileBubbleInfo];
    
    UIFont *voiceDurationLabelFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightVoiceBubbleDuration];

    self.replyNameLabel.textColor = quoteTitleColor;
    self.replyNameLabel.font = quoteTitleFont;
    
    self.replyMessageLabel.textColor = quoteContentColor;
    self.replyMessageLabel.font = quoteContentFont;
    
    self.quoteTitleLabel.textColor = quoteTitleColor;
    self.quoteTitleLabel.font = quoteTitleFont;
    
    self.quoteSubtitleLabel.textColor = quoteContentColor;
    self.quoteSubtitleLabel.font = quoteContentFont;
    
    self.forwardTitleLabel.textColor = quoteContentColor;
    self.forwardTitleLabel.font = quoteContentFont;
    
    self.forwardFromLabel.textColor = quoteContentColor;
    self.forwardFromLabel.font = quoteContentFont;
    
    self.bubbleLabel.textColor = fileNameLabelColor;
    self.bubbleLabel.font = fileNameLabelFont;
    
    self.statusLabel.textColor = statusLabelColor;
    self.statusLabel.font = statusLabelFont;

    self.timestampLabel.textColor = timestampLabelColor;
    self.timestampLabel.font = timestampLabelFont;
    
    self.voiceNoteDescriptionLabel.textColor = fileInfoLabelColor;
    self.voiceNoteDescriptionLabel.font = fileInfoLabelFont;
    
    self.voiceNoteDescriptionSizePlaceholderLabel.textColor = fileInfoLabelColor;
    self.voiceNoteDescriptionSizePlaceholderLabel.font = fileInfoLabelFont;
    
    self.audioDurationLabel.textColor = timestampLabelColor;
    self.audioDurationLabel.font = voiceDurationLabelFont;
    
    UIImage *abortImage = [UIImage imageNamed:@"TAPIconAbort" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    abortImage = [abortImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconCancelUploadDownloadPrimary]];
    self.cancelImageView.image = abortImage;
    
    UIImage *documentsImage = [UIImage imageNamed:@"TAPIconPlayMessageBubble" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    documentsImage = [documentsImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileUploadDownloadWhite]];
    self.voiceNoteImageView.image = documentsImage;
    self.doneDownloadImageView.image = documentsImage;
    
    UIImage *retryImage = [UIImage imageNamed:@"TAPIconRetry" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    retryImage = [retryImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileUploadDownloadWhite]];
    self.retryDownloadImageView.image = retryImage;
    
    UIImage *downloadImage = [UIImage imageNamed:@"TAPIconDownload" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    downloadImage = [downloadImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileUploadDownloadWhite]];
    self.downloadImageView.image = downloadImage;
}

- (void)setMessage:(TAPMessageModel *)message {
    if(message == nil) {
        return;
    }
    
//    _message = message;
    [super setMessage:message];
    
    if (![message.forwardFrom.localID isEqualToString:@""] && message.forwardFrom != nil) {
        [self showForwardView:YES];
        [self setForwardData:message.forwardFrom];
        _isShowForwardView = YES;
    }
    else {
        [self showForwardView:NO];
        _isShowForwardView = NO;
    }

    if ((![message.replyTo.messageID isEqualToString:@"0"] && ![message.replyTo.messageID isEqualToString:@""]) && ![message.quote.title isEqualToString:@""] && message.quote != nil && message.replyTo != nil) {
        //reply to exists
        //if reply exists check if image in quote exists
        //if image exists  change view to Quote View
        
        if (self.isShowForwardView) {
            self.forwardTitleLabelTopConstraint.constant = 10.0f;
        }
        else {
            self.forwardTitleLabelTopConstraint.constant = 11.0f;
        }
        [self.contentView layoutIfNeeded];
        
        
        if([message.quote.content isEqualToString:@"🎤 Voice"]){
            [self showReplyView:YES withMessage:message];
            [self showQuoteView:NO];
        }
        else if((message.quote.fileID && ![message.quote.fileID isEqualToString:@""]) || (message.quote.imageURL  && ![message.quote.fileID isEqualToString:@""])) {
            [self showReplyView:NO withMessage:nil];
            [self showQuoteView:YES];
            [self setQuote:message.quote userID:message.replyTo.userID];
        }
        else {
            [self showReplyView:YES withMessage:message];
            [self showQuoteView:NO];
        }
    }
    else if (![message.quote.title isEqualToString:@""] && message.quote != nil) {
        //quote exists
        
        if (self.isShowForwardView) {
            self.forwardTitleLabelTopConstraint.constant = 10.0f;
        }
        else {
            self.forwardTitleLabelTopConstraint.constant = 11.0f;
        }
        [self.contentView layoutIfNeeded];
        
        [self showReplyView:NO withMessage:nil];
        [self showQuoteView:YES];
        [self setQuote:message.quote userID:@""];
    }
    else {
        if (self.isShowForwardView) {
            self.forwardTitleLabelTopConstraint.constant = 10.0f;
        }
        else {
            self.forwardTitleLabelTopConstraint.constant = 0.0f;
        }
        [self.contentView layoutIfNeeded];
        
        [self showReplyView:NO withMessage:nil];
        [self showQuoteView:NO];
    }
    
    
    
    NSString *fileName = [message.data objectForKey:@"fileName"];
    fileName = [TAPUtil nullToEmptyString:fileName];
    
    NSString *fileExtension  = [[fileName pathExtension] uppercaseString];
    
    fileName = [fileName stringByDeletingPathExtension];
    
    if ([fileExtension isEqualToString:@""]) {
        fileExtension = [message.data objectForKey:@"mediaType"];
        fileExtension = [TAPUtil nullToEmptyString:fileExtension];
        fileExtension = [fileExtension lastPathComponent];
        fileExtension = [fileExtension uppercaseString];
    }
    
    self.bubbleLabel.text = fileName;
    
    
    
    NSNumber *sizeData = [message.data objectForKey:@"size"];
    NSNumber *durationData = [message.data objectForKey:@"duration"];
    NSInteger durationInteger = [durationData intValue];
    durationInteger = durationInteger/1000;//milisecond to second
    self.audioDurationLabel.text = [self secondToMinuteString:durationInteger];
    
    if (sizeData != nil && sizeData.longValue > 0L) {
        NSString *fileSize = [NSByteCountFormatter stringFromByteCount:[sizeData integerValue] countStyle:NSByteCountFormatterCountStyleBinary];
        self.voiceNoteDescriptionSizePlaceholderLabel.text = [NSString stringWithFormat:@"999.99 MB / %@", fileSize];
        self.voiceNoteDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@", fileSize, fileExtension];
    }
    else {
        self.voiceNoteDescriptionLabel.text = fileExtension;
    }
    
    NSTimeInterval lastMessageTimeInterval = [message.created doubleValue] / 1000.0f; //change to second from milisecond
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
    
    NSTimeInterval timeGap = currentTimeInterval - lastMessageTimeInterval;
    NSDateFormatter *midnightDateFormatter = [[NSDateFormatter alloc] init];
    [midnightDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]; // POSIX to avoid weird issues
    midnightDateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString *midnightFormattedCreatedDate = [midnightDateFormatter stringFromDate:currentDate];
    
    NSDate *todayMidnightDate = [midnightDateFormatter dateFromString:midnightFormattedCreatedDate];
    NSTimeInterval midnightTimeInterval = [todayMidnightDate timeIntervalSince1970];
    
    NSTimeInterval midnightTimeGap = currentTimeInterval - midnightTimeInterval;
    
    NSDate *lastMessageDate = [NSDate dateWithTimeIntervalSince1970:lastMessageTimeInterval];
    NSString *lastMessageDateString = @"";
    if (timeGap <= midnightTimeGap) {
        //Today
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:lastMessageDate];
        NSString *appendedLastDateString = NSLocalizedStringFromTableInBundle(@"at ", nil, [TAPUtil currentBundle], @"");
        lastMessageDateString = [NSString stringWithFormat:@"%@%@", appendedLastDateString, dateString];
    }
    else if (timeGap <= 86400.0f + midnightTimeGap) {
        //Yesterday
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:lastMessageDate];
        NSString *appendedLastDateString = NSLocalizedStringFromTableInBundle(@"yesterday at ", nil, [TAPUtil currentBundle], @"");
        lastMessageDateString = [NSString stringWithFormat:@"%@%@", appendedLastDateString, dateString];
    }
    else {
        //Set date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
        
        NSString *dateString = [dateFormatter stringFromDate:lastMessageDate];
        NSString *appendedLastDateString = NSLocalizedStringFromTableInBundle(@"at ", nil, [TAPUtil currentBundle], @"");
        lastMessageDateString = [NSString stringWithFormat:@"%@%@", appendedLastDateString, dateString];
    }
    
    NSString *appendedStatusString = NSLocalizedStringFromTableInBundle(@"Sent ", nil, [TAPUtil currentBundle], @"");
    NSString *statusString = [NSString stringWithFormat:@"%@%@", appendedStatusString, lastMessageDateString];
    self.statusLabelTimeString = statusString;
    self.statusLabel.text = self.statusLabelTimeString;
    
    //remove animation
    [self.bubbleView.layer removeAllAnimations];
    [self.timestampLabel.layer removeAllAnimations];
    [self.quoteView.layer removeAllAnimations];
    [self.quoteDecorationView.layer removeAllAnimations];
    [self.replyView.layer removeAllAnimations];
    [self.replyDecorationView.layer removeAllAnimations];
    [self.bubbleLabel.layer removeAllAnimations];
    [self.replyNameLabel.layer removeAllAnimations];
    [self.replyMessageLabel.layer removeAllAnimations];
    [self.replyInnerView.layer removeAllAnimations];
    [self.statusIconImageView.layer removeAllAnimations];
    [self.forwardFromLabel.layer removeAllAnimations];
    [self.forwardTitleLabel.layer removeAllAnimations];
    [self.quoteImageView.layer removeAllAnimations];
}

- (void)setAudioSliderValue:(NSTimeInterval)currentTime{
    self.audioSlider.value = currentTime;
}
- (void)setAudioSliderMaximumValue:(NSTimeInterval)duration{
    self.audioSlider.maximumValue = duration;
}

- (void)setVoiceNoteDurationLabel:(NSString *)duration{
    self.audioDurationLabel.text = duration;
}

- (void)setPlayingState:(BOOL)isPlay{
    self.isPlaying = isPlay;
    if(isPlay){
        UIImage *documentsImage = [UIImage imageNamed:@"TAPIconPauseMessageBubble" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        documentsImage = [documentsImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileWhite]];
        self.voiceNoteImageView.image = documentsImage;
        self.doneDownloadImageView.image = documentsImage;
    }
    else{
        UIImage *documentsImage = [UIImage imageNamed:@"TAPIconPlayMessageBubble" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        documentsImage = [documentsImage setImageTintColor:[[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorIconFileWhite]];
        self.voiceNoteImageView.image = documentsImage;
        self.doneDownloadImageView.image = documentsImage;
    }
}

- (void)receiveSentEvent {
    [super receiveSentEvent];
}

- (void)receiveDeliveredEvent {
    [super receiveDeliveredEvent];
}

- (void)receiveReadEvent {
    [super receiveReadEvent];
}

- (void)showStatusLabel:(BOOL)show {
    if (show) {
            self.statusLabel.alpha = 1.0f;
            self.statusLabelTopConstraint.constant = 2.0f;
            self.statusLabelHeightConstraint.constant = 13.0f;
            self.replyButton.alpha = 1.0f;
            self.replyButtonRightConstraint.constant = 2.0f;
            self.statusIconImageView.alpha = 1.0f;
            [self.contentView layoutIfNeeded];
    }
    else {
            self.statusLabel.alpha = 0.0f;
            self.statusLabelTopConstraint.constant = 0.0f;
            self.statusLabelHeightConstraint.constant = 0.0f;
            self.replyButton.alpha = 0.0f;
            self.replyButtonRightConstraint.constant = -28.0f;
            self.statusIconImageView.alpha = 1.0f;
            [self.contentView layoutIfNeeded];
    }
}
- (IBAction)forwardCheckmarkButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteCheckmarkDidTapped:)]) {
        [self.delegate myVoiceNoteCheckmarkDidTapped:self.message];
    }
}

- (IBAction)replyButtonDidTapped:(id)sender {
    [super replyButtonDidTapped:sender];
    
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteReplyDidTapped:)]) {
        [self.delegate myVoiceNoteReplyDidTapped:self.message];
    }
}

- (IBAction)retryButtonDidTapped:(id)sender {
    [super retryButtonDidTapped:sender];
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteRetryUploadDownloadButtonDidTapped:)]) {
        [self.delegate myVoiceNoteRetryUploadDownloadButtonDidTapped:self.message];
    }
}

- (IBAction)retryUploadDownloadButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteRetryUploadDownloadButtonDidTapped:)]) {
        [self.delegate myVoiceNoteRetryUploadDownloadButtonDidTapped:self.message];
    }
}

- (IBAction)downloadButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteDownloadButtonDidTapped:)]) {
        [self.delegate myVoiceNoteDownloadButtonDidTapped:self.message];
    }
}

- (IBAction)doneDownloadButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNotePlayPauseButtonDidTapped:)]) {
        [self.delegate myVoiceNotePlayPauseButtonDidTapped:self.message];
    }
}

- (IBAction)doneDownloadTitleAndDescriptionButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNotePlayPauseButtonDidTappedmyVoiceNotePlayPauseButtonDidTappedmyVoiceNotePlayPauseButtonDidTapped:)]) {
        [self.delegate myVoiceNotePlayPauseButtonDidTapped:self.message];
    }
}

- (IBAction)cancelButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteCancelButtonDidTapped:)]) {
        [self.delegate myVoiceNoteCancelButtonDidTapped:self.message];
    }
}

- (void)handleBubbleViewTap:(UITapGestureRecognizer *)recognizer {
    [super handleBubbleViewTap:recognizer];
    
}

- (void)handleBubbleViewLongPress:(UILongPressGestureRecognizer *)recognizer {
    if(recognizer.state = UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(myVoiceNoteBubbleLongPressedWithMessage:)]) {
            [self.delegate myVoiceNoteBubbleLongPressedWithMessage:self.message];
        }
    }
}

- (IBAction)quoteButtonDidTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myVoiceNoteQuoteViewDidTapped:)]) {
        [self.delegate myVoiceNoteQuoteViewDidTapped:self.message];
    }
}

- (void)showReplyView:(BOOL)show withMessage:(TAPMessageModel *)message {
    if (show) {
        //check id message sender is equal to active user id, if yes change the title to "You"
        if ([message.replyTo.userID isEqualToString:[TAPDataManager getActiveUser].userID]) {
            self.replyNameLabel.text = NSLocalizedStringFromTableInBundle(@"You", nil, [TAPUtil currentBundle], @"");
        }
        else {
            self.replyNameLabel.text = message.quote.title;
        }

        self.replyMessageLabel.text = message.quote.content;
        self.replyViewHeightContraint.constant = 60.0f;
        self.replyViewBottomConstraint.active = YES;
        self.replyViewBottomConstraint.constant = 8.0f;
        self.replyViewTopConstraint.active = YES;
        self.replyViewTopConstraint.constant = 0.0f;
        self.replyViewInnerViewLeadingContraint.constant = 4.0f;
        self.replyNameLabelLeadingConstraint.constant = 8.0f;
        self.replyNameLabelTrailingConstraint.constant = 8.0f;
        self.replyMessageLabelLeadingConstraint.constant = 8.0f;
        self.replyMessageLabelTrailingConstraint.constant = 8.0f;
        self.replyButtonLeadingConstraint.active = YES;
        self.replyButtonTrailingConstraint.active = YES;
    }
    else {
        self.replyNameLabel.text = @"";
        self.replyMessageLabel.text = @"";
        self.replyViewHeightContraint.constant = 0.0f;
        self.replyViewBottomConstraint.active = YES;
        self.replyViewBottomConstraint.constant = 0.0f;
        self.replyViewTopConstraint.active = YES;

        if (self.isShowForwardView) {
            self.replyViewTopConstraint.constant = 8.0f;
        }
        else {
            self.replyViewTopConstraint.constant = 10.0f;
        }
        
        self.replyViewInnerViewLeadingContraint.constant = 0.0f;
        self.replyNameLabelLeadingConstraint.constant = 0.0f;
        self.replyNameLabelTrailingConstraint.constant = 0.0f;
        self.replyMessageLabelLeadingConstraint.constant = 0.0f;
        self.replyMessageLabelTrailingConstraint.constant = 0.0f;
        self.replyButtonLeadingConstraint.active = NO;
        self.replyButtonTrailingConstraint.active = NO;
    }
    [self.contentView layoutIfNeeded];
}

- (void)showQuoteView:(BOOL)show {
    if (show) {
        self.quoteViewLeadingConstraint.active = YES;
        self.quoteViewTrailingConstraint.active = YES;
        self.quoteViewTopConstraint.active = YES;
        self.quoteViewTopConstraint.constant = 0.0f;
        self.quoteViewBottomConstraint.active = YES;
        self.quoteView.alpha = 1.0f;
        self.replyViewBottomConstraint.active = NO;
        self.replyViewTopConstraint.active = NO;
    }
    else {
        self.quoteViewLeadingConstraint.active = NO;
        self.quoteViewTrailingConstraint.active = NO;
        self.quoteViewTopConstraint.active = NO;
        self.quoteViewBottomConstraint.active = NO;
        self.quoteView.alpha = 0.0f;
        self.replyViewBottomConstraint.active = YES;
        self.replyViewTopConstraint.active = YES;
    }
    [self.contentView layoutIfNeeded];
}

- (void)showForwardView:(BOOL)show {
    if (show) {
        self.forwardFromLabelHeightConstraint.constant = 16.0f;
        self.forwardTitleLabelHeightConstraint.constant = 16.0f;
        self.forwardFromLabelLeadingConstraint.active = YES;
        self.forwardTitleLabelLeadingConstraint.active = YES;
    }
    else {
        self.forwardFromLabelHeightConstraint.constant = 0.0f;
        self.forwardTitleLabelHeightConstraint.constant = 0.0f;
        self.forwardFromLabelLeadingConstraint.active = NO;
        self.forwardTitleLabelLeadingConstraint.active = NO;
    }
    [self.contentView layoutIfNeeded];
}

- (void)setForwardData:(TAPForwardFromModel *)forwardData {
    
    NSString *initialAppendedFullnameString = NSLocalizedStringFromTableInBundle(@"From: ", nil, [TAPUtil currentBundle], @"");
    NSString *initialNameString = NSLocalizedStringFromTableInBundle(@"From: ", nil, [TAPUtil currentBundle], @"");
    NSString *appendedFullnameString = [NSString stringWithFormat:@"%@%@", initialNameString, forwardData.fullname];
    
    //check id message sender is equal to active user id, if yes change the title to "You"
    if ([forwardData.userID isEqualToString:[TAPDataManager getActiveUser].userID]) {
        appendedFullnameString = NSLocalizedStringFromTableInBundle(@"From: You", nil, [TAPUtil currentBundle], @"");
    }
    
    self.forwardFromLabel.text = appendedFullnameString;
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc]
     initWithAttributedString:[[NSAttributedString alloc] initWithString:self.forwardFromLabel.text]];
    
    UIFont *quoteTitleFont = [[TAPStyleManager sharedManager] getComponentFontForType:TAPComponentFontRightBubbleQuoteTitle];
    [attributedText addAttribute:NSFontAttributeName
                           value:quoteTitleFont
                           range:NSMakeRange(6, [self.forwardFromLabel.text length] - 6)];
    
    self.forwardFromLabel.attributedText = attributedText;
    [self.contentView layoutIfNeeded];
}

- (void)setQuote:(TAPQuoteModel *)quote userID:(NSString *)userID {
    if ([quote.fileType isEqualToString:[NSString stringWithFormat:@"%ld", TAPChatMessageTypeFile]] || [quote.fileType isEqualToString:@"file"]) {
        //TYPE FILE
        self.voiceNoteImageView.alpha = 1.0f;
        self.quoteImageView.alpha = 0.0f;
    }
    else {
        if (quote.imageURL != nil && ![quote.imageURL isEqualToString:@""]) {
            [self.quoteImageView setImageWithURLString:quote.imageURL];
        }
        else if (quote.fileID != nil && ![quote.fileID isEqualToString:@""]) {
            [self.quoteImageView setImageWithURLString:quote.fileID];
        }
        self.voiceNoteImageView.alpha = 0.0f;
        self.quoteImageView.alpha = 1.0f;
    }
    
    //check id message sender is equal to active user id, if yes change the title to "You"
    if ([userID isEqualToString:[TAPDataManager getActiveUser].userID]) {
        self.quoteTitleLabel.text = NSLocalizedStringFromTableInBundle(@"You", nil, [TAPUtil currentBundle], @"");
    }
    else {
        self.quoteTitleLabel.text = [TAPUtil nullToEmptyString:quote.title];
    }
    
    self.quoteSubtitleLabel.text = [TAPUtil nullToEmptyString:quote.content];
}

- (void)showDownloadedState:(BOOL)isShow {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    if (isShow) {
        [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeDoneDownloadedUploaded];
    }
    else {
        [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeNotDownloaded];
    }
}

- (void)animateFinishedUploadFile {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeDoneDownloadedUploaded];
}

- (void)animateFinishedDownloadFile {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeDoneDownloadedUploaded];
}

- (void)animateCancelDownloadFile {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeNotDownloaded];
}

- (void)animateFailedUploadFile {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeRetryUpload];
    
    self.chatBubbleRightConstraint.constant = 16.0f;
    self.statusIconRightConstraint.constant = 2.0f;
    
    self.sendingIconLeftConstraint.constant = 4.0f;
    self.sendingIconImageView.alpha = 0.0f;
    self.sendingIconBottomConstraint.constant = -5.0f;
    
    self.statusIconImageView.alpha = 0.0f;
    
    [self.contentView layoutIfNeeded];
}

- (void)animateFailedDownloadFile {
    self.lastProgress = 0.0f;
    self.progressLayer.strokeEnd = 0.0f;
    self.progressLayer.strokeStart = 0.0f;
    [self.progressLayer removeAllAnimations];
    [self.syncProgressSubView removeFromSuperview];
    _progressLayer = nil;
    _syncProgressSubView = nil;
    
    [self showFileBubbleStatusWithType:TAPMyVoiceNoteBubbleTableViewCellStateTypeRetryDownload];
}

- (void)animateProgressUploadingFileWithProgress:(CGFloat)progress total:(CGFloat)total {
    CGFloat lastProgress = self.lastProgress;
    _newProgress = progress/total;
    
    NSInteger lastPercentage = (NSInteger)floorf((100.0f * lastProgress));
    
    //Circular Progress Bar using CAShapeLayer and UIBezierPath
    _progressLayer = [CAShapeLayer layer];
    [self.progressLayer setFrame:self.progressBarView.bounds];
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.progressBarView.bounds), CGRectGetMidY(self.progressBarView.bounds)) radius:(self.progressBarView.bounds.size.height - self.borderWidth - self.pathWidth) / 2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.strokeColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorFileProgressBackgroundPrimary].CGColor;
    self.progressLayer.lineWidth = 3.0f;
    self.progressLayer.path = progressPath.CGPath;
    self.progressLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.position = CGPointMake(self.progressBarView.layer.frame.size.width / 2 - self.borderWidth / 2, self.progressBarView.layer.frame.size.height / 2 - self.borderWidth / 2);
    [self.progressLayer setStrokeEnd:0.0f];
    [self.syncProgressSubView.layer addSublayer:self.progressLayer];
    
    [self.progressLayer setStrokeEnd:self.newProgress];
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = self.updateInterval;
    [strokeEndAnimation setFillMode:kCAFillModeForwards];
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
    strokeEndAnimation.toValue = [NSNumber numberWithFloat:self.newProgress];
    _lastProgress = self.newProgress;
    [self.progressLayer addAnimation:strokeEndAnimation forKey:@"progressStatus"];
}

- (void)animateProgressDownloadingFileWithProgress:(CGFloat)progress total:(CGFloat)total {
    CGFloat lastProgress = self.lastProgress;
    _newProgress = progress/total;
    
    NSInteger lastPercentage = (NSInteger)floorf((100.0f * lastProgress));
    //Circular Progress Bar using CAShapeLayer and UIBezierPath
    _progressLayer = [CAShapeLayer layer];
    [self.progressLayer setFrame:self.progressBarView.bounds];
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.progressBarView.bounds), CGRectGetMidY(self.progressBarView.bounds)) radius:(self.progressBarView.bounds.size.height - self.borderWidth - self.pathWidth) / 2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.strokeColor = [[TAPStyleManager sharedManager] getComponentColorForType:TAPComponentColorFileProgressBackgroundPrimary].CGColor;
    self.progressLayer.lineWidth = 3.0f;
    self.progressLayer.path = progressPath.CGPath;
    self.progressLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.position = CGPointMake(self.progressBarView.layer.frame.size.width / 2 - self.borderWidth / 2, self.progressBarView.layer.frame.size.height / 2 - self.borderWidth / 2);
    [self.progressLayer setStrokeEnd:0.0f];
    [self.syncProgressSubView.layer addSublayer:self.progressLayer];
    
    [self.progressLayer setStrokeEnd:self.newProgress];
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = self.updateInterval;
    [strokeEndAnimation setFillMode:kCAFillModeForwards];
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
    strokeEndAnimation.toValue = [NSNumber numberWithFloat:self.newProgress];
    _lastProgress = self.newProgress;
    [self.progressLayer addAnimation:strokeEndAnimation forKey:@"progressStatus"];
}

- (void)showFileBubbleStatusWithType:(TAPMyVoiceNoteBubbleTableViewCellStateType)type {
    
    // borderWidth is a float representing a value used as a margin (outer border).
    // pathwidth is the width of the progress path (inner).
    _startAngle = M_PI * 1.5;
    _endAngle = self.startAngle + (M_PI * 2);
    _borderWidth = 0.0f;
    _pathWidth = 4.0f;
    
    // progress is a float storing current progress
    // newProgress is a float storing updated progress
    // updateInterval is a float specifying the duration of the animation.
    _newProgress = 0.0f;
    _updateInterval = 1;
    
    // set initial
    _syncProgressSubView = [[UIView alloc] initWithFrame:self.progressBarView.bounds];
    [self.progressBarView addSubview:self.syncProgressSubView];
    _progressLayer = [CAShapeLayer layer];
    _lastProgress = 0.0f;
    
    if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeDoneDownloadedUploaded) {
        self.cancelView.alpha = 0.0f;
        self.downloadView.alpha = 0.0f;
        self.doneDownloadView.alpha = 1.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 1.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = YES;
        self.retryDownloadView.alpha = 0.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        self.statusLabel.text = self.statusLabelTimeString;
        [self showStatusLabel:NO];
    }
    else if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeNotDownloaded) {
        self.cancelView.alpha = 0.0f;
        self.downloadView.alpha = 1.0f;
        self.doneDownloadView.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = NO;
        self.retryDownloadView.alpha = 0.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        self.statusLabel.text = self.statusLabelTimeString;
        [self showStatusLabel:NO];
    }
    else if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeUploading) {
        self.cancelView.alpha = 1.0f;
        self.downloadView.alpha = 0.0f;
        self.doneDownloadView.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = NO;
        self.retryDownloadView.alpha = 0.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        self.statusLabel.text = self.statusLabelTimeString;
        [self showStatusLabel:NO];
    }
    else if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeDownloading) {
        self.cancelView.alpha = 1.0f;
        self.downloadView.alpha = 0.0f;
        self.doneDownloadView.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = NO;
        self.retryDownloadView.alpha = 0.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        self.statusLabel.text = self.statusLabelTimeString;
        [self showStatusLabel:NO];
    }
    else if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeRetryUpload) {
        self.cancelView.alpha = 0.0f;
        self.downloadView.alpha = 0.0f;
        self.doneDownloadView.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = NO;
        self.retryDownloadView.alpha = 1.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        NSString *statusString = NSLocalizedStringFromTableInBundle(@"Failed to send, tap to retry", nil, [TAPUtil currentBundle], @"");
        self.statusLabel.text = statusString;
        [self showStatusLabel:YES];
        self.replyButton.alpha = 0.0f;
        self.replyButtonRightConstraint.constant = -28.0f;
        [self.contentView layoutIfNeeded];
    }
    else if (type == TAPMyVoiceNoteBubbleTableViewCellStateTypeRetryDownload) {
        self.cancelView.alpha = 0.0f;
        self.downloadView.alpha = 1.0f;
        self.doneDownloadView.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.alpha = 0.0f;
        self.doneDownloadTitleAndDescriptionButton.userInteractionEnabled = NO;
        self.retryDownloadView.alpha = 0.0f;
        self.retryIconImageView.alpha = 0.0f;
        self.retryButton.alpha = 0.0f;
        self.statusLabel.text = self.statusLabelTimeString;
        [self showStatusLabel:NO];
    }
}

- (void)showBubbleHighlight {
    self.bubbleHighlightView.alpha = 0.0f;
    [TAPUtil performBlock:^{
        [UIView animateWithDuration:0.2f animations:^{
            self.bubbleHighlightView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [TAPUtil performBlock:^{
                [UIView animateWithDuration:0.75f animations:^{
                    self.bubbleHighlightView.alpha = 0.0f;
                }];
            } afterDelay:1.0f];
        }];
    } afterDelay:0.2f];
}

- (void)showStarMessageView {
    if(self.starIconImageView.alpha == 0){
        self.starIconImageView.alpha = 1.0f;
    }
    else{
        self.starIconImageView.alpha = 0.0f;
    }
}

- (void)showCheckMarkIcon:(BOOL)isShow {
    if(isShow){
        self.checkMarkIconImageView.alpha = 1.0f;
        self.panGestureRecognizer.enabled = NO;
        self.bubbleViewLongPressGestureRecognizer.enabled = NO;
        self.forwardCheckmarkButton.alpha = 1.0f;
    }
    else{
        self.checkMarkIconImageView.alpha = 0.0f;
        self.panGestureRecognizer.enabled = YES;
        self.bubbleViewLongPressGestureRecognizer.enabled = YES;
        self.forwardCheckmarkButton.alpha = 0.0f; 
    }
}

- (void)setCheckMarkState:(BOOL)isSelected {
    if(isSelected){
        self.checkMarkIconImageView.image = [UIImage imageNamed:@"TAPIconSelected" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    }
    else{
        self.checkMarkIconImageView.image = [UIImage imageNamed:@"TAPIconUnselected" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        
    }
}

- (NSString *)secondToMinuteString:(NSInteger)second{
    NSInteger minute = second/60;
    NSInteger sec = second - (minute * 60);
    
    NSString *minuteString = [@(minute) stringValue];
    NSString *secondString = [@(sec) stringValue];;
    if(minute < 10){
        minuteString = [NSString stringWithFormat:@"0%ld", minute];
    }
    if(sec < 10){
        secondString = [NSString stringWithFormat:@"0%ld", sec];
    }
    
    return [NSString stringWithFormat:@"%@.%@", minuteString, secondString];
}


- (void)showSeperator{
    self.seperatorViewHeightConstraint.constant = 1.0f;
    self.statusLabelBottomConstraint.constant = 33.0f;
    for (UIGestureRecognizer *recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
}

@end
