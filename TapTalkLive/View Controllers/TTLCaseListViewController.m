//
//  TTLCaseListViewController.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 10/02/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLCaseListViewController.h"
#import <TapTalk/TapUIRoomListViewController.h>
#import <TapTalk/TAPRoomListView.h>

@interface TTLCaseListViewController ()

@property IBOutlet UIView *brandBackgroundView;
@property IBOutlet TTLImageView *logoImageView;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UIView *cancelView;
@property IBOutlet UIButton *cancelButton;
@property IBOutlet UIView *caseListTopBackgroundView;
@property IBOutlet UIView *caseListTopSeparatorView;
@property IBOutlet UIView *sendNewChatContainerView;
@property IBOutlet UIView *sendNewChatView;
@property IBOutlet UILabel *sendNewChatLabel;
@property IBOutlet TTLImageView *sendNewChatImageView;
@property IBOutlet UIButton *sendNewChatButton;

@property IBOutlet TAPRoomListView *caseListView;

- (IBAction)cancelButtonDidTapped:(id)sender;
- (IBAction)sendNewChatButtonDidTapped:(id)sender;

@end

@implementation TTLCaseListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.brandBackgroundView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorDefaultBackground];

    self.sendNewChatView.layer.cornerRadius = 8.0f;
    self.sendNewChatView.clipsToBounds = 8.0f;
    self.sendNewChatView.backgroundColor = [[TTLStyleManager sharedManager] getComponentColorForType:TTLComponentColorDefaultBackground];
    
    self.caseListTopBackgroundView.clipsToBounds = YES;
    self.caseListTopBackgroundView.layer.cornerRadius = 8.0f;
    self.caseListTopBackgroundView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    self.caseListTopSeparatorView.clipsToBounds = YES;
    self.caseListTopSeparatorView.layer.cornerRadius = 8.0f;
    self.caseListTopSeparatorView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Custom Method
- (IBAction)cancelButtonDidTapped:(id)sender {
    
}

- (IBAction)sendNewChatButtonDidTapped:(id)sender {
    
}

@end
