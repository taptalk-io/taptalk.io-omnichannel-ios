//
//  TTLCreateCaseViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 09/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCreateCaseViewController.h"
#import "TTLCreateCaseView.h"
#import "TTLCustomDropDownTextFieldView.h"
#import "TTLTopicListViewController.h"

#import <TapTalk/TapTalk.h>
#import <TapTalk/TapUI.h>
#import <TapTalk/TapUIRoomListViewController.h>

@interface TTLCreateCaseViewController () <UIScrollViewDelegate, TTLCustomDropDownTextFieldViewDelegate, TTLFormGrowingTextViewDelegate, TTLCustomButtonViewDelegate, TTLTopicListViewControllerDelegate, TTLCustomTextFieldViewDelegate>

@property (strong, nonatomic) TTLCreateCaseView *createCaseView;

@property (strong, nonatomic) NSArray *topicListDataArray;
@property (strong, nonatomic) TTLTopicModel *selectedTopic;
@property (strong, nonatomic) NSString *obtainedFullNameString;
@property (strong, nonatomic) NSString *obtainedEmailString;
@property (strong, nonatomic) NSString *obtainedMessageString;
@property (nonatomic) BOOL isTopicSelected;

- (void)doneKeyboardButtonDidTapped;
- (void)handleSubmitCaseFormFlow;

@end

@implementation TTLCreateCaseViewController
#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    _createCaseView = [[TTLCreateCaseView alloc] initWithFrame:[TTLBaseView frameWithoutNavigationBar]];
    [self.view addSubview:self.createCaseView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.createCaseView.scrollView.delegate = self;
    self.createCaseView.fullNameTextField.delegate = self;
    self.createCaseView.emailTextField.delegate = self;
    self.createCaseView.topicDropDownView.delegate = self;
    self.createCaseView.messageTextView.delegate = self;
    self.createCaseView.createCaseButtonView.delegate = self;
    [self.createCaseView.keyboardAccessoryView.doneKeyboardButton addTarget:self action:@selector(doneKeyboardButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    
    //DV Note
    //Check if already logged-in do not show full name and email form
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    TTLUserModel *currentActiveUser = [TTLDataManager getActiveUser];
    NSString *currentActiveUserID = currentActiveUser.userID;
    currentActiveUserID = [TTLUtil nullToEmptyString:currentActiveUserID];
    if ([currentAccessToken isEqualToString:@""] || [currentActiveUserID isEqualToString:@""]) {
        [self.createCaseView showUserDataForm:NO];
    }
    //END DV Note
    
    _topicListDataArray = [[NSArray alloc] init];
    _selectedTopic = nil;
    
    //Obtain topic list
    [self.createCaseView.topicDropDownView setAsLoading:YES animated:YES];
    [TTLDataManager callAPIGetTopicListSuccess:^(NSArray<TTLTopicModel *> * _Nonnull topicListArray) {
        _topicListDataArray = topicListArray;
        [self.createCaseView.topicDropDownView setAsLoading:NO animated:YES];
    } failure:^(NSError * _Nonnull error) {
        [self.createCaseView.topicDropDownView setAsLoading:NO animated:YES];
    }];
}

#pragma mark - Delegate
#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

#pragma mark TTLCustomTextFieldView
- (BOOL)customTextFieldViewTextFieldShouldReturn:(UITextField *)textField {
    if (textField == self.createCaseView.fullNameTextField.textField) {
        [self.createCaseView.emailTextField.textField becomeFirstResponder];
    }
    else if (textField == self.createCaseView.emailTextField.textField) {
        [self.createCaseView.messageTextView.textView becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark TTLCustomDropDownTextFieldView
- (void)customDropDownTextFieldViewDidTapped {
    TTLTopicListViewController *topicListViewController = [[TTLTopicListViewController alloc] init];
    topicListViewController.delegate = self;
    topicListViewController.topicListArray = self.topicListDataArray;
    if (self.selectedTopic != nil) {
        topicListViewController.selectedTopic = self.selectedTopic;
    }
    
    UINavigationController *topicListNavigationController = [[UINavigationController alloc] initWithRootViewController:topicListViewController];
    [self.navigationController presentViewController:topicListNavigationController animated:YES completion:nil];
    
    //DV Temp
//    TTLRatingViewController *ratingViewController = [[TTLRatingViewController alloc] init];
//    UINavigationController *ratingNavigationController = [[UINavigationController alloc] initWithRootViewController:ratingViewController];
//    ratingNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self.navigationController presentViewController:ratingNavigationController animated:YES completion:nil];
    //END DV Temp
}

#pragma mark TTLFormGrowingTextView
- (void)formGrowingTextViewDidBeginEditing:(UITextView *)textView {
    [self.createCaseView setMessageTextViewAsActive:YES animated:YES];
}

- (void)formGrowingTextViewDidEndEditing:(UITextView *)textView {
    [self.createCaseView setMessageTextViewAsActive:NO animated:YES];
}

- (void)formGrowingTextView:(UITextView *)textView shouldChangeHeight:(CGFloat)height {
    [self.createCaseView adjustGrowingContentView];
}

#pragma mark TTLCustomButtonView
- (void)customButtonViewDidTappedButton {
    //DV Note - Validation checking
    NSString *fullNameTextFieldString = [self.createCaseView.fullNameTextField getText];
    fullNameTextFieldString = [fullNameTextFieldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *emailTextFieldString = [self.createCaseView.emailTextField getText];
    emailTextFieldString = [emailTextFieldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageTextViewString = [self.createCaseView.messageTextView getText];
    messageTextViewString = [messageTextViewString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _obtainedFullNameString = fullNameTextFieldString;
    _obtainedEmailString = emailTextFieldString;
    _obtainedMessageString = messageTextViewString;
    BOOL isEmailValid = [TTLUtil validateEmail:emailTextFieldString];

    if ([self.obtainedFullNameString isEqualToString:@""]) {
        //Validation failed - show error full name must be filled
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Full Name" title:NSLocalizedString(@"Error", @"") detailInformation:NSLocalizedString(@"Please enter your name", @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];
    }
    else if ([self.obtainedEmailString isEqualToString:@""]) {
        //Validation failed - show error email must be filled
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Email" title:NSLocalizedString(@"Error", @"") detailInformation:NSLocalizedString(@"Please enter your email", @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

    }
    else if (!isEmailValid) {
        //Validation failed - show error invalid email format
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Email Format" title:NSLocalizedString(@"Error", @"") detailInformation:NSLocalizedString(@"Email address format is invalid", @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

    }
    else if (!self.isTopicSelected) {
        //Validation failed - show error topic must be selected
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Topic" title:NSLocalizedString(@"Error", @"") detailInformation:NSLocalizedString(@"Please select your topic", @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

    }
    else if ([self.obtainedMessageString isEqualToString:@""]) {
        //Validation failed - show error message must be filled
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Message" title:NSLocalizedString(@"Error", @"") detailInformation:NSLocalizedString(@"Please enter your message", @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

    }
    else {
        //Validation success
        NSString *currentAccessToken = [TTLDataManager getAccessToken];
        TTLUserModel *currentActiveUser = [TTLDataManager getActiveUser];
        NSString *currentActiveUserID = currentActiveUser.userID;
        currentActiveUserID = [TTLUtil nullToEmptyString:currentActiveUserID];
        if (![currentAccessToken isEqualToString:@""] && ![currentActiveUserID isEqualToString:@""]) {
            [self handleSubmitCaseFormFlowAfterLogin];
        }
        else {
            [self handleSubmitCaseFormFlow];
        }
    }
}

#pragma mark TTLTopicListViewController
- (void)topicListViewControllerDidSelectTopicWithData:(TTLTopicModel *)selectedTopic {
    _isTopicSelected = YES;
    _selectedTopic = selectedTopic;
    NSString *topicName = self.selectedTopic.topicName;
    topicName = [TTLUtil nullToEmptyString:topicName];
    [self.createCaseView.topicDropDownView setTextFieldWithData:topicName];
}

#pragma mark - Custom Method
- (void)keyboardWillShowWithHeight:(CGFloat)keyboardHeight {
    [super keyboardWillShowWithHeight:keyboardHeight];
    [UIView animateWithDuration:0.2f animations:^{
        self.createCaseView.scrollView.frame = CGRectMake(CGRectGetMinX(self.createCaseView.scrollView.frame), CGRectGetMinY(self.createCaseView.scrollView.frame), CGRectGetWidth(self.createCaseView.scrollView.frame), CGRectGetHeight(self.createCaseView.frame) - keyboardHeight);
    }];
}

- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight {
    [super keyboardWillHideWithHeight:keyboardHeight];
    [UIView animateWithDuration:0.2f animations:^{
        self.createCaseView.scrollView.frame = [TTLBaseView frameWithoutNavigationBar];
    }];
}

- (void)popUpInfoDidTappedLeftButtonWithIdentifier:(NSString *)popupIdentifier {

}

- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)popupIdentifier {
    
}

- (void)doneKeyboardButtonDidTapped {
    [self.view endEditing:YES];
}

- (void)handleSubmitCaseFormFlow {
    [TTLDataManager callAPICreateUserWithFullName:self.obtainedFullNameString email:self.obtainedEmailString success:^(TTLUserModel * _Nonnull user, NSString * _Nonnull ticket) {
        //Get TapTalkLive access token
        [TTLDataManager callAPIGetAccessTokenWithTicket:ticket success:^{
            //Obtain TapTalk auth ticket
            [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:^(NSString * _Nonnull tapTalkAuthTicket) {
                //Authenticate TapTalk.io Chat SDK
                [[TapTalk sharedInstance] authenticateWithAuthTicket:tapTalkAuthTicket connectWhenSuccess:YES success:^{
                    //Call API create case
                    [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
                        
                        TapUIRoomListViewController *tapTalkRoomListViewController = [[TapUI sharedInstance] roomListViewController];
                        tapTalkRoomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        UINavigationController *tapTalkRoomListNavigationController = [[UINavigationController alloc] initWithRootViewController:tapTalkRoomListViewController];
                        [self.navigationController presentViewController:tapTalkRoomListNavigationController animated:YES completion:nil];
                        
                    } failure:^(NSError * _Nonnull error) {
                        //Error create case
                    }];
                } failure:^(NSError * _Nonnull error) {
                    //Error authenticate TapTalk.io Chat SDK
                }];
            } failure:^(NSError * _Nonnull error) {
                //Error get TapTalk auth ticket
            }];
        } failure:^(NSError * _Nonnull error) {
            //Error get access token
        }];
    } failure:^(NSError * _Nonnull error) {
        //Error create user
    }];
}

- (void)handleSubmitCaseFormFlowAfterLogin {
    BOOL isTapTalkAuthenticate = [TapTalk sharedInstance].isAuthenticated;
    if (isTapTalkAuthenticate) {
        //Call API create case
        [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
            
            TapUIRoomListViewController *tapTalkRoomListViewController = [[TapUI sharedInstance] roomListViewController];
            tapTalkRoomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UINavigationController *tapTalkRoomListNavigationController = [[UINavigationController alloc] initWithRootViewController:tapTalkRoomListViewController];
            [self.navigationController presentViewController:tapTalkRoomListNavigationController animated:YES completion:nil];
            
        } failure:^(NSError * _Nonnull error) {
            //Error create case
        }];
    }
    else {
        //Obtain TapTalk auth ticket
        [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:^(NSString * _Nonnull tapTalkAuthTicket) {
            //Authenticate TapTalk.io Chat SDK
            [[TapTalk sharedInstance] authenticateWithAuthTicket:tapTalkAuthTicket connectWhenSuccess:YES success:^{
                //Call API create case
                [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
                    
                    TapUIRoomListViewController *tapTalkRoomListViewController = [[TapUI sharedInstance] roomListViewController];
                    tapTalkRoomListViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    UINavigationController *tapTalkRoomListNavigationController = [[UINavigationController alloc] initWithRootViewController:tapTalkRoomListViewController];
                    [self.navigationController presentViewController:tapTalkRoomListNavigationController animated:YES completion:nil];
                    
                } failure:^(NSError * _Nonnull error) {
                    //Error create case
                }];
            } failure:^(NSError * _Nonnull error) {
                //Error authenticate TapTalk.io Chat SDK
            }];
        } failure:^(NSError * _Nonnull error) {
            //Error get TapTalk auth ticket
        }];
    }
}

@end
