//
//  TTLCreateCaseViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 09/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCreateCaseViewController.h"
#import "TTLCreateCaseView.h"

@interface TTLCreateCaseViewController ()

@property (strong, nonatomic) TTLCreateCaseView *createCaseView;

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
}

#pragma mark - Custom Method

@end
