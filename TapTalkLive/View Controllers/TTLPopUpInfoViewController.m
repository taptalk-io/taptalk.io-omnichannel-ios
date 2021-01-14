//
//  TTLPopUpInfoViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLPopUpInfoViewController.h"

@interface TTLPopUpInfoViewController ()

@property (strong, nonatomic) NSString *leftOptionButtonString;
@property (strong, nonatomic) NSString *singleOrRightOptionButtonString;

- (void)popUpInfoViewHandleDidTappedLeftButton;
- (void)popUpInfoViewHandleDidTappedRightButton;

@end

@implementation TTLPopUpInfoViewController

#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    
    _popUpInfoView = [[TTLPopUpInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.popUpInfoView.leftButton addTarget:self action:@selector(popUpInfoViewHandleDidTappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.popUpInfoView.rightButton addTarget:self action:@selector(popUpInfoViewHandleDidTappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.popUpInfoView.alpha = 0.0f;
    [self.view addSubview:self.popUpInfoView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.popUpInfoViewControllerType == TTLPopUpInfoViewControllerTypeErrorMessage) {
        [self.popUpInfoView setPopupInfoViewType:TTLPopupInfoViewTypeErrorMessage withTitle:self.titleInformation detailInformation:self.detailInformation leftOptionButtonTitle:self.leftOptionButtonString singleOrRightOptionButtonTitle:self.singleOrRightOptionButtonString];
        [self.popUpInfoView isShowTwoOptionButton:NO];
    }
    else if (self.popUpInfoViewControllerType == TTLPopUpInfoViewControllerTypeSuccessMessage) {
        [self.popUpInfoView setPopupInfoViewType:TTLPopupInfoViewTypeSuccessMessage withTitle:self.titleInformation detailInformation:self.detailInformation leftOptionButtonTitle:self.leftOptionButtonString singleOrRightOptionButtonTitle:self.singleOrRightOptionButtonString];
        [self.popUpInfoView isShowTwoOptionButton:NO];
    }
    else if (self.popUpInfoViewControllerType == TTLPopUpInfoViewControllerTypeInfoDefault) {
        [self.popUpInfoView setPopupInfoViewType:TTLPopupInfoViewTypeInfoDefault withTitle:self.titleInformation detailInformation:self.detailInformation leftOptionButtonTitle:self.leftOptionButtonString singleOrRightOptionButtonTitle:self.singleOrRightOptionButtonString];
        [self.popUpInfoView isShowTwoOptionButton:YES];
    }
    else if (self.popUpInfoViewControllerType == TTLPopUpInfoViewControllerTypeInfoDestructive) {
        [self.popUpInfoView setPopupInfoViewType:TTLPopupInfoViewTypeInfoDestructive withTitle:self.titleInformation detailInformation:self.detailInformation leftOptionButtonTitle:self.leftOptionButtonString singleOrRightOptionButtonTitle:self.singleOrRightOptionButtonString];
        [self.popUpInfoView isShowTwoOptionButton:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showPopupInfoView:YES animated:YES completion:^{
    }];
}

#pragma mark - Custom Method
- (void)popUpInfoViewHandleDidTappedLeftButton {
    [self showPopupInfoView:NO animated:YES completion:^{
        [self dismissViewControllerAnimated:NO completion:^{
            if ([self.delegate respondsToSelector:@selector(popUpInfoViewControllerDidTappedLeftButtonWithIdentifier:)]) {
                [self.delegate popUpInfoViewControllerDidTappedLeftButtonWithIdentifier:self.popupIdentifier];
            }
        }];
    }];
    
}

- (void)popUpInfoViewHandleDidTappedRightButton {
    [self showPopupInfoView:NO animated:YES completion:^{
        [self dismissViewControllerAnimated:NO completion:^{
            if ([self.delegate respondsToSelector:@selector(popUpInfoViewControllerDidTappedSingleButtonOrRightButtonWithIdentifier:)]) {
                [self.delegate popUpInfoViewControllerDidTappedSingleButtonOrRightButtonWithIdentifier:self.popupIdentifier];
            }
        }];
    }];
}

- (void)setPopUpInfoViewControllerType:(TTLPopUpInfoViewControllerType)popUpInfoViewControllerType withTitle:(NSString *)title detailInformation:(NSString *)detailInfo leftOptionButtonTitle:(NSString * __nullable)leftOptionTitle singleOrRightOptionButtonTitle:(NSString * __nullable)singleOrRightOptionTitle {
    _popUpInfoViewControllerType = popUpInfoViewControllerType;
    _titleInformation = title;
    _detailInformation = detailInfo;
    
    if (leftOptionTitle == nil) {
        _leftOptionButtonString = NSLocalizedStringFromTableInBundle(@"Cancel", nil, [TTLUtil currentBundle], @"");
    }
    else {
        _leftOptionButtonString = leftOptionTitle;
    }
    
    if (singleOrRightOptionTitle == nil) {
        _singleOrRightOptionButtonString = NSLocalizedStringFromTableInBundle(@"OK", nil, [TTLUtil currentBundle], @"");
    }
    else {
        _singleOrRightOptionButtonString = singleOrRightOptionTitle;
    }
}

- (void)showPopupInfoView:(BOOL)isShow animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        if (isShow) {
            [UIView animateWithDuration:0.2f animations:^{
                self.popUpInfoView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                completion();
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^{
                self.popUpInfoView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                completion();
            }];
        }
    }
    else {
        if (isShow) {
            self.popUpInfoView.alpha = 1.0f;
            completion();
        }
        else {
            self.popUpInfoView.alpha = 0.0f;
            completion();
        }
    }
}

@end
