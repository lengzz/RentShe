//
//  ConversationDetailVC.m
//  RentShe
//
//  Created by Lengzz on 17/6/1.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ConversationDetailVC.h"
#import "RentDetailVC.h"

@implementation ConversationDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageIsChange object:self];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    
    [self createNavbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:self.title]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RCMessageCell *messageCell = (RCMessageCell *)cell;
    messageCell.portraitStyle = RC_USER_AVATAR_CYCLE;
}

- (void)didTapCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:[UserDefaultsManager getUserId]])
    {
        return;
    }
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RentDetailVC *vc = [[RentDetailVC alloc] init];
        vc.isSelf = NO;
        vc.user_id = userId;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
