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
#import <TapTalk/TAPCoreChatRoomManager.h>

@interface TTLCreateCaseViewController () <UIScrollViewDelegate, TTLCustomDropDownTextFieldViewDelegate, TTLFormGrowingTextViewDelegate, TTLCustomButtonViewDelegate, TTLTopicListViewControllerDelegate, TTLCustomTextFieldViewDelegate>

@property (strong, nonatomic) TTLCreateCaseView *createCaseView;

@property (strong, nonatomic) NSArray *topicListDataArray;
@property (strong, nonatomic) TTLTopicModel *selectedTopic;
@property (strong, nonatomic) NSString *obtainedFullNameString;
@property (strong, nonatomic) NSString *obtainedEmailString;
@property (strong, nonatomic) NSString *obtainedMessageString;
@property (nonatomic) BOOL isTopicSelected;
@property (nonatomic) BOOL isKeyboardShown;

- (void)closeButtonDidTapped;
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
    [self.createCaseView.closeButton addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.createCaseView.leftCloseButton addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    //DV Note
    //Check if already logged-in do not show full name and email form
    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    TTLUserModel *currentActiveUser = [TTLDataManager getActiveUser];
    NSString *currentActiveUserID = currentActiveUser.userID;
    currentActiveUserID = [TTLUtil nullToEmptyString:currentActiveUserID];
    if ([currentAccessToken isEqualToString:@""] || [currentActiveUserID isEqualToString:@""]) {
        [self.createCaseView showUserDataForm:YES];
    }
    else {
        [self.createCaseView showUserDataForm:NO];
    }
    //END DV Note
    
    if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
        [self.createCaseView setCreateCaseViewType:TTLCreateCaseViewTypeNewMessage];
        [self.createCaseView showCloseButton:NO];
    }
    else {
        [self.createCaseView setCreateCaseViewType:TTLCreateCaseViewTypeDefault];
        
        id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
//        if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCreateCaseViewWithCurrentShownNavigationController:)]) {
//            //Show Close Button
            [self.createCaseView showCloseButton:YES];
//        }
//        else {
//            [self.createCaseView showCloseButton:NO];
//        }
    }

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
    [self.createCaseView.emailTextField.textField resignFirstResponder];
    TTLTopicListViewController *topicListViewController = [[TTLTopicListViewController alloc] init];
    topicListViewController.delegate = self;
    topicListViewController.topicListArray = self.topicListDataArray;
    if (self.selectedTopic != nil) {
        topicListViewController.selectedTopic = self.selectedTopic;
    }
    
    UINavigationController *topicListNavigationController = [[UINavigationController alloc] initWithRootViewController:topicListViewController];
    [self.navigationController presentViewController:topicListNavigationController animated:YES completion:nil];
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

    NSString *currentAccessToken = [TTLDataManager getAccessToken];
    TTLUserModel *currentActiveUser = [TTLDataManager getActiveUser];
    NSString *currentActiveUserID = currentActiveUser.userID;
    currentActiveUserID = [TTLUtil nullToEmptyString:currentActiveUserID];

    if ([currentAccessToken isEqualToString:@""] || [currentActiveUserID isEqualToString:@""]) {
        if ([self.obtainedFullNameString isEqualToString:@""]) {
            //Validation failed - show error full name must be filled
            [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Full Name" title:NSLocalizedStringFromTableInBundle(@"Error", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"Please enter your name", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];
        }
        else if ([self.obtainedEmailString isEqualToString:@""]) {
            //Validation failed - show error email must be filled
            [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Email" title:NSLocalizedStringFromTableInBundle(@"Error", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"Please enter your email", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

        }
        else if (!isEmailValid) {
            //Validation failed - show error invalid email format
            [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Email Format" title:NSLocalizedStringFromTableInBundle(@"Error", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"Email address format is invalid", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];
        }
    }

    if (!self.isTopicSelected) {
        //Validation failed - show error topic must be selected
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Topic" title:NSLocalizedStringFromTableInBundle(@"Error", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"Please select your topic", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

    }
    else if ([self.obtainedMessageString isEqualToString:@""]) {
        //Validation failed - show error message must be filled
        [self showPopupViewWithPopupType:TTLPopUpInfoViewControllerTypeErrorMessage popupIdentifier:@"Create Case Form Message" title:NSLocalizedStringFromTableInBundle(@"Error", nil, [TTLUtil currentBundle], @"") detailInformation:NSLocalizedStringFromTableInBundle(@"Please enter your message", nil, [TTLUtil currentBundle], @"") leftOptionButtonTitle:nil singleOrRightOptionButtonTitle:nil];

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
    if (self.isKeyboardShown) {
        return;
    }
    _isKeyboardShown = YES;
    CGFloat containerViewDistanceToBottom = CGRectGetHeight([UIScreen mainScreen].bounds) - [self.createCaseView.formContainerView.superview convertPoint:self.createCaseView.formContainerView.frame.origin toView:nil].y - CGRectGetHeight(self.createCaseView.formContainerView.frame);
    if (containerViewDistanceToBottom < 0.0f) {
        containerViewDistanceToBottom = 0.0f;
    }
    CGFloat yDifference;
    if (containerViewDistanceToBottom > keyboardHeight) {
        yDifference = 0.0f;
    }
    else {
        yDifference = keyboardHeight - containerViewDistanceToBottom;
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.createCaseView.scrollView.frame = CGRectMake(CGRectGetMinX(self.createCaseView.scrollView.frame), CGRectGetMinY(self.createCaseView.scrollView.frame), CGRectGetWidth(self.createCaseView.scrollView.frame), CGRectGetHeight(self.createCaseView.frame) - yDifference);
    }];
    [self.createCaseView.scrollView setContentOffset:CGPointMake(self.createCaseView.scrollView.contentOffset.x, self.createCaseView.scrollView.contentOffset.y + yDifference) animated:YES];
}

- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight {
    [super keyboardWillHideWithHeight:keyboardHeight];
    if (!self.isKeyboardShown) {
        return;
    }
    _isKeyboardShown = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.createCaseView.scrollView.frame = [TTLBaseView frameWithoutNavigationBar];
    }];
    [self.createCaseView.scrollView setContentOffset:CGPointMake(self.createCaseView.scrollView.contentOffset.x, 0.0f) animated:YES];
}

- (void)popUpInfoDidTappedLeftButtonWithIdentifier:(NSString *)popupIdentifier {

}

- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)popupIdentifier {
    
}

- (void)closeButtonDidTapped {
    id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
    if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCreateCaseViewWithCurrentShownNavigationController:)]) {
        [tapTalkLiveDelegate didTappedCloseButtonInCreateCaseViewWithCurrentShownNavigationController:self.navigationController];
    }
    else {
        if (self.closeRoomListWhenCreateCaseIsClosed) {
            UIViewController *vc = self.presentingViewController;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneKeyboardButtonDidTapped {
    [self.view endEditing:YES];
}

- (void)handleSubmitCaseFormFlow {
    self.createCaseView.closeButton.userInteractionEnabled = NO;
    self.createCaseView.leftCloseButton.userInteractionEnabled = NO;
    [self.createCaseView showCreateCaseButtonAsLoading:YES];
    
    [[TapTalkLive sharedInstance] authenticateUserWithFullName:self.obtainedFullNameString
                                                         email:self.obtainedEmailString
    success:^(NSString *message) {
        [self handleSubmitCaseFormFlowAfterLogin];
    }
    failure:^(NSError *error) {
        if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
            self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
        }
        
        [self.createCaseView showCreateCaseButtonAsLoading:NO];
    }];
    
//    [TTLDataManager callAPICreateUserWithFullName:self.obtainedFullNameString email:self.obtainedEmailString success:^(TTLUserModel * _Nonnull user, NSString * _Nonnull ticket) {
//        //Get TapTalkLive access token
//        [TTLDataManager callAPIGetAccessTokenWithTicket:ticket success:^{
//            //Obtain TapTalk auth ticket
//            [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:^(NSString * _Nonnull tapTalkAuthTicket) {
//                //Authenticate TapTalk.io Chat SDK
//                [[TapTalk sharedInstance] authenticateWithAuthTicket:tapTalkAuthTicket connectWhenSuccess:YES success:^{
//                    //Call API create case
//                    [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
//
//                        [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//
//                        [[TAPCoreChatRoomManager sharedManager] getChatRoomByXCRoomID:caseData.tapTalkXCRoomID success:^(TAPRoomModel * _Nonnull room) {
//                            if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                                self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//                            }
//
//                            [self.createCaseView showCreateCaseButtonAsLoading:NO];
//                            [[TapTalkLive sharedInstance] roomListViewController].isShouldNotLoadFromAPI = NO;
//                            [[[TapTalkLive sharedInstance] roomListViewController] viewLoadedSequence];
//                            [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                                [[TapUI sharedInstance] createRoomWithRoom:room success:^(TapUIChatViewController * _Nonnull chatViewController) {
//                                    [self.previousNavigationController pushViewController:chatViewController animated:YES];
//                                }];
//                            }];
//                        } failure:^(NSError * _Nonnull error) {
//                            //Error get chat room from TapTalk
//                            if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                                self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//                            }
//
//                            [self.createCaseView showCreateCaseButtonAsLoading:NO];
//                        }];
//                    } failure:^(NSError * _Nonnull error) {
//                        //Error create case
//                        if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                            self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//                        }
//
//                        [self.createCaseView showCreateCaseButtonAsLoading:NO];
//                    }];
//                } failure:^(NSError * _Nonnull error) {
//                    //Error authenticate TapTalk.io Chat SDK
//                    if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                        self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//                    }
//
//                    [self.createCaseView showCreateCaseButtonAsLoading:NO];
//                }];
//            } failure:^(NSError * _Nonnull error) {
//                //Error get TapTalk auth ticket
//                if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                    self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//                }
//
//                [self.createCaseView showCreateCaseButtonAsLoading:NO];
//            }];
//        } failure:^(NSError * _Nonnull error) {
//            //Error get access token
//            if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//                self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//            }
//
//            [self.createCaseView showCreateCaseButtonAsLoading:NO];
//        }];
//    } failure:^(NSError * _Nonnull error) {
//        //Error create user
//       if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
//            self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
//        }
//
//        [self.createCaseView showCreateCaseButtonAsLoading:NO];
//    }];
}

- (void)handleSubmitCaseFormFlowAfterLogin {
    self.createCaseView.closeButton.userInteractionEnabled = NO;
    [self.createCaseView showCreateCaseButtonAsLoading:YES];
    BOOL isTapTalkAuthenticate = [TapTalk sharedInstance].isAuthenticated;
    if (isTapTalkAuthenticate) {
        //Call API create case
        [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
            
            [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[TAPCoreChatRoomManager sharedManager] getChatRoomByXCRoomID:caseData.tapTalkXCRoomID success:^(TAPRoomModel * _Nonnull room) {
                if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                    self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
                }
                
                [self.createCaseView showCreateCaseButtonAsLoading:NO];
                [[TapTalkLive sharedInstance] roomListViewController].isShouldNotLoadFromAPI = NO;
                [[[TapTalkLive sharedInstance] roomListViewController] viewLoadedSequence];
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    [[TapUI sharedInstance] createRoomWithRoom:room success:^(TapUIChatViewController * _Nonnull chatViewController) {
                        [self.previousNavigationController pushViewController:chatViewController animated:YES];
                    }];
                }];
            } failure:^(NSError * _Nonnull error) {
                //Error get chat room from TapTalk
                if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                    self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
                }
                
                [self.createCaseView showCreateCaseButtonAsLoading:NO];
            }];
        } failure:^(NSError * _Nonnull error) {
            //Error create case
          if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
            }
            
            [self.createCaseView showCreateCaseButtonAsLoading:NO];
        }];
    }
    else {
        //Obtain TapTalk auth ticket
        [TTLDataManager callAPIGetTapTalkAuthTicketSuccess:^(NSString * _Nonnull tapTalkAuthTicket) {
            //Authenticate TapTalk.io Chat SDK
            [[TapTalk sharedInstance] authenticateWithAuthTicket:tapTalkAuthTicket connectWhenSuccess:YES success:^{
                //Call API create case
                [TTLDataManager callAPICreateCaseWithTopicID:self.selectedTopic.topicID message:self.obtainedMessageString success:^(TTLCaseModel * _Nonnull caseData) {
                    
                    [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:TTL_PREFS_IS_CONTAIN_CASE_LIST];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                        self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
                    }
                    
                    [self.createCaseView showCreateCaseButtonAsLoading:NO];
                    TapUIRoomListViewController *tapTalkRoomListViewController = [[TapUI sharedInstance] roomListViewController];
                    if ( self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            [self.previousNavigationController pushViewController:tapTalkRoomListViewController animated:YES];
                        }];
                    }
                    else {
                        [self.navigationController pushViewController:tapTalkRoomListViewController animated:YES];
                    }
                } failure:^(NSError * _Nonnull error) {
                    //Error create case
                  if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                        self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
                    }
                    
                    [self.createCaseView showCreateCaseButtonAsLoading:NO];
                }];
            } failure:^(NSError * _Nonnull error) {
                //Error authenticate TapTalk.io Chat SDK
               if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                    self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
                }
                
                [self.createCaseView showCreateCaseButtonAsLoading:NO];
            }];
        } failure:^(NSError * _Nonnull error) {
            //Error get TapTalk auth ticket
           if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
                self.createCaseView.leftCloseButton.userInteractionEnabled = YES;
            }
            
            [self.createCaseView showCreateCaseButtonAsLoading:NO];
        }];
    }
}

- (void)setCreateCaseViewControllerType:(TTLCreateCaseViewControllerType)createCaseViewControllerType {
    _createCaseViewControllerType = createCaseViewControllerType;

    if (self.createCaseViewControllerType == TTLCreateCaseViewControllerTypeAlreadyLogin) {
        [self.createCaseView showCloseButton:NO];
    }
    else {
//        id<TapTalkLiveDelegate> tapTalkLiveDelegate = [TapTalkLive sharedInstance].delegate;
//        if ([tapTalkLiveDelegate respondsToSelector:@selector(didTappedCloseButtonInCreateCaseViewWithCurrentShownNavigationController:)]) {
            //Show Close Button
            [self.createCaseView showCloseButton:YES];
//        }
//        else {
//            [self.createCaseView showCloseButton:NO];
//        }
    }
}

@end
