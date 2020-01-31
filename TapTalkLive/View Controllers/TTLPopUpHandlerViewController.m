//
//  TTLPopUpHandlerViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 28/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLPopUpHandlerViewController.h"
#import "TTLPopUpInfoViewController.h"
#import <TapTalk/TapUIChatViewController.h>

@interface TTLPopUpHandlerViewController () <TTLPopUpInfoViewControllerDelegate>

@end

@implementation TTLPopUpHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma TTLPopUpInfoViewController
- (void)popUpInfoViewControllerDidTappedLeftButtonWithIdentifier:(NSString *)identifier {
    [self popUpInfoDidTappedLeftButtonWithIdentifier:identifier];
}

- (void)popUpInfoViewControllerDidTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)identifier {
    [self popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:identifier];
}

#pragma mark - Custom Method
- (void)showPopupViewWithPopupType:(TTLPopUpInfoViewControllerType)type popupIdentifier:(NSString *)popupIdentifier title:(NSString *)title detailInformation:(NSString *)detailInfo leftOptionButtonTitle:(NSString * __nullable)leftOptionString singleOrRightOptionButtonTitle:(NSString * __nullable)singleOrRightOptionString {
    
    TTLPopUpInfoViewController *popupInfoViewController = [[TTLPopUpInfoViewController alloc] init];
    popupInfoViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    popupInfoViewController.popupIdentifier = popupIdentifier;
    popupInfoViewController.delegate = self;
    [popupInfoViewController setPopUpInfoViewControllerType:type withTitle:title detailInformation:detailInfo leftOptionButtonTitle:leftOptionString singleOrRightOptionButtonTitle:singleOrRightOptionString];

    [self presentViewController:popupInfoViewController animated:NO completion:^{
    }];
}

- (void)popUpInfoDidTappedLeftButtonWithIdentifier:(NSString *)popupIdentifier {
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *activeViewController = [[TapTalkLive sharedInstance] getCurrentTapTalkLiveActiveViewController];
        if ([activeViewController isKindOfClass:[TapUIChatViewController class]]) {
            TapUIChatViewController *chatViewController = (TapUIChatViewController *)activeViewController;
            [chatViewController setKeyboardStateDefault];
        }
    }];
}

- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)popupIdentifier {
    if ([popupIdentifier isEqualToString:@"Custom Keyboard - Close Case Tapped"]) {
        //Mark as solved - close case
        NSString *formattedCaseID = self.room.xcRoomID;
        formattedCaseID = [TTLUtil nullToEmptyString:formattedCaseID];
                    
        NSString *caseID = [formattedCaseID stringByReplacingOccurrencesOfString:@"case:" withString:@""];
        caseID = [TTLUtil nullToEmptyString:caseID];
                
        #ifdef DEBUG
                NSLog(@"Close Case - Case ID: %@", caseID);
        #endif
                
        [TTLDataManager callAPICloseCaseWithCaseID:caseID success:^(BOOL isSuccess) {
            //Hide keyboard and input view
            [self dismissViewControllerAnimated:NO completion:nil];
            UIViewController *activeViewController = [[TapTalkLive sharedInstance] getCurrentTapTalkLiveActiveViewController];
            if ([activeViewController isKindOfClass:[TapUIChatViewController class]]) {
                TapUIChatViewController *chatViewController = (TapUIChatViewController *)activeViewController;
                [chatViewController hideTapTalkMessageComposerView];
            }
        } failure:^(NSError * _Nonnull error) {

        }];
    }
}

@end
