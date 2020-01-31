//
//  TTLBaseViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 30/12/19.
//  Copyright © 2019 taptalk.io. All rights reserved.
//

#import "TTLBaseViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TTLBaseViewController ()

@property (strong, nonatomic) UIImage *navigationShadowImage;
@property (nonatomic) CGFloat navigationBarShadowOpacity;

- (void)backButtonDidTapped;
- (void)closeButtonDidTapped;

@end

@implementation TTLBaseViewController

#pragma mark - Lifecycle
- (void)loadView {
    [super loadView];
    
    //Set navigation bar background color
    UIColor *navigationBarBackgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorDefaultNavigationBarBackground];
    [[UINavigationBar appearance] setBarTintColor:navigationBarBackgroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIFont *navigationTitleFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontNavigationBarTitleLabel];
    UIColor *navigationTitleColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorNavigationBarTitleLabel];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:navigationTitleColor,
       NSFontAttributeName:navigationTitleFont}];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.4;
    _navigationShadowImage = self.navigationController.navigationBar.shadowImage;
    _navigationBarShadowOpacity = self.navigationController.navigationBar.layer.shadowOpacity;
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //End Note
    
    //DV Note - To show line under navigation bar
//    [self.navigationController.navigationBar setShadowImage:self.navigationShadowImage];
    //End Note
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifdef DEBUG
    NSLog(@"Screen: %@", [self.class description]);
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self showNavigationSeparator:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Delegate
#pragma TAPPopUpInfoViewController
- (void)popUpInfoViewControllerDidTappedLeftButtonWithIdentifier:(NSString *)identifier {
    [self popUpInfoDidTappedLeftButtonWithIdentifier:identifier];
}

- (void)popUpInfoViewControllerDidTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)identifier {
    [self popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:identifier];
}

#pragma mark - Custom Method
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self keyboardWillShowWithHeight:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self keyboardWillHideWithHeight:keyboardHeight];
}

- (void)keyboardWillShowWithHeight:(CGFloat)keyboardHeight {
    
}

- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight {
    
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    
    BOOL reachable;
    NSString *status = [notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    NSInteger statusValue = [status integerValue];
    switch(statusValue)
    {
        case 0:
            //AFNetworkReachabilityStatusNotReachable
            reachable = NO;
            break;
        case 1:
            //AFNetworkReachabilityStatusReachableViaWWAN
            reachable = YES;
            break;
        case 2:
            //AFNetworkReachabilityStatusReachableViaWiFi
            reachable = YES;
            break;
        default:
            //AFNetworkReachabilityStatusUnknown
            reachable = NO;
            break;
    }
    
    [self reachabilityChangeIsReachable:reachable];
}

- (void)reachabilityChangeIsReachable:(BOOL)reachable {

}

- (void)backButtonDidTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonDidTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCustomBackButton {
    TTLImage *buttonImage = [TTLImage imageNamed:@"TTLIconBackArrow" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    buttonImage = [buttonImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconNavigationBarBackButton]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 18.0f);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)showCustomCloseButton {
    TTLImage *buttonImage = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    buttonImage = [buttonImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconNavigationBarCloseButton]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 18.0f);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)showCustomRightCloseButton {
    TTLImage *buttonImage = [TTLImage imageNamed:@"TTLIconClose" inBundle:[TTLUtil currentBundle] compatibleWithTraitCollection:nil];
    buttonImage = [buttonImage setImageTintColor:[[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorIconNavigationBarCloseButton]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 18.0f, 0.0f, 0.0f);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)showCustomCancelButton {
    //LeftBarButton
    UIFont *leftBarButtonItemFont = [[TTLStyleManager sharedManager] getComponentFontForType:TTLComponentFontNavigationBarButtonLabel];
    UIColor *leftBarButtonItemColor = [[TTLStyleManager sharedManager] getTextColorForType:TTLTextColorNavigationBarButtonLabel];
    UIButton *leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [leftBarButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:leftBarButtonItemColor forState:UIControlStateNormal];
    leftBarButton.contentEdgeInsets  = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 18.0f);
    leftBarButton.titleLabel.font = leftBarButtonItemFont;
    [leftBarButton addTarget:self action:@selector(closeButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

//Note
//Set left or right button option title to nil to set to default value ("OK" for single or right option button, "Cancel" for left option button)
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

}

- (void)popUpInfoTappedSingleButtonOrRightButtonWithIdentifier:(NSString *)popupIdentifier {

}

- (void)showNavigationSeparator:(BOOL)show {
    if (show) {
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        if (self.navigationBarShadowOpacity != 0.0f) {
            self.navigationController.navigationBar.layer.shadowOpacity = self.navigationBarShadowOpacity;
        }
        
    }
    else {
        
        if (self.navigationBarShadowOpacity == 0.0f) {
            _navigationBarShadowOpacity = self.navigationController.navigationBar.layer.shadowOpacity;
        }
        
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.layer.shadowOpacity = 0.0f;
    }
}


@end
