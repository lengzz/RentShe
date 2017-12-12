//
//  ConversationVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ConversationVC.h"
#import <RongIMLib/RCIMClient.h>

#import "ConversationCell.h"
#import "ConversationDetailVC.h"

@interface ConversationVC ()
{
    UIButton *_msgBtn;
}
@end

@implementation ConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusIsChange) name:kLoginStatusIsChange object:nil];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    self.showConversationListWhileLogOut = NO;
    self.isShowNetworkIndicatorView = NO;
    [self createNavBar];
    self.conversationListTableView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - 49);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:kRGB_Value(0xfde23d)];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)createNavBar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"消息"]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 54, 24);
    [btn setImage:[UIImage imageNamed:@"navbar_msg_off"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navbar_msg_no"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    _msgBtn = btn;
    if ([UserDefaultsManager getToken].length)
    {
        btn.selected = [UserDefaultsManager getMsgFlag];
    }
}

- (void)statusIsChange
{
    if ([UserDefaultsManager getToken].length)
    {
        _msgBtn.selected = [UserDefaultsManager getMsgFlag];
    }
}

- (void)settingClick:(UIButton *)btn
{
    if (!isLogin(self))
    {
        return;
    }
    btn.enabled = NO;
    BOOL select = btn.selected;
    [NetAPIManager setReceiveLetter:@{@"flag":@(!select)} callBack:^(BOOL success, id object) {
        btn.enabled = YES;
        if (success) {
            btn.selected = !btn.selected;
            [UserDefaultsManager setMsgFlag:btn.selected];
        }
    }];
}

- (void)notifyUpdateUnreadMessageCount
{

}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ConversationDetailVC *conversationVC = [[ConversationDetailVC alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationCell *customCell = (RCConversationCell *)cell;
    [customCell setHeaderImagePortraitStyle:RC_USER_AVATAR_CYCLE];
    
    customCell.conversationTitle.font = [UIFont systemFontOfSize:15];
    customCell.conversationTitle.textColor = kRGB_Value(0x282828);
    
    customCell.messageContentLabel.font = [UIFont systemFontOfSize:12];
    customCell.messageContentLabel.textColor = kRGB_Value(0x989898);
    
    customCell.messageCreatedTimeLabel.font = [UIFont systemFontOfSize:12];
    customCell.messageCreatedTimeLabel.textColor = kRGB_Value(0x989898);
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kWindowWidth - 15, 1)];
    line.backgroundColor = kRGB_Value(0xf2f2f2);
    return line;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
