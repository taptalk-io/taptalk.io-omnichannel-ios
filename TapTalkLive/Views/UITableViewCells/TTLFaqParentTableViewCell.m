//
//  FaqParentTableViewCell.m
//  TapTalkLive
//
//  Created by Fikri on 3/8/23.
//

#import "TTLFaqParentTableViewCell.h"
#import "OneTalkLiveChat.h"

@import QuickLook;

@interface TTLFaqParentTableViewCell() <TTLImageViewDelegate, TAPMediaDetailViewControllerDelegate, ZSWTappableLabelTapDelegate, ZSWTappableLabelLongPressDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (strong, nonatomic) IBOutlet UIView *topHeaderContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *backButtonImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backButtonContainerHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *talkToAgentContainerView;
@property (strong, nonatomic) IBOutlet UIView *talkToAgentButtonView;
@property (strong, nonatomic) IBOutlet UIButton *talkToAgentButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *talkToAgentContainerHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *faqContainterView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqContainerTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqContainerBottomConstraint;

@property (strong, nonatomic) IBOutlet UILabel *faqLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *faqLabelBottomConstraint;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet TappableLabel *detailLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLabelTopConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *mediaPreviewLoadingImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mediaPreviewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mediaPreviewLoadingImageViewHeightConstraint;

@property (strong, nonatomic) IBOutlet TTLImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UIImageView *playButtonImageView;
@property (strong, nonatomic) IBOutlet UIView *playButtonView;
@property (strong, nonatomic) IBOutlet UIButton *thumbnailButton;
@property (strong, nonatomic) UIButton *thumbnailButton2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *thumbnailImageViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *fileContainerView;
@property (strong, nonatomic) IBOutlet UIView *fileStatusView;
@property (strong, nonatomic) IBOutlet UIView *fileProgressView;
@property (strong, nonatomic) IBOutlet UIImageView *fileStatusIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fileInfoLabel;
@property (strong, nonatomic) IBOutlet UIButton *fileButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fileContainerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fileInfoLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fileInfoLabelHeightConstraint;

@property (strong, nonatomic) TTLFaqModel *faqModel;
@property (strong, nonatomic) NSString * _Nullable mediaUrl;

// File
@property (strong, nonatomic) NSString * _Nullable filePath;
@property (strong, nonatomic) UIView *syncProgressSubView;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (nonatomic) CGFloat lastProgress;
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat pathWidth;
@property (nonatomic) CGFloat newProgress;
@property (nonatomic) NSInteger updateInterval;

@end

@implementation TTLFaqParentTableViewCell

#pragma mark - Lifecycle

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
    
    self.detailLabel.tapDelegate = self;
    self.detailLabel.longPressDelegate = self;
    self.detailLabel.longPressDuration = 0.2f;
    
    [self.talkToAgentButton setTitleColor:[[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorBorderedButtonLabel] forState:UIControlStateNormal];
    self.talkToAgentButton.titleLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontBorderedButtonLabel];
    UIImage *talkToAgentIcon = [UIImage imageNamed:@"TTLIconMessage" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    talkToAgentIcon = [talkToAgentIcon setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconPrimary]];
    [self.talkToAgentButton setImage:talkToAgentIcon forState:UIControlStateNormal];
    
    self.talkToAgentButtonView.layer.cornerRadius = 8.0f;
    self.talkToAgentButtonView.layer.borderWidth = 1.0f;
    self.talkToAgentButtonView.layer.borderColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary].CGColor;
    
    UIImage *backButtonImage = self.backButtonImageView.image;
    self.backButtonImageView.image = [backButtonImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
    
    self.thumbnailImageView.layer.cornerRadius = 8.0f;
    self.thumbnailImageView.clipsToBounds = YES;
    self.thumbnailImageView.delegate = self;
    self.playButtonView.layer.cornerRadius = 16.0f;
    self.playButtonView.clipsToBounds = YES;
    UIImage *playButtonImage = [UIImage imageNamed:@"TAPIconPlayWhite" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
    self.playButtonImageView.image = [playButtonImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
    [self.thumbnailButton addTarget:self action:@selector(thumbnailButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.fileContainerView.layer.cornerRadius = 8.0f;
    self.fileContainerView.clipsToBounds = YES;
    self.fileStatusView.layer.cornerRadius = 8.0f;
    self.fileStatusView.clipsToBounds = YES;
    self.fileStatusView.backgroundColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
    self.fileNameLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFileNameLabel];
    self.fileNameLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFileNameLabel];
    self.fileInfoLabel.font = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontFileInfoLabel];
    self.fileInfoLabel.textColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorFileInfoLabel];
    [self.fileButton addTarget:self action:@selector(fileButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _startAngle = M_PI * 1.5;
    _endAngle = self.startAngle + (M_PI * 2);
    _borderWidth = 0.0f;
    _pathWidth = 4.0f;
    _newProgress = 0.0f;
    _updateInterval = 1;
    _syncProgressSubView = [[UIView alloc] initWithFrame:self.fileProgressView.bounds];
    [self.fileProgressView addSubview:self.syncProgressSubView];
}

#pragma mark - TTLImageViewDelegate

- (void)imageViewDidFinishLoadImage:(TTLImageView *)imageView {
    [self loadThumbnailImage:imageView.image];
}

#pragma mark - TAPMediaDetailViewControllerDelegate

- (void)mediaDetailViewControllerDidFinishClosingAnimation {
    self.thumbnailImageView.alpha = 1.0f;
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller {
    return 1;
}

- (id <QLPreviewItem>) previewController:(QLPreviewController *)controller previewItemAtIndex: (NSInteger) index {
    NSURL *fileUrl = [NSURL fileURLWithPath:self.filePath];
    return fileUrl;
}

#pragma mark - QLPreviewControllerDelegate

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
    return YES;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    
}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(TappableLabel *)tappableLabel
        tappedAtIndex:(NSInteger)idx
       withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes {
    
    NSTextCheckingResult *result = attributes[@"NSTextCheckingResult"];
    if (result) {
        switch (result.resultType) {
            case NSTextCheckingTypePhoneNumber:
                if ([self.delegate respondsToSelector:@selector(faqParentPhoneDidTapped:)]) {
                    [self.delegate faqParentPhoneDidTapped:result.phoneNumber];
                }
                break;
            case NSTextCheckingTypeLink:
                if ([result.URL.scheme.lowercaseString isEqualToString:@"mailto"]) {
                    if ([self.delegate respondsToSelector:@selector(faqParentEmailDidTapped:)]) {
                        [self.delegate faqParentEmailDidTapped:result.URL];
                    }
                }
                else {
                    if ([self.delegate respondsToSelector:@selector(faqParentUrlDidTapped:)]) {
                        [self.delegate faqParentUrlDidTapped:result.URL];
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
                if ([self.delegate respondsToSelector:@selector(faqParentPhoneDidLongPressed:)]) {
                    [self.delegate faqParentPhoneDidLongPressed:result.phoneNumber];
                }
                break;
            case NSTextCheckingTypeLink:
                if ([result.URL.scheme.lowercaseString isEqualToString:@"mailto"]) {
                    if ([self.delegate respondsToSelector:@selector(faqParentEmailDidLongPressed:)]) {
                        [self.delegate faqParentEmailDidLongPressed:result.URL];
                    }
                }
                else {
                    if ([self.delegate respondsToSelector:@selector(faqParentUrlDidLongPressed:)]) {
                        [self.delegate faqParentUrlDidLongPressed:result.URL];
                    }
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Custom Methods

- (void)setFaqParentData:(TTLFaqModel *)faqModel {
    _faqModel = faqModel;
    
    self.titleLabel.text = faqModel.title;
    
    // Content
    if (![TTLUtil isEmptyString:faqModel.content]) {
        [self setContentText:faqModel.content];
    }
    else if (![TTLUtil isEmptyString:faqModel.apiURL]) {
        if (![TTLUtil isEmptyString:faqModel.contentResponse]) {
            NSDictionary *contentResponseDictionary = [TTLUtil jsonObjectFromString:faqModel.contentResponse];
            contentResponseDictionary = [TTLUtil nullToEmptyDictionary:contentResponseDictionary];
            NSString *type = [contentResponseDictionary objectForKey:@"type"];
            type = [TTLUtil nullToEmptyString:type];
            if ([type isEqualToString:MESSAGE_TYPE_STRING_TEXT]) {
                NSDictionary *textDictionary = [contentResponseDictionary objectForKey:type];
                textDictionary = [TTLUtil nullToEmptyDictionary:textDictionary];
                NSString *body = [textDictionary objectForKey:@"body"];
                body = [TTLUtil nullToEmptyString:body];
                [self setContentText:body];
            }
            else if ([type isEqualToString:MESSAGE_TYPE_STRING_IMAGE] ||
                     [type isEqualToString:MESSAGE_TYPE_STRING_VIDEO] ||
                     [type isEqualToString:MESSAGE_TYPE_STRING_FILE] ||
                     [type isEqualToString:MESSAGE_TYPE_STRING_DOCUMENT]
            ) {
                NSDictionary *mediaDictionary = [contentResponseDictionary objectForKey:type];
                mediaDictionary = [TTLUtil nullToEmptyDictionary:mediaDictionary];
                NSString *caption = [mediaDictionary objectForKey:@"caption"];
                caption = [TTLUtil nullToEmptyString:caption];
                [self setContentText:caption];
            }
            else {
                self.detailLabel.text = @"";
            }
        }
        else if ([TapTalkLive.sharedInstance.loadingContentResponseArray containsObject:faqModel.apiURL]) {
            self.detailLabel.text = @"";
        }
        else {
            [self setContentText:faqModel.contentOnAPIError];
        }
    }
    else {
        self.detailLabel.text = @"";
    }
    if (![TTLUtil isEmptyString:self.detailLabel.text]) {
        self.detailLabelTopConstraint.constant = 12.0f;
    }
    else {
        self.detailLabelTopConstraint.constant = 0.0f;
    }
    
    if ([faqModel.type isEqualToString:FAQ_TALK_TO_AGENT]) {
        [self showTalkToAgentView:YES];
    }
    else {
        [self showTalkToAgentView:NO];
    }
    
    // Media Preview
    if (![TTLUtil isEmptyString:faqModel.apiURL] && ![TTLUtil isEmptyString:faqModel.contentResponse]) {
        NSDictionary *contentResponseDictionary = [TTLUtil jsonObjectFromString:faqModel.contentResponse];
        contentResponseDictionary = [TTLUtil nullToEmptyDictionary:contentResponseDictionary];
        NSString *type = [contentResponseDictionary objectForKey:@"type"];
        type = [TTLUtil nullToEmptyString:type];
        if ([type isEqualToString:MESSAGE_TYPE_STRING_IMAGE] || [type isEqualToString:MESSAGE_TYPE_STRING_VIDEO]) {
            NSDictionary *mediaDictionary = [contentResponseDictionary objectForKey:type];
            mediaDictionary = [TTLUtil nullToEmptyDictionary:mediaDictionary];
            NSString *url = [mediaDictionary objectForKey:@"url"];
            url = [TTLUtil nullToEmptyString:url];
            _mediaUrl = url;
            if (![TTLUtil isEmptyString:url]) {
                // Show image/video thumbnail
                self.thumbnailImageView.alpha = 1.0f;
                self.thumbnailButton.alpha = 1.0f;
                self.thumbnailButton.userInteractionEnabled = YES;
                if ([type isEqualToString:MESSAGE_TYPE_STRING_VIDEO]) {
                    [TAPUtil fetchVideoMetadataWithRemoteURL:url success:^(UIImage * _Nullable thumbnail, NSNumber * _Nonnull size, NSNumber * _Nonnull width, NSNumber * _Nonnull height, NSNumber * _Nonnull duration) {
                        [self loadThumbnailImage:thumbnail];
                    }];
                    self.playButtonView.alpha = 1.0f;
                }
                else {
                    [self.thumbnailImageView setImageWithURLString:url];
                    self.playButtonView.alpha = 0.0f;
                }
            }
            else {
                // Hide thumbnail
                self.thumbnailImageView.alpha = 0.0f;
                self.mediaPreviewTopConstraint.constant = 0.0f;
                self.playButtonView.alpha = 0.0f;
                self.thumbnailButton.alpha = 0.0f;
                self.thumbnailButton.userInteractionEnabled = NO;
            }
            // Hide file preview
            self.fileContainerView.alpha = 0.0f;
            self.fileContainerViewHeightConstraint.constant = 0.0f;
        }
        else if ([type isEqualToString:MESSAGE_TYPE_STRING_FILE] || [type isEqualToString:MESSAGE_TYPE_STRING_DOCUMENT]) {
            self.fileContainerView.alpha = 1.0f;
            self.fileContainerViewHeightConstraint.constant = 56.0f;
            NSDictionary *mediaDictionary = [contentResponseDictionary objectForKey:type];
            mediaDictionary = [TTLUtil nullToEmptyDictionary:mediaDictionary];
            NSString *url = [mediaDictionary objectForKey:@"url"];
            url = [TTLUtil nullToEmptyString:url];
            _mediaUrl = url;
            if (![TTLUtil isEmptyString:url]) {
                // Show file preview
                self.mediaPreviewTopConstraint.constant = 12.0f;
                NSString *filename = [mediaDictionary objectForKey:@"filename"];
                filename = [TTLUtil nullToEmptyString:filename];
                if (![TTLUtil isEmptyString:filename]) {
                    self.fileNameLabel.text = filename;
                }
                else {
                    self.fileNameLabel.text = MESSAGE_TYPE_STRING_DOCUMENT;
                }
                
                NSNumber *size = [mediaDictionary objectForKey:@"size"];
                size = [TTLUtil nullToEmptyNumber:size];
                if (size.longValue > 0L) {
                    // Show file info
                    self.fileInfoLabel.text = [NSByteCountFormatter stringFromByteCount:[size integerValue] countStyle:NSByteCountFormatterCountStyleBinary];
                    self.fileInfoLabelTopConstraint.constant = 3.0f;
                    self.fileInfoLabelHeightConstraint.constant = 16.0f;
                }
                else {
                    // Hide file info
                    self.fileInfoLabel.text = @"";
                    self.fileInfoLabelTopConstraint.constant = 0.0f;
                    self.fileInfoLabelHeightConstraint.constant = 0.0f;
                }
                
                NSString *fileKey = [[url componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
                _filePath = [[TAPFileDownloadManager sharedManager] getDownloadedFilePathWithRoomID:@"" fileID:fileKey];
                [self updateFileIcon];
            }
            else {
                // Hide file preview
                self.mediaPreviewTopConstraint.constant = 0.0f;
                self.fileContainerView.alpha = 0.0f;
                self.fileContainerViewHeightConstraint.constant = 0.0f;
            }
            // Hide thumbnail
            self.thumbnailImageView.alpha = 0.0f;
            self.playButtonView.alpha = 0.0f;
            self.thumbnailButton.alpha = 0.0f;
            self.thumbnailButton.userInteractionEnabled = NO;
        }
        else {
            // Hide media
            self.thumbnailImageView.alpha = 0.0f;
            self.mediaPreviewTopConstraint.constant = 0.0f;
            self.playButtonView.alpha = 0.0f;
            self.thumbnailButton.alpha = 0.0f;
            self.thumbnailButton.userInteractionEnabled = NO;
            self.fileContainerView.alpha = 0.0f;
            self.fileContainerViewHeightConstraint.constant = 0.0f;
        }
        // Hide loading
        self.mediaPreviewLoadingImageView.alpha = 0.0f;
        self.mediaPreviewLoadingImageViewHeightConstraint.constant = 0.0f;
        [TTLUtil removeSpinAnimation:self.mediaPreviewLoadingImageView];
    }
    else {
        // Hide media
        self.thumbnailImageView.alpha = 0.0f;
        self.playButtonView.alpha = 0.0f;
        self.thumbnailButton.alpha = 0.0f;
        self.thumbnailButton.userInteractionEnabled = NO;
        self.fileContainerView.alpha = 0.0f;
        self.fileContainerViewHeightConstraint.constant = 0.0f;
        
        if ([[TapTalkLive sharedInstance].loadingContentResponseArray containsObject:faqModel.apiURL]) {
            // Show loading
            self.mediaPreviewLoadingImageView.alpha = 1.0f;
            self.mediaPreviewTopConstraint.constant = 12.0f;
            self.mediaPreviewLoadingImageViewHeightConstraint.constant = 24.0f;
            [TTLUtil addSpinAnimation:self.mediaPreviewLoadingImageView];
        }
        else {
            // Hide loading
            self.mediaPreviewLoadingImageView.alpha = 0.0f;
            self.mediaPreviewTopConstraint.constant = 0.0f;
            self.mediaPreviewLoadingImageViewHeightConstraint.constant = 0.0f;
            [TTLUtil removeSpinAnimation:self.mediaPreviewLoadingImageView];
        }
    }
}

- (void)setContentText:(NSString *)content {
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
    NSDataDetector *phoneNumberDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:NULL];
    UIColor *highlightedUrlColor = [[TAPStyleManager sharedManager] getTextColorForType:TAPTextColorLeftBubbleMessageBodyURLHighlighted];
    UIColor *defaultUrlColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorPrimary];
    NSString *contentText = content;
    
    // Fix last line truncated
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n\n" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:contentText options:0 range:NSMakeRange(0, [contentText length])];
    if (numberOfMatches > 0) {
        contentText = [contentText stringByAppendingString:@"\n"];
    }
    
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
}

- (void)loadThumbnailImage:(UIImage * _Nullable)image {
    if (image != nil) {
        CGFloat imageViewHeight = CGRectGetWidth(self.thumbnailImageView.frame) / image.size.width * image.size.height;
        self.mediaPreviewTopConstraint.constant = 12.0f;
        self.thumbnailImageViewHeightConstraint.constant = imageViewHeight;
        [self refreshCellHeight];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnailImageView.image = image;
        [self layoutIfNeeded];
    }
    else {
        self.thumbnailImageView.alpha = 0.0f;
        self.mediaPreviewTopConstraint.constant = 0.0f;
        self.thumbnailImageViewHeightConstraint.constant = 0.0f;
    }
}

- (void)hideHeaderView {
    self.backButtonContainerHeightConstraint.constant = 0.0f;
    self.topHeaderContainerView.alpha = 0.0f;
    self.faqContainerTopConstraint.constant = 0.0f;
}

- (void)hideFaqLabel {
    self.faqLabel.text = @"";
    self.faqLabelHeightConstraint.constant = 0.0f;
    self.faqLabelBottomConstraint.constant = 0.0f;
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

- (void)updateFileIcon {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fileStatusIconImageView.alpha = 1.0f;
        self.fileProgressView.alpha = 0.0f;
        
        UIImage *fileIconImage;
        if ([TTLUtil isEmptyString:self.filePath]) {
            fileIconImage = [UIImage imageNamed:@"TAPIconDownload" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        }
        else {
            fileIconImage = [UIImage imageNamed:@"TAPIconDocumentShared" inBundle:[TAPUtil currentBundle] compatibleWithTraitCollection:nil];
        }
        self.fileStatusIconImageView.image = [fileIconImage setImageTintColor:[[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite]];
        
        self.lastProgress = 0.0f;
        self.progressLayer.strokeEnd = 0.0f;
        self.progressLayer.strokeStart = 0.0f;
        [self.progressLayer removeAllAnimations];
        [self.syncProgressSubView removeFromSuperview];
        _progressLayer = nil;
        _syncProgressSubView = nil;
    });
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

- (void)thumbnailButtonDidTapped {
    if (self.navigationController == nil) {
        return;
    }
    
    NSDictionary *contentResponseDictionary = [TTLUtil jsonObjectFromString:self.faqModel.contentResponse];
    contentResponseDictionary = [TTLUtil nullToEmptyDictionary:contentResponseDictionary];
    NSString *type = [contentResponseDictionary objectForKey:@"type"];
    type = [TTLUtil nullToEmptyString:type];
    
    if ([TTLUtil isEmptyString:self.mediaUrl]) {
        NSDictionary *mediaDictionary = [contentResponseDictionary objectForKey:type];
        mediaDictionary = [TTLUtil nullToEmptyDictionary:mediaDictionary];
        _mediaUrl = [mediaDictionary objectForKey:@"url"];
        _mediaUrl = [TTLUtil nullToEmptyString:self.mediaUrl];
    }
    
    TAPMessageModel *message = [self generateTapMessageModelFromFaq];
    
    if ([type isEqualToString:MESSAGE_TYPE_STRING_IMAGE] && self.thumbnailImageView.image != nil) {
        // Show image detail preview
        UIImage *thumbnailImage = self.thumbnailImageView.image;
        CGPoint thumbnailPoint = [self.thumbnailImageView.superview convertPoint:self.thumbnailImageView.frame.origin toView:nil];
        CGRect thumbnailRect = CGRectMake(
            thumbnailPoint.x,
            thumbnailPoint.y,
            CGRectGetWidth(self.thumbnailImageView.frame),
            CGRectGetHeight(self.thumbnailImageView.frame)
        );
        
        TAPMediaDetailViewController *mediaDetailViewController = [[TAPMediaDetailViewController alloc] init];
        [mediaDetailViewController setMediaDetailViewControllerType:TAPMediaDetailViewControllerTypeImage];
        mediaDetailViewController.delegate = self;
        mediaDetailViewController.message = message;
        [mediaDetailViewController setThumbnailImageArray:@[thumbnailImage]];
        [mediaDetailViewController setImageArray:@[thumbnailImage]];
        [mediaDetailViewController setActiveIndex:0];        
        [mediaDetailViewController showToViewController:self.navigationController
                                         thumbnailImage:thumbnailImage
                                         thumbnailFrame:thumbnailRect];
        self.thumbnailImageView.alpha = 0.0f;
    }
    else if ([type isEqualToString:MESSAGE_TYPE_STRING_VIDEO]) {
        // Play video
        NSURL *videoUrl = [[NSURL alloc]initWithString:self.mediaUrl];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
        AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *avPlayer = [AVPlayer playerWithPlayerItem:avPlayerItem];
        AVPlayerViewController *avPlayerViewController = [[AVPlayerViewController alloc]init];
        avPlayerViewController.player = avPlayer;
        avPlayerViewController.showsPlaybackControls = YES;
        [self.navigationController presentViewController:avPlayerViewController animated:YES completion:nil];
        [avPlayer play];
    }
}

- (void)fileButtonDidTapped {
    if ([TTLUtil isEmptyString:self.filePath] && self.fileStatusIconImageView.alpha == 1.0f) {
        // Download file
        TAPMessageModel *message = [self generateTapMessageModelFromFaq];
        
        [[TAPCoreMessageManager sharedManager] downloadMessageFile:message
        start:^{
            
        }
        progress:^(TAPMessageModel * _Nonnull message, CGFloat progress, CGFloat total) {
            [self setFileDownloadProgress:progress total:total];
        }
        success:^(TAPMessageModel * _Nonnull message, NSData * _Nonnull fileData, NSString * _Nonnull filePath) {
            _filePath = filePath;
            [self updateFileIcon];
        }
        failure:^(TAPMessageModel * _Nullable message, NSError * _Nonnull error) {
            [self updateFileIcon];
        }];
    }
    else if (![TTLUtil isEmptyString:self.filePath] && self.navigationController != nil) {
        // Open file
        QLPreviewController *preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        preview.delegate = self;
        [self.navigationController presentViewController:preview animated:YES completion:nil];
    }
}

- (TAPMessageModel *)generateTapMessageModelFromFaq {
    NSDictionary *contentResponseDictionary = [TTLUtil jsonObjectFromString:self.faqModel.contentResponse];
    contentResponseDictionary = [TTLUtil nullToEmptyDictionary:contentResponseDictionary];
    NSString *type = [contentResponseDictionary objectForKey:@"type"];
    type = [TTLUtil nullToEmptyString:type];
    NSDictionary *mediaDictionary = [contentResponseDictionary objectForKey:type];
    mediaDictionary = [TTLUtil nullToEmptyDictionary:mediaDictionary];
    NSString *url = [mediaDictionary objectForKey:@"url"];
    url = [TTLUtil nullToEmptyString:url];
    NSString *filename = [mediaDictionary objectForKey:@"filename"];
    filename = [TTLUtil nullToEmptyString:filename];
    NSNumber *size = [mediaDictionary objectForKey:@"size"];
    size = [TTLUtil nullToEmptyNumber:size];
    
    TAPMessageModel *message = [TAPMessageModel new];
    message.localID = [NSString stringWithFormat:@"%@", self.faqModel.itemID];
    message.created = self.faqModel.createdTime;
    if ([type isEqualToString:MESSAGE_TYPE_STRING_IMAGE]) {
        message.type = TAPChatMessageTypeImage;
    }
    else if ([type isEqualToString:MESSAGE_TYPE_STRING_VIDEO]) {
        message.type = TAPChatMessageTypeVideo;
    }
    else if ([type isEqualToString:MESSAGE_TYPE_STRING_FILE] || [type isEqualToString:MESSAGE_TYPE_STRING_DOCUMENT]) {
        message.type = TAPChatMessageTypeFile;
    }
    else {
        message.type = TAPChatMessageTypeText;
    }
    TAPUserModel *user = [TAPUserModel new];
    user.fullname = self.faqModel.title;
    message.user = user;
    TAPRoomModel *room = [TAPRoomModel new];
    room.roomID = @"";
    message.room = room;
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:url forKey:@"url"];
    [data setObject:@"" forKey:@"fileID"];
    [data setObject:filename forKey:@"fileName"];
    [data setObject:size forKey:@"size"];
    NSString *mediaType = [TAPUtil mimeTypeForFileWithExtension:[url pathExtension]];
    if ([TTLUtil isEmptyString:mediaType]) {
        if (message.type == TAPChatMessageTypeImage) {
            mediaType = @"image/jpeg";
        }
        else if (message.type == TAPChatMessageTypeVideo) {
            mediaType = @"video/mp4";
        }
        else if (message.type == TAPChatMessageTypeVoice) {
            mediaType = @"audio/mp3";
        }
        else {
            mediaType = @"application/octet-stream";
        }
    }
    [data setObject:mediaType forKey:@"mediaType"];
    message.data = data;
    
    return message;
}

- (void)setFileDownloadProgress:(CGFloat)progress total:(CGFloat)total {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fileStatusIconImageView.alpha = 0.0f;
        self.fileProgressView.alpha = 1.0f;
        
        CGFloat lastProgress = self.lastProgress;
        _newProgress = progress/total;
        
        NSInteger lastPercentage = (NSInteger)floorf((100.0f * lastProgress));
        //Circular Progress Bar using CAShapeLayer and UIBezierPath
        _progressLayer = [CAShapeLayer layer];
        [self.progressLayer setFrame:self.fileProgressView.bounds];
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.fileProgressView.bounds), CGRectGetMidY(self.fileProgressView.bounds)) radius:(self.fileProgressView.bounds.size.height - self.borderWidth - self.pathWidth) / 2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        
        self.progressLayer.lineCap = kCALineCapRound;
        self.progressLayer.strokeColor = [[TTLStyleManager sharedManager] getDefaultColorForType:TTLDefaultColorIconWhite].CGColor;
        self.progressLayer.lineWidth = 3.0f;
        self.progressLayer.path = progressPath.CGPath;
        self.progressLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.progressLayer.fillColor = [UIColor clearColor].CGColor;
        self.progressLayer.position = CGPointMake(self.fileProgressView.layer.frame.size.width / 2 - self.borderWidth / 2, self.fileProgressView.layer.frame.size.height / 2 - self.borderWidth / 2);
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
    });
}

@end
