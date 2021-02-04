//
//  TTLRatingViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLRatingViewController.h"
#import "TTLRatingView.h"

@interface TTLRatingViewController () <TTLFormGrowingTextViewDelegate, TTLCustomButtonViewDelegate>

@property (strong, nonatomic) TTLRatingView *ratingView;

@property (nonatomic) BOOL isRatingStarTapped;
@property (nonatomic) BOOL isKeyboardActive;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) NSInteger starRatingValue;

- (void)closeButtonDidTapped;
- (void)firstStarRatingDidTapped;
- (void)secondStarRatingDidTapped;
- (void)thirdStarRatingDidTapped;
- (void)fourthStarRatingDidTapped;
- (void)fifthStarRatingDidTapped;

@end

@implementation TTLRatingViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    _ratingView = [[TTLRatingView alloc] initWithFrame:[TTLBaseView frameWithoutNavigationBar]];
    [self.view addSubview:self.ratingView];
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.alpha = 0.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

    _starRatingValue = 0;
    
    self.ratingView.commentTextView.delegate = self;
    self.ratingView.submitButtonView.delegate = self;
    
    [self.ratingView.backgroundDismissButton addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.closeButton addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.starRating1Button addTarget:self action:@selector(firstStarRatingDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.starRating2Button addTarget:self action:@selector(secondStarRatingDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.starRating3Button addTarget:self action:@selector(thirdStarRatingDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.starRating4Button addTarget:self action:@selector(fourthStarRatingDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingView.starRating5Button addTarget:self action:@selector(fifthStarRatingDidTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIView animateWithDuration:0.2f animations:^{
        self.view.alpha = 1.0f;
        [self.ratingView animateOpeningView];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Delegates
#pragma mark TTLFormGrowingTextView
- (void)formGrowingTextViewDidBeginEditing:(UITextView *)textView {
    [self.ratingView setCommentTextViewAsActive:YES animated:YES];
}

- (void)formGrowingTextViewDidEndEditing:(UITextView *)textView {
    [self.ratingView setCommentTextViewAsActive:NO animated:YES];
}

- (BOOL)formGrowingTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![newString isEqualToString:@""] && self.isRatingStarTapped) {
        [self.ratingView setSubmitButtonAsActive:YES];
    }

    return YES;
}

- (void)formGrowingTextView:(UITextView *)textView shouldChangeHeight:(CGFloat)height {
    CGFloat additionalHeight = 0.0f;
    if (self.isKeyboardActive) {
        additionalHeight = self.keyboardHeight;
    }
    [self.ratingView adjustGrowingContentViewWithAdditionalHeight:additionalHeight];
}

#pragma mark TTLCustomButtonView
- (void)customButtonViewDidTappedButton {
    //Submit button tapped
    [self.view endEditing:YES];
    [self.ratingView.submitButtonView setAsLoading:YES animated:YES];
    
    NSString *caseID = self.currentCase.caseID;
    caseID = [TTLUtil nullToEmptyString:caseID];
    
    NSString *additionalNotes = [self.ratingView.commentTextView getText];
    additionalNotes = [TTLUtil nullToEmptyString:additionalNotes];
    
    [TTLDataManager callAPIRateConversionWithCaseID:caseID rating:self.starRatingValue notes:additionalNotes success:^(BOOL isSuccess) {
        [self.ratingView.submitButtonView setAsLoading:NO animated:YES];
        
        if (isSuccess) {
            //Success
            [self closeButtonDidTapped];
        }
        else {
            //Failed
        }
    } failure:^(NSError * _Nonnull error) {
        [self.ratingView.submitButtonView setAsLoading:NO animated:YES];
    }];
    
    
}

#pragma mark - Custom Method
- (void)keyboardWillShowWithHeight:(CGFloat)keyboardHeight {
    if (self.isKeyboardActive) {
        return;
    }
    _isKeyboardActive = YES;
    _keyboardHeight = keyboardHeight;
    self.ratingView.containerView.frame = CGRectMake(CGRectGetMinX(self.ratingView.containerView.frame), CGRectGetMinY(self.ratingView.containerView.frame) - keyboardHeight, CGRectGetWidth(self.ratingView.containerView.frame), CGRectGetHeight(self.ratingView.containerView.frame));
}

- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight {
    if (!self.isKeyboardActive) {
        return;
    }
    _isKeyboardActive = NO;
    _keyboardHeight = keyboardHeight;
    self.ratingView.containerView.frame = CGRectMake(CGRectGetMinX(self.ratingView.containerView.frame), CGRectGetMinY(self.ratingView.containerView.frame) + keyboardHeight, CGRectGetWidth(self.ratingView.containerView.frame), CGRectGetHeight(self.ratingView.containerView.frame));
}

- (void)closeButtonDidTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)firstStarRatingDidTapped {
    _isRatingStarTapped = YES;
    _starRatingValue = 1;
    [self.ratingView setStarRatingWithValue:self.starRatingValue];
    [self.ratingView setSubmitButtonAsActive:YES];
}

- (void)secondStarRatingDidTapped {
    _isRatingStarTapped = YES;
    _starRatingValue = 2;
    [self.ratingView setStarRatingWithValue:self.starRatingValue];
    [self.ratingView setSubmitButtonAsActive:YES];
}

- (void)thirdStarRatingDidTapped {
    _isRatingStarTapped = YES;
    _starRatingValue = 3;
    [self.ratingView setStarRatingWithValue:self.starRatingValue];
    [self.ratingView setSubmitButtonAsActive:YES];
}

- (void)fourthStarRatingDidTapped {
    _isRatingStarTapped = YES;
    _starRatingValue = 4;
    [self.ratingView setStarRatingWithValue:self.starRatingValue];
    [self.ratingView setSubmitButtonAsActive:YES];
}

- (void)fifthStarRatingDidTapped {
    _isRatingStarTapped = YES;
    _starRatingValue = 5;
    [self.ratingView setStarRatingWithValue:self.starRatingValue];
    [self.ratingView setSubmitButtonAsActive:YES];
}

@end
